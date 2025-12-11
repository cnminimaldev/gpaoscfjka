import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để format ngày tháng
import '../models/processed_history_entity.dart';
import '../services/isar_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final IsarService _isarService = IsarService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử Xử lý (Vĩnh cửu)"),
        actions: [
          // Nút xóa tất cả (Cần thận trọng)
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "Xóa toàn bộ lịch sử",
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("CẢNH BÁO NGUY HIỂM"),
                  content: const Text(
                    "Hành động này sẽ xóa sạch ký ức về các file đã làm.\n"
                    "Nếu bạn thêm lại file cũ, hệ thống sẽ Encode và Upload lại từ đầu.\n\n"
                    "Bạn có chắc chắn không?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text("Hủy"),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text("Xóa sạch"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _isarService.clearAllHistory();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // THANH TÌM KIẾM
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Tìm kiếm theo tên file...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = "");
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.toLowerCase();
                });
              },
            ),
          ),

          // DANH SÁCH LỊCH SỬ
          Expanded(
            child: StreamBuilder<List<ProcessedHistory>>(
              stream: _isarService.watchHistory(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(child: Text("Lỗi: ${snapshot.error}"));

                var history = snapshot.data ?? [];

                // Lọc theo tìm kiếm (Filter Client-side vì Isar search text cần setup phức tạp hơn)
                // Với vài nghìn record thì filter ram vẫn siêu nhanh.
                if (_searchQuery.isNotEmpty) {
                  history = history
                      .where(
                        (h) => h.fileName.toLowerCase().contains(_searchQuery),
                      )
                      .toList();
                }

                if (history.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.history, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? "Không tìm thấy kết quả"
                              : "Chưa có lịch sử xử lý",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: history.length,
                  separatorBuilder: (ctx, i) =>
                      const Divider(height: 1, thickness: 0.5),
                  itemBuilder: (context, index) {
                    final item = history[index];
                    final dateStr = DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(item.processedAt);

                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.check, color: Colors.white, size: 20),
                      ),
                      title: Text(
                        item.fileName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "Hoàn thành: $dateStr\nHash: ...${item.fileHash.substring(item.fileHash.length - 8)}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        tooltip: "Xóa khỏi lịch sử (Để làm lại)",
                        onPressed: () async {
                          // Không cần confirm quá kỹ cho việc xóa 1 item, nhưng nên hỏi nhẹ
                          final confirm = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Xóa bản ghi này?"),
                              content: Text(
                                "Sau khi xóa, nếu bạn thêm file '${item.fileName}' vào lại, ứng dụng sẽ coi như file mới và xử lý lại từ đầu.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text("Hủy"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text("Xóa"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await _isarService.deleteHistoryItem(item.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Đã xóa khỏi lịch sử"),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
