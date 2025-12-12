import 'package:flutter/material.dart';
import '../services/encoder_service.dart';
import '../services/upload_manager.dart';

class UploadControlsSheet extends StatelessWidget {
  final UploadManager? activeUploader;
  // [NEW] Cần service để gọi hàm setGlobalConcurrency (nơi chứa logic lưu)
  final EncoderService encoderService;

  const UploadControlsSheet({
    super.key,
    this.activeUploader,
    required this.encoderService, // Bắt buộc truyền vào
  });

  @override
  Widget build(BuildContext context) {
    // Với kiến trúc Isolate mới, activeUploader thường là null (vì nó chạy ngầm),
    // nên ta ưu tiên dùng globalConcurrentLimit.
    final ValueNotifier<int> targetNotifier =
        EncoderService.globalConcurrentLimit;

    return StatefulBuilder(
      builder: (context, setSheetState) {
        return Container(
          height: 380,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh nắm kéo (Handle)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tiêu đề
              Row(
                children: [
                  Icon(
                    activeUploader != null
                        ? Icons.cloud_sync
                        : Icons.settings_applications,
                    color: Colors.blueAccent,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Cấu hình Upload",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        // Logic hiển thị trạng thái
                        (activeUploader != null || !activeUploaderIsPaused)
                            ? "Điều khiển thời gian thực"
                            : "Cấu hình mặc định",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 30),

              // Slider chỉnh số luồng
              const Text("Số luồng upload cùng lúc (Concurrent Files):"),
              const SizedBox(height: 10),
              ValueListenableBuilder<int>(
                valueListenable: targetNotifier,
                builder: (ctx, limit, _) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.speed, size: 20, color: Colors.grey),
                          Expanded(
                            child: Slider(
                              value: limit.toDouble(),
                              min: 1,
                              max: 50,
                              divisions: 49,
                              label: "$limit",
                              activeColor: Colors.blueAccent,
                              onChanged: (val) {
                                int newVal = val.toInt();

                                // [QUAN TRỌNG] Gọi hàm này thay vì gán trực tiếp.
                                // Hàm này sẽ:
                                // 1. Update UI
                                // 2. Lưu vào ConfigService (SharedPreferences)
                                // 3. Gửi lệnh update sang Isolate (nếu đang chạy)
                                encoderService.setGlobalConcurrency(newVal);
                              },
                            ),
                          ),
                          Container(
                            width: 40,
                            alignment: Alignment.center,
                            child: Text(
                              "$limit",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              const Spacer(),

              // Nút Pause/Resume (Chỉ hiện nếu có activeUploader từ luồng chính -
              // Lưu ý: Với kiến trúc Isolate mới, activeUploader ở Main có thể là null.
              // Nếu bạn muốn Pause/Resume Isolate, cần implement thêm hàm trong EncoderService)
              if (activeUploader != null)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.pause),
                        label: const Text("Tạm dừng"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: activeUploader!.isPaused
                              ? Colors.grey
                              : Colors.orange,
                          side: BorderSide(
                            color: activeUploader!.isPaused
                                ? Colors.grey[800]!
                                : Colors.orange,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: activeUploader!.isPaused
                            ? null
                            : () {
                                activeUploader!.pause();
                                setSheetState(() {});
                              },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Tiếp tục"),
                        style: FilledButton.styleFrom(
                          backgroundColor: activeUploader!.isPaused
                              ? Colors.green
                              : Colors.grey[800],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: !activeUploader!.isPaused
                            ? null
                            : () {
                                activeUploader!.resume();
                                setSheetState(() {});
                              },
                      ),
                    ),
                  ],
                )
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Thay đổi sẽ được lưu và áp dụng ngay lập tức.",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Helper getters
  bool get activeUploaderIsPaused => activeUploader?.isPaused ?? false;
}
