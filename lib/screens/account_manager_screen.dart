import 'package:flutter/material.dart';
import '../models/drive_account_entity.dart';
import '../services/isar_service.dart';
import '../services/google_drive_service.dart';
import '../widgets/drive_account_item.dart';

class AccountManagerScreen extends StatefulWidget {
  const AccountManagerScreen({super.key});

  @override
  State<AccountManagerScreen> createState() => _AccountManagerScreenState();
}

class _AccountManagerScreenState extends State<AccountManagerScreen> {
  final IsarService _isarService = IsarService();
  final GoogleDriveService _driveService = GoogleDriveService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý Tài khoản Google Drive"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<DriveAccount>>(
        stream: _isarService.watchAccounts(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text("Lỗi: ${snapshot.error}"));

          final accounts = snapshot.data ?? [];

          if (accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text("Chưa có tài khoản nào được kết nối."),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _addNewAccount,
                    icon: const Icon(Icons.add),
                    label: const Text("Thêm Tài Khoản Ngay"),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: accounts.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return DriveAccountItem(
                account: accounts[index],
                isarService: _isarService,
                driveService: _driveService,
                onRefresh: () {
                  // Stream tự update
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewAccount,
        icon: const Icon(Icons.person_add),
        label: const Text("Thêm Tài Khoản"),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  // --- SỬA LOGIC HÀM NÀY ---
  Future<void> _addNewAccount() async {
    // Biến cờ để kiểm soát xem người dùng có bấm Hủy hay không
    bool isCancelled = false;

    // Show Loading Dialog có nút Hủy
    showDialog(
      context: context,
      barrierDismissible: false, // Bắt buộc bấm nút mới đóng được
      builder: (ctx) => AlertDialog(
        title: const Text("Đang chờ đăng nhập"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              "Trình duyệt đã được mở.\nVui lòng đăng nhập Google để tiếp tục.",
            ),
            SizedBox(height: 10),
            Text(
              "(Nếu bạn đã tắt trình duyệt, vui lòng bấm Hủy)",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          // Nút Hủy quan trọng
          TextButton(
            onPressed: () {
              isCancelled = true;
              Navigator.pop(
                ctx,
              ); // Đóng Dialog thủ công để thoát trạng thái treo
            },
            child: const Text("Hủy bỏ", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    try {
      // Gọi service. Hàm này sẽ treo cho đến khi trình duyệt trả về kết quả.
      // Nếu user tắt trình duyệt, nó sẽ treo mãi mãi (cho đến khi timeout rất lâu).
      final newAccount = await _driveService.authenticateNewAccount();

      // --- KIỂM TRA SAU KHI HÀM TRẢ VỀ ---

      // Nếu người dùng đã bấm Hủy trong lúc chờ -> Bỏ qua mọi kết quả
      if (isCancelled) return;

      // Nếu chưa Hủy -> Tắt Dialog Loading tự động
      if (mounted) Navigator.pop(context);

      if (newAccount != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đã thêm: ${newAccount.email}")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đăng nhập thất bại hoặc bị hủy")),
          );
        }
      }
    } catch (e) {
      // Nếu có lỗi xảy ra và user chưa hủy -> Tắt dialog
      if (!isCancelled && mounted) Navigator.pop(context);
      print("Lỗi: $e");
    }
  }
}
