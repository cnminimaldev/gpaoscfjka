import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import '../models/drive_account_entity.dart';
import '../config/drive_config.dart'; // <--- Import Config
import 'isar_service.dart';

class GoogleDriveService {
  // Sử dụng Config thay vì hardcode
  final String _clientId = DriveConfig.clientId;
  final String _clientSecret = DriveConfig.clientSecret;

  final _scopes = [
    drive.DriveApi.driveFileScope,
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  final IsarService _isarService = IsarService();

  Future<drive.DriveApi?> getActiveDriveApi() async {
    final activeAccount = await _isarService.getActiveAccount();
    if (activeAccount == null) {
      print("Chưa chọn tài khoản Drive nào để upload!");
      return null;
    }

    final client = await _restoreClient(activeAccount.credentialsJson);
    if (client == null) return null;

    return drive.DriveApi(client);
  }

  Future<DriveAccount?> authenticateNewAccount() async {
    try {
      final id = ClientId(_clientId, _clientSecret);

      final client = await clientViaUserConsent(id, _scopes, (url) {
        _launchURL(url);
      });

      final userInfo = await _getUserInfo(client);
      final email = userInfo['email'] ?? 'Unknown';
      final name = userInfo['name'] ?? 'No Name';
      final photo = userInfo['picture'];

      final newAccount = DriveAccount()
        ..email = email
        ..displayName = name
        ..photoUrl = photo
        ..credentialsJson = json.encode(client.credentials)
        ..isActive = true
        ..uploadedBytesToday = 0
        ..lastUploadDate = DateTime.now()
        ..rootFolderId = "";

      await _isarService.saveDriveAccount(newAccount);
      return newAccount;
    } catch (e) {
      print("Lỗi thêm tài khoản: $e");
      return null;
    }
  }

  Future<AuthClient?> _restoreClient(String jsonContent) async {
    try {
      final credentials = AccessCredentials.fromJson(json.decode(jsonContent));
      return autoRefreshingClient(
        ClientId(_clientId, _clientSecret),
        credentials,
        http.Client(),
      );
    } catch (e) {
      print("Token lưu trữ bị lỗi: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> _getUserInfo(AuthClient client) async {
    try {
      final response = await client.get(
        Uri.parse('https://www.googleapis.com/oauth2/v2/userinfo'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print("Lỗi lấy User Info: $e");
    }
    return {};
  }

  // --- HÀM MỞ TRÌNH DUYỆT (ĐÃ SỬA ĐỂ KHÔNG BỊ 2 TAB) ---
  Future<void> _launchURL(String url) async {
    // 1. Ưu tiên tìm file Chrome.exe để chạy trực tiếp (Chính xác nhất)
    if (Platform.isWindows) {
      final List<String> chromePaths = [
        r'C:\Program Files\Google\Chrome\Application\chrome.exe',
        r'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe',
        p.join(
          Platform.environment['LOCALAPPDATA'] ?? '',
          r'Google\Chrome\Application\chrome.exe',
        ),
      ];

      for (var path in chromePaths) {
        if (await File(path).exists()) {
          try {
            // Chạy trực tiếp file exe -> Chỉ mở 1 tab
            await Process.start(path, [url]);
            return; // Thành công thì thoát luôn
          } catch (_) {}
        }
      }

      // 2. Nếu không tìm thấy file exe, mới dùng lệnh 'start chrome'
      try {
        // start chrome "url" (Quoted URL để tránh lỗi ký tự &)
        final result = await Process.run('cmd', ['/c', 'start', 'chrome', url]);
        if (result.exitCode == 0) return;
      } catch (e) {
        print("Lỗi lệnh start chrome: $e");
      }
    }

    // 3. Fallback cuối cùng: Dùng trình duyệt mặc định (Brave/Edge...)
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Không thể mở trình duyệt: $url';
    }
  }

  // ... (Các hàm API Drive phía dưới giữ nguyên) ...

  // --- HÀM TẠO FOLDER (ĐÃ CẬP NHẬT PERMISSION PUBLIC) ---
  Future<String?> createOrGetFolder(String folderName, String parentId) async {
    final api = await getActiveDriveApi();
    if (api == null) return null;

    try {
      final q =
          "mimeType = 'application/vnd.google-apps.folder' and name = '$folderName' and '$parentId' in parents and trashed = false";
      final fileList = await api.files.list(q: q);

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        return fileList.files!.first.id;
      }

      final folder = drive.File()
        ..name = folderName
        ..mimeType = 'application/vnd.google-apps.folder'
        ..parents = [parentId];

      final result = await api.files.create(folder);

      // --- THÊM: GÁN QUYỀN PUBLIC NGAY SAU KHI TẠO ---
      if (result.id != null) {
        try {
          final permission = drive.Permission()
            ..role =
                'reader' // Quyền xem
            ..type = 'anyone'; // Bất kỳ ai

          await api.permissions.create(permission, result.id!);
          print("Đã set quyền Public cho folder: ${result.id}");
        } catch (permError) {
          print("Lỗi set quyền public (có thể do Policy tổ chức): $permError");
          // Không return null ở đây, vẫn trả về ID folder để dùng tiếp
        }
      }
      // ------------------------------------------------

      return result.id;
    } catch (e) {
      print("Lỗi tạo folder: $e");
      return null;
    }
  }

  Future<String?> uploadFile(File localFile, String parentFolderId) async {
    final api = await getActiveDriveApi();
    if (api == null) return null;

    final activeAccount = await _isarService.getActiveAccount();

    try {
      final driveFile = drive.File()
        ..name = p.basename(localFile.path)
        ..parents = [parentFolderId];

      final len = localFile.lengthSync();

      // Mở stream đọc file
      final stream = localFile.openRead();
      final media = drive.Media(stream, len);

      // --- SỬA TẠI ĐÂY: THÊM .timeout() ---
      final result = await api.files
          .create(driveFile, uploadMedia: media, $fields: 'id')
          .timeout(
            const Duration(minutes: 2),
            onTimeout: () {
              // Nếu quá 3 phút mà chưa xong 1 file (thường file ts/png rất nhẹ),
              // thì coi như mạng lag, ném lỗi ra để UploadManager bắt được và retry.
              throw TimeoutException("Upload timed out after 2 minutes");
            },
          );
      // -------------------------------------

      if (activeAccount != null && result.id != null) {
        await _isarService.updateUploadQuota(activeAccount.id, len);
      }

      return result.id;
    } catch (e) {
      print("Lỗi upload file ${localFile.path}: $e");
      // Khi ném lỗi (bao gồm TimeoutException), hàm này sẽ trả về null
      // UploadManager sẽ nhận được null -> vào case catch -> kích hoạt Retry.
      return null;
    }
  }

  Future<String?> getActiveRootFolderId() async {
    final acc = await _isarService.getActiveAccount();
    if (acc != null &&
        acc.rootFolderId != null &&
        acc.rootFolderId!.isNotEmpty) {
      return acc.rootFolderId;
    }
    return null;
  }
}
