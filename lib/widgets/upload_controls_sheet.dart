import 'package:flutter/material.dart';
import '../services/encoder_service.dart';
import '../services/upload_manager.dart';

class UploadControlsSheet extends StatelessWidget {
  final UploadManager? activeUploader; // Nếu null nghĩa là đang không upload

  const UploadControlsSheet({super.key, this.activeUploader});

  @override
  Widget build(BuildContext context) {
    // Xác định đang chỉnh cái gì: Active hay Global
    final ValueNotifier<int> targetNotifier = activeUploader != null
        ? activeUploader!.concurrentLimit
        : EncoderService.globalConcurrentLimit;

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
                        activeUploader != null
                            ? "Đang upload (Realtime Control)"
                            : "Cấu hình mặc định",
                        style: TextStyle(
                          fontSize: 12,
                          color: activeUploader != null
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 30),

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
                                EncoderService.globalConcurrentLimit.value =
                                    newVal;
                                if (activeUploader != null) {
                                  activeUploader!.setConcurrency(newVal);
                                }
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
                          "Cấu hình này sẽ được áp dụng cho lượt upload tiếp theo.",
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
}
