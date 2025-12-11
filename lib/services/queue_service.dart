import 'dart:async';
import 'package:flutter/foundation.dart'; // Để dùng ValueNotifier
import '../models/video_entity.dart';
import 'encoder_service.dart';
import 'isar_service.dart';
import 'upload_manager.dart';

class QueueService {
  final IsarService _isarService;
  late final EncoderService _encoderService;

  // Getter để UI có thể truy cập EncoderService và UploadManager
  EncoderService get encoderService => _encoderService;
  UploadManager? get activeUploader => _encoderService.activeUploader;

  final ValueNotifier<bool> isRunningNotifier = ValueNotifier(false);

  QueueService(this._isarService) {
    _encoderService = EncoderService(_isarService);
  }

  // Bắt đầu hàng đợi
  void startQueue() {
    if (isRunningNotifier.value) return;

    isRunningNotifier.value = true;
    _processNextItem();
  }

  // Tạm dừng
  void pauseQueue() {
    isRunningNotifier.value = false;
    // Nếu đang upload thì cũng pause upload luôn
    _encoderService.activeUploader?.pause();
  }

  // Hủy ngay lập tức
  void cancelCurrent() {
    isRunningNotifier.value = false;
    _encoderService.cancelCurrent();
  }

  // Hàm đệ quy xử lý từng file
  Future<void> _processNextItem() async {
    if (!isRunningNotifier.value) return;

    // Lấy file đang chờ ưu tiên nhất
    final item = await _isarService.getNextWaitingVideo();

    if (item == null) {
      print("Hàng đợi đã hoàn thành!");
      isRunningNotifier.value = false;
      return;
    }

    try {
      print("Bắt đầu xử lý: ${item.fileName}");

      // Gọi Encoder xử lý
      await _encoderService.processVideo(item);
    } catch (e) {
      print("Lỗi ngoại lệ ở Queue: $e");
    } finally {
      // Tiếp tục file tiếp theo sau một khoảng nghỉ nhỏ
      await Future.delayed(const Duration(milliseconds: 500));
      _processNextItem();
    }
  }
}
