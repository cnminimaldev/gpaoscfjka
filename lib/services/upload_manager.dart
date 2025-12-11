import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'google_drive_service.dart';
import '../utils/encrypter_util.dart'; // <--- Import file mã hóa mới

class UploadManager {
  final GoogleDriveService _driveService = GoogleDriveService();

  final ValueNotifier<int> concurrentLimit = ValueNotifier(5);
  static const int _maxRetriesPerFile = 3;

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  String? _currentDriveFolderId;
  Function(double)? _savedProgressCallback;

  int _activeUploads = 0;
  int _totalFiles = 0;
  int _uploadedCount = 0;

  final List<File> _queue = [];
  final Map<String, String> _uploadedFileMap = {};
  final Map<String, int> _retryCounts = {};

  Completer<void>? _allFinishedCompleter;
  Completer<void>? _pauseCompleter;

  File? _historyFile;
  IOSink? _historySink;

  Future<void> processUpload(
    String pngFolderPath,
    String m3u8Path,
    String folderNameOnDrive, {
    Function(double)? onProgress,
  }) async {
    final dir = Directory(pngFolderPath);
    if (!await dir.exists())
      throw Exception("Thư mục PNG không tồn tại: $pngFolderPath");

    _savedProgressCallback = onProgress;
    _retryCounts.clear();

    // 1. History
    _historyFile = File(p.join(pngFolderPath, 'upload_history.txt'));
    await _loadHistory();

    // 2. Drive Folder
    // Lấy Root ID từ Active Account
    final rootId = await _driveService.getActiveRootFolderId();
    if (rootId == null) {
      throw Exception(
        "Tài khoản đang chọn chưa cấu hình Thư mục Gốc (Root Folder).",
      );
    }

    print("Đang kiểm tra folder trên Drive: $folderNameOnDrive");
    final driveFolderId = await _driveService.createOrGetFolder(
      folderNameOnDrive,
      rootId,
    );
    if (driveFolderId == null)
      throw Exception("Lỗi tạo folder trên Google Drive");
    _currentDriveFolderId = driveFolderId;

    // 3. Queue
    _queue.clear();
    final allPngs = dir
        .listSync()
        .whereType<File>()
        .where((f) => p.extension(f.path) == '.png')
        .toList();

    _totalFiles = allPngs.length;

    for (var f in allPngs) {
      String pngName = p.basename(f.path);
      String tsKey = pngName.replaceAll('.png', '.ts');
      if (!_uploadedFileMap.containsKey(tsKey)) {
        _queue.add(f);
      }
    }

    _uploadedCount = _totalFiles - _queue.length;
    if (_totalFiles > 0 && _savedProgressCallback != null) {
      _savedProgressCallback!(_uploadedCount / _totalFiles);
    }

    print(
      "Tổng file: $_totalFiles. Đã xong trước đó: $_uploadedCount. Cần upload: ${_queue.length}",
    );

    // 4. Run Upload
    if (_queue.isNotEmpty) {
      _historySink = _historyFile!.openWrite(mode: FileMode.append);
      _allFinishedCompleter = Completer<void>();
      _activeUploads = 0;
      _isPaused = false;
      _pauseCompleter = null;

      _scheduleNext();
      await _allFinishedCompleter!.future;
      await _historySink?.close();
    }

    // 5. Verify
    if (_uploadedCount < _totalFiles) {
      int failedCount = _totalFiles - _uploadedCount;
      throw Exception(
        "Upload thất bại. Có $failedCount file bị lỗi mạng quá $_maxRetriesPerFile lần.",
      );
    }

    // 6. Update M3U8 (Mã hóa Link)
    print("Upload hoàn tất. Đang cập nhật M3U8 (Mã hóa)...");
    await _updateM3u8Content(m3u8Path);

    if (await _historyFile!.exists()) await _historyFile!.delete();
  }

  void _scheduleNext() {
    if (_queue.isEmpty && _activeUploads == 0) {
      if (_allFinishedCompleter != null &&
          !_allFinishedCompleter!.isCompleted) {
        _allFinishedCompleter!.complete();
      }
      return;
    }
    if (_isPaused) return;

    while (_queue.isNotEmpty && _activeUploads < concurrentLimit.value) {
      if (_isPaused) break;
      final file = _queue.removeAt(0);
      _activeUploads++;

      _uploadSingleFile(file).then((success) {
        _activeUploads--;
        if (success) {
          _uploadedCount++;
          if (_totalFiles > 0 && _savedProgressCallback != null) {
            _savedProgressCallback!(_uploadedCount / _totalFiles);
          }
        }
        _scheduleNext();
      });
    }
  }

  Future<bool> _uploadSingleFile(File file) async {
    if (_isPaused && _pauseCompleter != null) await _pauseCompleter!.future;

    final folderId = _currentDriveFolderId;
    if (folderId == null) {
      _handleRetryOrDrop(file);
      return false;
    }

    try {
      final fileId = await _driveService.uploadFile(file, folderId);

      if (fileId != null) {
        String pngName = p.basename(file.path);
        String tsNameKey = pngName.replaceAll('.png', '.ts');

        _uploadedFileMap[tsNameKey] = fileId;
        _appendHistory(pngName, fileId);
        try {
          await file.delete();
        } catch (e) {
          print('Delete file error: $e');
        }

        return true;
      } else {
        try {
          _handleRetryOrDrop(file);
        } catch (e) {
          print('Handle retry drop: $e');
        }

        return false;
      }
    } catch (e) {
      print("Exception Upload: $e");
      _handleRetryOrDrop(file);
      await Future.delayed(const Duration(milliseconds: 500));
      return false;
    }
  }

  void _handleRetryOrDrop(File file) {
    final path = file.path;
    int currentRetries = _retryCounts[path] ?? 0;

    if (currentRetries < _maxRetriesPerFile) {
      _retryCounts[path] = currentRetries + 1;
      print(
        "Retry file ${p.basename(path)} (${currentRetries + 1}/$_maxRetriesPerFile)...",
      );
      _queue.add(file);
    } else {
      print("DROP file ${p.basename(path)} sau $_maxRetriesPerFile lần lỗi.");
    }
  }

  Future<void> _loadHistory() async {
    _uploadedFileMap.clear();
    if (await _historyFile!.exists()) {
      try {
        final lines = await _historyFile!.readAsLines();
        for (var line in lines) {
          final parts = line.split('|');
          if (parts.length == 2) {
            String pngName = parts[0].trim();
            String fileId = parts[1].trim();
            String tsKey = pngName.replaceAll('.png', '.ts');
            _uploadedFileMap[tsKey] = fileId;
          }
        }
        print("Đã khôi phục ${_uploadedFileMap.length} file từ lịch sử.");
      } catch (e) {
        print("Lỗi đọc history: $e");
      }
    }
  }

  void _appendHistory(String pngName, String fileId) {
    if (_historySink != null) {
      _historySink!.writeln("$pngName|$fileId");
    }
  }

  void setConcurrency(int newLimit) {
    if (newLimit < 1) return;
    concurrentLimit.value = newLimit;
    _scheduleNext();
  }

  void pause() {
    if (_isPaused) return;
    _isPaused = true;
    _pauseCompleter = Completer<void>();
    print("Đã tạm dừng upload.");
  }

  void resume() {
    if (!_isPaused) return;
    if (_currentDriveFolderId == null) return;
    _isPaused = false;
    if (_pauseCompleter != null && !_pauseCompleter!.isCompleted)
      _pauseCompleter!.complete();
    print("Tiếp tục upload...");
    _scheduleNext();
  }

  // --- SỬA HÀM NÀY ĐỂ MÃ HÓA LINK ---
  Future<void> _updateM3u8Content(String m3u8Path) async {
    final file = File(m3u8Path);
    if (!await file.exists()) return;

    List<String> lines = await file.readAsLines();
    List<String> newLines = [];

    // Prefix mới theo yêu cầu của bạn
    const String urlPrefix = "/data/hls/?id=";

    for (String line in lines) {
      String tLine = line.trim();

      // Nếu là dòng chứa tên file .ts
      if (tLine.endsWith('.ts') && !tLine.startsWith('#')) {
        if (_uploadedFileMap.containsKey(tLine)) {
          // 1. Lấy ID gốc từ Google Drive
          String originalId = _uploadedFileMap[tLine]!;

          // 2. Mã hóa ID bằng code của bạn
          String encryptedId = EncrypterUtil.encrypt(originalId);

          // 3. Ghép thành link mới
          newLines.add("$urlPrefix$encryptedId");
        } else {
          newLines.add(line); // Giữ nguyên nếu lỗi (file sẽ hỏng)
        }
      } else {
        newLines.add(line); // Giữ nguyên metadata
      }
    }

    await file.writeAsString(newLines.join('\n'));
    print("Đã mã hóa và cập nhật m3u8 thành công!");
  }
}
