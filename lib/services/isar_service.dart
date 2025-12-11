import 'dart:io';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/video_entity.dart';
import '../models/drive_account_entity.dart';
import '../models/processed_history_entity.dart';
import '../utils/video_hasher.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final dbDir = Directory('${dir.path}/HLS_DB');
      if (!await dbDir.exists()) await dbDir.create(recursive: true);

      return await Isar.open(
        [VideoItemSchema, DriveAccountSchema, ProcessedHistorySchema],
        directory: dbDir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // --- QUẢN LÝ LỊCH SỬ VĨNH CỬU (MỚI) ---

  // 1. Lấy danh sách lịch sử (Sắp xếp mới nhất lên đầu)
  Stream<List<ProcessedHistory>> watchHistory() async* {
    final isar = await db;
    yield* isar.processedHistorys
        .where()
        .sortByProcessedAtDesc() // Mới nhất lên đầu
        .watch(fireImmediately: true);
  }

  // 2. Xóa một mục lịch sử (Để cho phép encode lại file này)
  Future<void> deleteHistoryItem(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.processedHistorys.delete(id);
    });
  }

  // 3. Xóa toàn bộ lịch sử (Dọn dẹp định kỳ)
  Future<void> clearAllHistory() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.processedHistorys.clear();
    });
  }

  // --- CÁC HÀM CŨ GIỮ NGUYÊN BÊN DƯỚI ---

  Future<void> addVideo(String filePath) async {
    final isar = await db;
    final hash = await VideoHasher.getFastHash(filePath);

    // Check Queue
    final existingInQueue = await isar.videoItems
        .filter()
        .fileHashEqualTo(hash)
        .findFirst();
    if (existingInQueue != null) return;

    // Check History
    final existingInHistory = await isar.processedHistorys
        .filter()
        .fileHashEqualTo(hash)
        .findFirst();
    if (existingInHistory != null) {
      print("File này đã nằm trong lịch sử: $filePath");
      return;
    }

    final newVideo = VideoItem()
      ..inputPath = filePath
      ..fileName = filePath.split(Platform.pathSeparator).last
      ..outputDir = ""
      ..fileHash = hash
      ..status = VideoStatus.waiting
      ..progress = 0.0
      ..infoLog = "Đang chờ xử lý...";

    await isar.writeTxn(() async {
      await isar.videoItems.put(newVideo);
    });
  }

  Future<void> updateStatus(int id, VideoStatus status) async {
    final isar = await db;
    final item = await isar.videoItems.get(id);
    if (item != null) {
      await isar.writeTxn(() async {
        item.status = status;
        if (status == VideoStatus.completed) {
          item.completedAt = DateTime.now();
          item.progress = 1.0;
          item.infoLog = "Hoàn tất";

          // Lưu vào lịch sử
          final historyItem = ProcessedHistory()
            ..fileHash = item.fileHash
            ..fileName = item.fileName
            ..processedAt = DateTime.now();

          await isar.processedHistorys.put(historyItem);
        }
        await isar.videoItems.put(item);
      });
    }
  }

  // ... (Giữ nguyên toàn bộ các hàm saveDriveAccount, deleteAccount, updateQuota, updateProgress, v.v...)

  Future<void> saveDriveAccount(DriveAccount account) async {
    final isar = await db;
    if (account.isActive) {
      await isar.writeTxn(() async {
        final currentActive = await isar.driveAccounts
            .filter()
            .isActiveEqualTo(true)
            .findAll();
        for (var acc in currentActive) {
          if (acc.id != account.id) {
            acc.isActive = false;
            await isar.driveAccounts.put(acc);
          }
        }
      });
    }
    await isar.writeTxn(() async {
      await isar.driveAccounts.put(account);
    });
  }

  Future<DriveAccount?> getActiveAccount() async {
    final isar = await db;
    return await isar.driveAccounts.filter().isActiveEqualTo(true).findFirst();
  }

  Stream<List<DriveAccount>> watchAccounts() async* {
    final isar = await db;
    yield* isar.driveAccounts.where().watch(fireImmediately: true);
  }

  Future<void> deleteAccount(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.driveAccounts.delete(id);
    });
  }

  Future<void> updateUploadQuota(int accountId, int bytes) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final account = await isar.driveAccounts.get(accountId);
      if (account != null) {
        final now = DateTime.now();
        if (now.difference(account.lastUploadDate).inDays > 0 ||
            now.day != account.lastUploadDate.day) {
          account.uploadedBytesToday = 0;
          account.lastUploadDate = now;
        }
        account.uploadedBytesToday += bytes;
        await isar.driveAccounts.put(account);
      }
    });
  }

  Future<void> updateProgress(int id, double progress) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final item = await isar.videoItems.get(id);
      if (item != null) {
        item.progress = progress;
        await isar.videoItems.put(item);
      }
    });
  }

  Future<void> updateInfoLog(int id, String info) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final item = await isar.videoItems.get(id);
      if (item != null) {
        item.infoLog = info;
        await isar.videoItems.put(item);
      }
    });
  }

  Future<void> updateVideoState(int id, double progress, String logInfo) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final item = await isar.videoItems.get(id);
      if (item != null) {
        if (progress > item.progress) item.progress = progress;
        if (logInfo.isNotEmpty) item.infoLog = logInfo;
        await isar.videoItems.put(item);
      }
    });
  }

  Future<void> updateOutputPath(int id, String outDir) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final item = await isar.videoItems.get(id);
      if (item != null) {
        item.outputDir = outDir;
        await isar.videoItems.put(item);
      }
    });
  }

  Future<void> updateError(int id, String errorMsg) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final item = await isar.videoItems.get(id);
      if (item != null) {
        item.status = VideoStatus.error;
        item.errorMessage = errorMsg;
        item.infoLog = "Lỗi: $errorMsg";
        await isar.videoItems.put(item);
      }
    });
  }

  Future<void> deleteVideo(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.videoItems.delete(id);
    });
  }

  Future<void> clearAll() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.videoItems.clear();
    });
  }

  Future<void> resetStuckVideos() async {
    final isar = await db;
    final stuckItems = await isar.videoItems
        .filter()
        .statusEqualTo(VideoStatus.encoding)
        .or()
        .statusEqualTo(VideoStatus.uploading)
        .findAll();
    if (stuckItems.isNotEmpty) {
      await isar.writeTxn(() async {
        for (var item in stuckItems) {
          item.status = VideoStatus.waiting;
          item.progress = 0.0;
          item.infoLog = "Đã khôi phục sau khi tắt ứng dụng đột ngột";
          await isar.videoItems.put(item);
        }
      });
    }
  }

  Future<void> retryVideo(int id) async {
    final isar = await db;
    final item = await isar.videoItems.get(id);
    if (item != null) {
      await isar.writeTxn(() async {
        item.status = VideoStatus.waiting;
        item.progress = 0.0;
        item.infoLog = "Đang chờ thử lại...";
        item.errorMessage = null;
        await isar.videoItems.put(item);
      });
    }
  }

  Future<void> retryAllFailed() async {
    final isar = await db;
    final errorItems = await isar.videoItems
        .filter()
        .statusEqualTo(VideoStatus.error)
        .findAll();
    if (errorItems.isNotEmpty) {
      await isar.writeTxn(() async {
        for (var item in errorItems) {
          item.status = VideoStatus.waiting;
          item.progress = 0.0;
          item.infoLog = "Đang chờ thử lại...";
          item.errorMessage = null;
          await isar.videoItems.put(item);
        }
      });
    }
  }

  Future<VideoItem?> getNextWaitingVideo() async {
    final isar = await db;
    return await isar.videoItems
        .filter()
        .statusEqualTo(VideoStatus.waiting)
        .sortByAddedAt()
        .findFirst();
  }

  Stream<List<VideoItem>> watchAllVideos() async* {
    final isar = await db;
    yield* isar.videoItems.where().sortByAddedAt().watch(fireImmediately: true);
  }
}
