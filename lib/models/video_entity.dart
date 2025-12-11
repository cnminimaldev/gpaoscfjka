import 'package:isar_community/isar.dart';

// Dòng này cực kỳ quan trọng, nó báo cho generator biết tên file sẽ sinh ra
part 'video_entity.g.dart';

@collection
class VideoItem {
  Id id = Isar.autoIncrement; // ID tự tăng (int)

  // Đường dẫn file gốc (Source)
  @Index(type: IndexType.value)
  late String inputPath;

  // Tên file để hiển thị cho gọn
  late String fileName;

  // Đường dẫn thư mục chứa kết quả (.m3u8)
  late String outputDir;

  // Mã hash "vân tay" của file (Size + Header + Middle + Footer)
  // Dùng hash để index giúp tìm kiếm cực nhanh
  @Index(type: IndexType.hash)
  late String fileHash;

  // Trạng thái hiện tại
  @enumerated
  late VideoStatus status;

  // Tiến độ: 0.0 -> 1.0
  double progress = 0.0;

  // Lưu log lỗi nếu có
  String? errorMessage;

  // Thời gian thêm vào hàng đợi
  DateTime addedAt = DateTime.now();

  // Thời gian hoàn thành (để null nếu chưa xong)
  DateTime? completedAt;

  String? infoLog;
}

// Enum định nghĩa trạng thái
enum VideoStatus {
  waiting, // Đang chờ trong hàng đợi
  encoding, // Đang chạy ffmpeg
  completed, // Đã xong 100%
  error, // Lỗi
  paused, // Tạm dừng
  canceled, // Người dùng hủy
  uploading,
}
