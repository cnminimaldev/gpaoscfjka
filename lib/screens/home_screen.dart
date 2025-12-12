import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:isar_community/isar.dart';
import 'package:window_manager/window_manager.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';
import 'package:path/path.dart' as p;

import '../models/video_entity.dart';
import '../services/isar_service.dart';
import '../services/config_service.dart';
import '../services/queue_service.dart';
import '../widgets/video_list_item.dart';
import '../widgets/upload_controls_sheet.dart';
import 'account_manager_screen.dart';
import 'history_screen.dart'; // <--- IMPORT MỚI

class EncoderHomePage extends StatefulWidget {
  const EncoderHomePage({super.key});

  @override
  State<EncoderHomePage> createState() => _EncoderHomePageState();
}

class _EncoderHomePageState extends State<EncoderHomePage> with WindowListener {
  // ... (Toàn bộ code cũ giữ nguyên) ...
  final IsarService _isarService = IsarService();
  final ConfigService _configService = ConfigService();
  late final QueueService _queueService;

  String _currentWorkingDir = "Đang tải...";
  String _currentToolDir = "Mặc định (Portable)";
  final ScrollController _scrollController = ScrollController();
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _queueService = QueueService(_isarService);
    _loadConfig();
    _isarService.resetStuckVideos();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Future<void> onWindowClose() async {
    bool isRunning = _queueService.isRunningNotifier.value;
    final activeUploader = _queueService.activeUploader;
    if (activeUploader != null) isRunning = true;

    if (isRunning) {
      bool shouldClose =
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cảnh báo'),
              content: const Text(
                'Hệ thống đang xử lý (Encode/Upload).\nViệc thoát ngay lập tức có thể làm hỏng file.\n\nBạn có chắc chắn muốn thoát?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Ở lại'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Thoát ngay'),
                ),
              ],
            ),
          ) ??
          false;

      if (shouldClose) {
        _queueService.cancelCurrent();
        await windowManager.destroy();
      }
    } else {
      await windowManager.destroy();
    }
  }

  Future<void> _loadConfig() async {
    final workDir = await _configService.getWorkingDir();
    final toolDir = await _configService.getCustomToolDir();

    if (mounted) {
      setState(() {
        _currentWorkingDir = workDir;
        _currentToolDir = toolDir ?? "Mặc định (Portable)";
      });
    }
  }

  void _showUploadControls() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UploadControlsSheet(
        encoderService: _queueService.encoderService,

        activeUploader: _queueService.activeUploader,
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Cài đặt đường dẫn"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Thư mục FFmpeg & Tools:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.build,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _currentToolDir,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await _configService.clearToolDir();
                            await _loadConfig();
                            setDialogState(() {});
                          },
                          child: const Text("Đặt về Mặc định"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            String? selected = await FilePicker.platform
                                .getDirectoryPath(
                                  dialogTitle: "Chọn thư mục chứa ffmpeg.exe",
                                );
                            if (selected != null) {
                              if (await File(
                                p.join(selected, 'ffmpeg.exe'),
                              ).exists()) {
                                await _configService.setToolDir(selected);
                                await _loadConfig();
                                setDialogState(() {});
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Thư mục này không chứa file ffmpeg.exe!",
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text("Chọn thư mục"),
                        ),
                      ],
                    ),

                    const Divider(height: 30),

                    const Text(
                      "Thư mục Output (Working Dir):",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.folder_shared,
                            size: 16,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _currentWorkingDir,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            String?
                            selected = await FilePicker.platform.getDirectoryPath(
                              dialogTitle:
                                  "Chọn thư mục làm việc (Nên chọn ổ NVMe/SSD)",
                            );
                            if (selected != null) {
                              await _configService.setWorkingDir(selected);
                              await _loadConfig();
                              setDialogState(() {});
                            }
                          },
                          child: const Text("Thay đổi"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Đóng"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (detail) async {
        setState(() => _isDragging = false);
        await _handleDroppedFiles(detail.files);
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                _buildToolbar(),
                const Divider(height: 1, thickness: 1),
                Expanded(child: _buildQueueList()),
                _buildStatusBar(),
              ],
            ),
            if (_isDragging)
              Container(
                color: Colors.blue.withOpacity(0.2),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_upload, size: 80, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        "Thả video vào đây",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: _pickFiles,
            icon: const Icon(Icons.add),
            label: const Text('Thêm Video'),
          ),
          const SizedBox(width: 12),

          ValueListenableBuilder<bool>(
            valueListenable: _queueService.isRunningNotifier,
            builder: (context, isRunning, child) {
              return FilledButton.icon(
                onPressed: () => isRunning
                    ? _queueService.pauseQueue()
                    : _queueService.startQueue(),
                style: FilledButton.styleFrom(
                  backgroundColor: isRunning ? Colors.orange : null,
                ),
                icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(isRunning ? 'Tạm dừng' : 'Bắt đầu'),
              );
            },
          ),

          const VerticalDivider(
            width: 32,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),

          OutlinedButton.icon(
            onPressed: _showUploadControls,
            icon: const Icon(Icons.cloud_queue),
            label: const Text('Cấu hình Upload'),
          ),

          const SizedBox(width: 8),

          // Nút Quản lý Account
          IconButton.filledTonal(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const AccountManagerScreen(),
                ),
              );
            },
            icon: const Icon(Icons.manage_accounts),
            tooltip: 'Quản lý Tài khoản Drive',
          ),

          // --- NÚT MỚI: LỊCH SỬ VĨNH CỬU ---
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const HistoryScreen()),
              );
            },
            icon: const Icon(Icons.history), // Icon đồng hồ/lịch sử
            tooltip: 'Lịch sử đã hoàn thành',
          ),

          // ---------------------------------
          const SizedBox(width: 8),

          // Nút Retry All
          IconButton(
            onPressed: () async {
              await _isarService.retryAllFailed();
              if (!_queueService.isRunningNotifier.value) {
                _queueService.startQueue();
              }
              if (mounted)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Đã thêm các file lỗi vào lại hàng đợi"),
                  ),
                );
            },
            icon: const Icon(Icons.refresh, color: Colors.orange),
            tooltip: "Thử lại các file lỗi",
          ),

          const Spacer(),

          IconButton(
            onPressed: _showSettingsDialog,
            icon: const Icon(Icons.settings),
            tooltip: 'Cài đặt đường dẫn',
          ),

          IconButton(
            onPressed: () async {
              final confirm =
                  await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Xác nhận"),
                      content: const Text(
                        "Xóa toàn bộ danh sách hiện tại?\n(Lịch sử vĩnh cửu vẫn sẽ được giữ lại)",
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
                  ) ??
                  false;
              if (confirm) await _isarService.clearAll();
            },
            icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
            tooltip: 'Xóa danh sách',
          ),
        ],
      ),
    );
  }

  Widget _buildQueueList() {
    return StreamBuilder<List<VideoItem>>(
      stream: _isarService.watchAllVideos(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        final videos = snapshot.data ?? [];

        if (videos.isEmpty) {
          return Center(
            child: Text(
              'Danh sách trống',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        return ListView.separated(
          controller: _scrollController,
          itemCount: videos.length,
          separatorBuilder: (ctx, i) =>
              const Divider(height: 1, thickness: 0.5),
          itemBuilder: (context, index) {
            return VideoListItem(
              item: videos[index],
              index: index,
              isarService: _isarService,
            );
          },
        );
      },
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Row(
        children: [
          Text('Ready', style: TextStyle(fontSize: 11)),
          Spacer(),
          Text(
            'GPU: NVENC H.264 | Cloud: GDrive Multi-Account',
            style: TextStyle(fontSize: 11, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mkv', 'avi', 'mp4', 'mov', 'flv', 'ts'],
    );
    if (result != null) {
      int count = 0;
      for (var file in result.files) {
        if (file.path != null) {
          await _isarService.addVideo(file.path!);
          count++;
        }
      }
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Đã thêm $count video')));
    }
  }

  Future<void> _handleDroppedFiles(List<XFile> files) async {
    final validExtensions = ['.mkv', '.avi', '.mp4', '.mov', '.flv', '.ts'];
    int count = 0;
    for (var file in files) {
      final path = file.path;
      if (await File(path).exists()) {
        if (validExtensions.contains(p.extension(path).toLowerCase())) {
          await _isarService.addVideo(path);
          count++;
        }
      } else if (await Directory(path).exists()) {
        try {
          final dirFiles = Directory(path).listSync();
          for (var entity in dirFiles) {
            if (entity is File &&
                validExtensions.contains(
                  p.extension(entity.path).toLowerCase(),
                )) {
              await _isarService.addVideo(entity.path);
              count++;
            }
          }
        } catch (_) {}
      }
    }
    if (mounted && count > 0)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã thêm $count video')));
  }

  Future<void> _changeWorkingDir() async {
    String? selected = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "Chọn thư mục làm việc",
    );
    if (selected != null) {
      await _configService.setWorkingDir(selected);
      await _loadConfig();
    }
  }
}
