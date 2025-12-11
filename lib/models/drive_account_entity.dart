import 'package:isar_community/isar.dart';

part 'drive_account_entity.g.dart';

@collection
class DriveAccount {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String email; // Email tài khoản (dùng làm định danh chính)

  String? displayName;
  String? photoUrl;

  // Lưu toàn bộ chuỗi JSON Credentials để khôi phục session
  late String credentialsJson;

  // ID Folder cha trên Drive để chứa các phim upload lên
  // Mỗi tài khoản có thể trỏ vào một folder khác nhau
  String? rootFolderId;

  // Quản lý Quota (Giới hạn 750GB/ngày của Google)
  double uploadedBytesToday = 0;
  DateTime lastUploadDate = DateTime.now();

  // Cờ đánh dấu tài khoản đang được chọn sử dụng
  bool isActive = false;
}
