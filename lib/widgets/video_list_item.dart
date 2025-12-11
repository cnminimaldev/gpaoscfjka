import 'package:flutter/material.dart';
import '../models/video_entity.dart';
import '../services/isar_service.dart';

class VideoListItem extends StatelessWidget {
  final VideoItem item;
  final int index;
  final IsarService isarService;

  const VideoListItem({
    super.key,
    required this.item,
    required this.index,
    required this.isarService,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    bool isProcessing = false;

    // --- 1. LOGIC XÁC ĐỊNH TRẠNG THÁI UI ---
    switch (item.status) {
      case VideoStatus.encoding:
        statusColor = Colors.blueAccent;
        statusIcon = Icons.settings_suggest; // Icon bánh răng
        statusText = 'Encoding ${(item.progress * 100).toInt()}%';
        isProcessing = true;
        break;

      case VideoStatus.uploading:
        statusColor = Colors.purpleAccent;
        statusIcon = Icons.cloud_upload_rounded; // Icon đám mây
        statusText = 'Uploading ${(item.progress * 100).toInt()}%';
        isProcessing = true;
        break;

      case VideoStatus.completed:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Hoàn tất';
        break;

      case VideoStatus.error:
        statusColor = Colors.redAccent;
        statusIcon = Icons.error_outline;
        statusText = 'Lỗi';
        break;

      case VideoStatus.waiting:
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.hourglass_empty;
        statusText = 'Đang chờ';
    }

    // --- 2. GIAO DIỆN ---
    return Container(
      // Hiệu ứng Zebra (dòng chẵn lẻ khác màu nhau cho dễ nhìn)
      color: index % 2 == 0
          ? Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.3)
          : Colors.transparent,
      height: 60, // Chiều cao cố định
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Row(
        children: [
          // A. Icon Trạng thái
          Icon(statusIcon, color: statusColor, size: 22),
          const SizedBox(width: 16),

          // B. Tên file & Info Log
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên file (Rê chuột vào sẽ hiện đường dẫn full)
                Tooltip(
                  message: item.inputPath,
                  waitDuration: const Duration(seconds: 1),
                  child: Text(
                    item.fileName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Info Log (Chỉ hiện khi chưa hoàn thành hoặc bị lỗi)
                // Logic: Ẩn đi khi completed để danh sách sạch sẽ
                if (item.status != VideoStatus.completed &&
                    item.infoLog != null &&
                    item.infoLog!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.infoLog!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // C. Progress Bar & Text Trạng thái
          if (isProcessing)
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 11,
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(item.progress * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: item.progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey[800],
                    color:
                        statusColor, // Màu thay đổi (Xanh khi Encode, Tím khi Upload)
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            )
          else
            // Nếu không chạy thì chỉ hiện text đơn giản
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: item.status == VideoStatus.completed
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),

          const SizedBox(width: 8),

          // D. Các nút thao tác (Action Buttons)

          // Nút Retry (Chỉ hiện khi lỗi)
          if (item.status == VideoStatus.error)
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.orangeAccent,
                size: 20,
              ),
              tooltip: 'Thử lại file này',
              onPressed: () => isarService.retryVideo(item.id),
              splashRadius: 20,
            ),

          // Nút Xóa (Luôn hiện)
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => isarService.deleteVideo(item.id),
            tooltip: 'Xóa khỏi danh sách',
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
