import 'package:flutter/material.dart';
import '../models/drive_account_entity.dart';
import '../services/isar_service.dart';
import '../services/google_drive_service.dart';

class DriveAccountItem extends StatelessWidget {
  final DriveAccount account;
  final IsarService isarService;
  final GoogleDriveService driveService;
  final VoidCallback onRefresh; // Callback để reload list sau khi sửa

  const DriveAccountItem({
    super.key,
    required this.account,
    required this.isarService,
    required this.driveService,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // Tính % quota (ví dụ 750GB)
    const double dailyQuota = 750.0 * 1024 * 1024 * 1024; // 750GB
    double usagePercent = (account.uploadedBytesToday / dailyQuota).clamp(
      0.0,
      1.0,
    );
    String usageString = _formatBytes(account.uploadedBytesToday.toInt());

    bool isConfigured =
        account.rootFolderId != null && account.rootFolderId!.isNotEmpty;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: account.isActive
            ? const BorderSide(color: Colors.blueAccent, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                // 1. Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundImage: account.photoUrl != null
                      ? NetworkImage(account.photoUrl!)
                      : null,
                  child: account.photoUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 16),

                // 2. Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.displayName ?? "No Name",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        account.email,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      // Folder Status
                      Row(
                        children: [
                          Icon(
                            isConfigured
                                ? Icons.folder_open
                                : Icons.warning_amber_rounded,
                            size: 14,
                            color: isConfigured ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              isConfigured
                                  ? "Folder ID: ...${account.rootFolderId!.substring(account.rootFolderId!.length - 6)}"
                                  : "Chưa cấu hình thư mục gốc",
                              style: TextStyle(
                                fontSize: 11,
                                color: isConfigured
                                    ? Colors.grey
                                    : Colors.orange,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Switch Active
                Column(
                  children: [
                    Switch(
                      value: account.isActive,
                      onChanged: (val) async {
                        if (val) {
                          account.isActive = true;
                          await isarService.saveDriveAccount(account);
                          onRefresh(); // Refresh để UI update cái cũ thành inactive
                        }
                      },
                    ),
                    const Text("Sử dụng", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),

            // 4. Quota Bar & Actions
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Quota hôm nay: $usageString / 750 GB",
                            style: const TextStyle(fontSize: 11),
                          ),
                          Text(
                            "${(usagePercent * 100).toStringAsFixed(1)}%",
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: usagePercent,
                        minHeight: 4,
                        backgroundColor: Colors.grey[800],
                        color: usagePercent > 0.9 ? Colors.red : Colors.blue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Nút Cấu hình Folder
                IconButton(
                  icon: const Icon(
                    Icons.create_new_folder_outlined,
                    color: Colors.blueAccent,
                  ),
                  tooltip: 'Cấu hình thư mục gốc',
                  onPressed: () => _showFolderConfigDialog(context),
                ),

                // Nút Xóa
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  tooltip: 'Xóa tài khoản',
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Xóa tài khoản?"),
                        content: Text("Bạn có chắc muốn xóa ${account.email}?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text("Hủy"),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text("Xóa"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await isarService.deleteAccount(account.id);
                      onRefresh();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper format bytes
  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes.toString().length - 1) ~/ 3; // Log10 approximation
    if (i >= suffixes.length) i = suffixes.length - 1; // Limit index
    // Fix logic đơn giản hơn:
    double val = bytes / 1;
    int suffixIndex = 0;
    while (val >= 1024 && suffixIndex < suffixes.length - 1) {
      val /= 1024;
      suffixIndex++;
    }
    return '${val.toStringAsFixed(2)} ${suffixes[suffixIndex]}';
  }

  // --- DIALOG CẤU HÌNH FOLDER ---
  void _showFolderConfigDialog(BuildContext context) {
    final TextEditingController folderNameController = TextEditingController();
    final TextEditingController folderIdController = TextEditingController(
      text: account.rootFolderId,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cấu hình Thư mục Gốc"),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Đây là nơi chứa tất cả phim upload lên.\nBạn có thể dán ID folder có sẵn hoặc tạo mới.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Option 1: Dán ID
              TextField(
                controller: folderIdController,
                decoration: const InputDecoration(
                  labelText: "Google Drive Folder ID (Có sẵn)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
              ),

              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(padding: EdgeInsets.all(8.0), child: Text("HOẶC")),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              // Option 2: Tạo Mới
              TextField(
                controller: folderNameController,
                decoration: const InputDecoration(
                  labelText: "Tên thư mục mới để tạo (VD: My_Movies)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.create_new_folder),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          FilledButton(
            onPressed: () async {
              // Logic xử lý
              String? finalId = folderIdController.text.trim();

              // Nếu user nhập tên mới -> Gọi API tạo
              if (folderNameController.text.isNotEmpty) {
                // Tạo ngay tại root của Drive (parentId = 'root') hoặc 1 folder cố định nào đó
                // Ở đây ta tạo tại 'root' của Drive account đó
                final newId = await driveService.createOrGetFolder(
                  folderNameController.text.trim(),
                  'root', // 'root' là alias cho thư mục gốc của Drive
                );

                if (newId != null) {
                  finalId = newId;
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Đã tạo folder mới: $newId")),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Lỗi tạo folder!")),
                    );
                  }
                  return;
                }
              }

              if (finalId != null && finalId.isNotEmpty) {
                account.rootFolderId = finalId;
                // Nếu account này đang active, ta cần save nó lại nhưng cẩn thận logic saveDriveAccount
                // Hàm saveDriveAccount logic cũ sẽ tắt active cái khác, ở đây ta chỉ update chính nó nên ok.
                await isarService.saveDriveAccount(account);
                onRefresh();
                if (context.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text("Lưu Cấu Hình"),
          ),
        ],
      ),
    );
  }
}
