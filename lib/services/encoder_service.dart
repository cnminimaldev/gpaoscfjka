import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../models/video_entity.dart';
import 'isar_service.dart';
import 'config_service.dart';
import 'upload_manager.dart';

class EncoderService {
  final IsarService _isarService;
  final ConfigService _configService = ConfigService();

  static final ValueNotifier<int> globalConcurrentLimit = ValueNotifier(5);

  // --- HÀM LẤY ĐƯỜNG DẪN TOOL (ĐÃ KHÔI PHỤC) ---
  // Hàm này trả về Future vì cần đọc ConfigService
  Future<String> getToolFolder() async {
    // 1. Ưu tiên đường dẫn thủ công nếu user đã cài đặt
    final customPath = await _configService.getCustomToolDir();
    if (customPath != null && await Directory(customPath).exists()) {
      return customPath;
    }

    // 2. Nếu không có, dùng đường dẫn mặc định (Portable) cạnh file .exe
    final String exePath = Platform.resolvedExecutable;
    final String exeDir = p.dirname(exePath);
    return p.join(exeDir, 'Tools');
  }
  // ----------------------------------------------

  Process? _process;
  Timer? _dbUpdateTimer;

  UploadManager? _currentUploader;
  UploadManager? get activeUploader => _currentUploader;

  double _bufferedProgress = 0.0;
  String _bufferedLog = "";

  int _totalTasks = 1;
  int _currentTaskIndex = 0;

  EncoderService(this._isarService) {
    _loadSavedConcurrency();
  }

  Future<void> _loadSavedConcurrency() async {
    final savedLimit = await _configService.getConcurrentLimit();
    globalConcurrentLimit.value = savedLimit;
  }

  void setGlobalConcurrency(int newValue) {
    // 1. Cập nhật giá trị hiển thị UI
    globalConcurrentLimit.value = newValue;

    // 2. Lưu vào ổ cứng để lần sau mở lại vẫn còn
    _configService.setConcurrentLimit(newValue);
  }

  String _getQualityName(int quality) {
    if (quality == 720) return "hd";
    if (quality == 360) return "sd";
    return "${quality}p";
  }

  Future<void> processVideo(VideoItem item) async {
    _resetState();

    final String currentWorkingDir = await _configService.getWorkingDir();
    final workDir = Directory(currentWorkingDir);
    if (!await workDir.exists()) await workDir.create(recursive: true);

    await _isarService.updateStatus(item.id, VideoStatus.encoding);

    final String fileNameWithoutExt = p.basenameWithoutExtension(
      item.inputPath,
    );
    final String basePngOutputFolder = p.join(
      currentWorkingDir,
      'png',
      fileNameWithoutExt,
    );

    // --- LẤY ĐƯỜNG DẪN TOOL BẰNG HÀM ASYNC ---
    final String currentToolFolder = await getToolFolder();

    final String ffmpegPath = p.join(currentToolFolder, 'ffmpeg.exe');
    final String ffprobePath = p.join(currentToolFolder, 'ffprobe.exe');

    try {
      if (!await File(ffprobePath).exists()) {
        throw Exception("Thiếu file ffprobe.exe tại: $currentToolFolder");
      }

      // --- BƯỚC 1: LẤY THÔNG TIN VIDEO ---
      final probeResult = await Process.run(ffprobePath, [
        '-v',
        'error',
        '-show_entries',
        'format=duration:stream=height,r_frame_rate',
        '-of',
        'default=noprint_wrappers=1:nokey=1',
        item.inputPath,
      ]);

      final outputLines = probeResult.stdout.toString().trim().split('\n');

      double? totalDuration;
      int? inputHeight;

      for (var line in outputLines) {
        final val = double.tryParse(line.trim());
        if (val != null) {
          if (line.contains('.')) {
            if (val > 0) totalDuration = val;
          } else {
            if (val > 100) inputHeight = val.toInt();
          }
        }
      }

      if (totalDuration == null || totalDuration == 0) {
        final durRes = await Process.run(ffprobePath, [
          '-v',
          'error',
          '-show_entries',
          'format=duration',
          '-of',
          'default=noprint_wrappers=1:nokey=1',
          item.inputPath,
        ]);
        totalDuration =
            double.tryParse(durRes.stdout.toString().trim()) ?? 100.0;
      }
      if (inputHeight == null) inputHeight = 480;

      // --- BƯỚC 2: XÁC ĐỊNH CHIẾN LƯỢC ---
      List<int> targetQualities = [];
      if (inputHeight <= 360) {
        targetQualities = [360];
      } else {
        targetQualities = [720, 360];
      }

      _totalTasks = targetQualities.length;
      _currentTaskIndex = 0;

      // --- SMART RESUME ---
      bool skipEncode = true;
      for (int quality in targetQualities) {
        String qName = _getQualityName(quality);
        final subDir = Directory(p.join(basePngOutputFolder, qName));
        final m3u8File = File(p.join(subDir.path, 'output.m3u8'));

        if (!await subDir.exists() || !await m3u8File.exists()) {
          skipEncode = false;
          break;
        }
      }

      if (skipEncode) {
        print("Phát hiện dữ liệu cũ đầy đủ. Bỏ qua Encode.");
        await _isarService.updateProgress(item.id, 1.0);
        await _isarService.updateInfoLog(
          item.id,
          "Đã khôi phục bản encode cũ...",
        );
      } else {
        // --- BƯỚC 3: ENCODE ---
        _startDbTimer(item.id);

        for (int quality in targetQualities) {
          String qName = _getQualityName(quality);
          _bufferedLog =
              "Encoding $qName (${_currentTaskIndex + 1}/$_totalTasks)...";

          final String subFolderTs = p.join(
            currentWorkingDir,
            'ts',
            fileNameWithoutExt,
            qName,
          );
          final String subFolderPng = p.join(basePngOutputFolder, qName);

          final tsDir = Directory(subFolderTs);
          if (!await tsDir.exists()) await tsDir.create(recursive: true);

          // Tính GOP
          final fpsResult = await Process.run(ffprobePath, [
            '-v',
            'error',
            '-select_streams',
            'v:0',
            '-show_entries',
            'stream=r_frame_rate',
            '-of',
            'default=noprint_wrappers=1:nokey=1',
            item.inputPath,
          ]);
          final fpsStr = fpsResult.stdout.toString().trim();
          double fps = 30.0;
          if (fpsStr.contains('/')) {
            final parts = fpsStr.split('/');
            fps = double.parse(parts[0]) / double.parse(parts[1]);
          } else if (fpsStr.isNotEmpty)
            fps = double.parse(fpsStr);

          const int segmentDuration = 5;
          final int gopSize = (fps * segmentDuration).round();

          // Cấu hình Bitrate
          String currentMaxRate;
          String currentBufSize;
          if (quality == 720) {
            currentMaxRate = '2750k';
            currentBufSize = '5500k';
          } else {
            currentMaxRate = '750k';
            currentBufSize = '1500k';
          }

          String scaleFilter = "scale=-2:$quality";

          final ffmpegArgs = [
            '-y',
            '-i',
            item.inputPath,
            '-vf',
            scaleFilter,
            '-c:v',
            'h264_nvenc',
            '-pix_fmt',
            'yuv420p',
            '-profile:v',
            'high',
            '-level',
            '4.1',
            '-rc',
            'vbr',
            '-cq',
            '24',
            '-preset',
            'p6',
            '-tune',
            'hq',
            '-maxrate',
            currentMaxRate,
            '-bufsize',
            currentBufSize,
            '-g',
            '$gopSize',
            '-keyint_min',
            '$gopSize',
            '-sc_threshold',
            '0',
            '-c:a',
            'aac',
            '-b:a',
            '128k',
            '-ar',
            '48000',
            '-ac',
            '2',
            '-sn',
            '-hls_time',
            '$segmentDuration',
            '-hls_playlist_type',
            'vod',
            '-hls_flags',
            'split_by_time',
            '-hls_list_size',
            '0',
            '-hls_segment_filename',
            p.join(subFolderTs, '%03d.ts'),
            p.join(subFolderTs, 'output.m3u8'),
          ];

          await _runFfmpegWithProgress(ffmpegPath, ffmpegArgs, totalDuration);

          // Truyền currentToolFolder vào hàm convert
          await _convertToPng(subFolderTs, subFolderPng, currentToolFolder);

          _currentTaskIndex++;
        }
        _dbUpdateTimer?.cancel();
      }

      // --- BƯỚC 4: UPLOAD ---
      try {
        await _isarService.updateStatus(item.id, VideoStatus.uploading);
        await _isarService.updateProgress(item.id, 0.0);

        _bufferedLog = "Đang kết nối Google Drive...";
        await _isarService.updateInfoLog(item.id, _bufferedLog);

        final uploadManager = UploadManager();
        _currentUploader = uploadManager;
        uploadManager.concurrentLimit.value = globalConcurrentLimit.value;

        int uploadIdx = 0;
        for (int quality in targetQualities) {
          uploadIdx++;
          String qName = _getQualityName(quality);

          final String subFolderPng = p.join(basePngOutputFolder, qName);
          final String m3u8Path = p.join(subFolderPng, 'output.m3u8');
          final String folderNameOnDrive = "${fileNameWithoutExt}_$qName";

          if (!await Directory(subFolderPng).exists()) {
            print("Cảnh báo: Folder $qName không tồn tại, bỏ qua upload.");
            continue;
          }

          int lastUpdateTimestamp = 0;

          await uploadManager.processUpload(
            subFolderPng,
            m3u8Path,
            folderNameOnDrive,
            onProgress: (percent) {
              final now = DateTime.now().millisecondsSinceEpoch;

              if (now - lastUpdateTimestamp > 1000 || percent >= 1.0) {
                lastUpdateTimestamp = now;

                // Thực hiện ghi DB
                _isarService.updateProgress(item.id, percent);

                int percentInt = (percent * 100).toInt();
                String logText =
                    "Uploading $qName ($uploadIdx/${targetQualities.length}): $percentInt%";

                // Mẹo: Log cũng rất nặng, chỉ nên log các mốc quan trọng (VD: mỗi 5-10%)
                _isarService.updateInfoLog(item.id, logText);
              }
            },
          );
        }

        // --- BƯỚC 5: TẠO MASTER PLAYLIST ---
        try {
          _bufferedLog = "Đang tạo Master Playlist...";
          await _isarService.updateInfoLog(item.id, _bufferedLog);
          await _createMasterPlaylist(basePngOutputFolder, targetQualities);
        } catch (e) {
          print("Lỗi tạo master m3u8: $e");
        }

        // Force update log lần cuối
        await _isarService.updateInfoLog(item.id, "Upload hoàn tất (100%)");
        _currentUploader = null;
      } catch (e) {
        print("Lỗi Upload: $e");
        throw Exception("Upload Error: $e");
      }

      // --- HOÀN TẤT ---
      await _isarService.updateStatus(item.id, VideoStatus.completed);
      await _isarService.updateOutputPath(item.id, basePngOutputFolder);
    } catch (e) {
      _dbUpdateTimer?.cancel();
      _process?.kill();
      _currentUploader?.pause();

      print("Lỗi Process: $e");
      await _isarService.updateError(item.id, e.toString());
    } finally {
      _currentUploader = null;
    }
  }

  // --- CÁC HÀM PHỤ TRỢ ---

  Future<void> _createMasterPlaylist(
    String baseFolder,
    List<int> qualities,
  ) async {
    final masterFile = File(p.join(baseFolder, 'master.m3u8'));
    final sink = masterFile.openWrite();

    sink.writeln('#EXTM3U');
    sink.writeln('#EXT-X-VERSION:3');

    List<int> sortedQualities = List.from(qualities);
    sortedQualities.sort((a, b) => b.compareTo(a));

    for (int q in sortedQualities) {
      int bandwidth;
      String resolution;
      String qName = _getQualityName(q);

      if (q == 720) {
        bandwidth = 2750000;
        resolution = "1280x720";
      } else if (q == 360) {
        bandwidth = 750000;
        resolution = "640x360";
      } else {
        continue;
      }

      sink.writeln(
        '#EXT-X-STREAM-INF:BANDWIDTH=$bandwidth,RESOLUTION=$resolution,NAME="$qName"',
      );
      sink.writeln('$qName/output.m3u8');
    }

    await sink.close();
    print("Đã tạo Master Playlist tại: ${masterFile.path}");
  }

  Future<void> _runFfmpegWithProgress(
    String ffmpegPath,
    List<String> args,
    double totalDuration,
  ) async {
    _process = await Process.start(ffmpegPath, args);
    double currentTaskProgress = 0.0;

    _process!.stderr.transform(utf8.decoder).listen((data) {
      final timeRegExp = RegExp(r"time=(\d+):(\d+):(\d+.\d+)");
      final matches = timeRegExp.allMatches(data);
      if (matches.isNotEmpty) {
        final lastMatch = matches.last;
        final h = int.parse(lastMatch.group(1)!);
        final m = int.parse(lastMatch.group(2)!);
        final s = double.parse(lastMatch.group(3)!);
        final currentSeconds = h * 3600 + m * 60 + s;
        currentTaskProgress = (currentSeconds / totalDuration).clamp(0.0, 1.0);

        double totalProgress =
            (_currentTaskIndex * 100 + (currentTaskProgress * 100)) /
            _totalTasks /
            100;
        if (totalProgress > _bufferedProgress)
          _bufferedProgress = totalProgress;
      }

      final fpsMatch = RegExp(
        r"fps=\s*(\d+(?:\.\d+)?)",
      ).allMatches(data).lastOrNull;
      final speedMatch = RegExp(
        r"speed=\s*(\d+(?:\.\d+)?)x",
      ).allMatches(data).lastOrNull;

      String qualityLog = args.contains('scale=-2:720') ? 'hd' : 'sd';

      String info = "Encoding $qualityLog ";
      if (fpsMatch != null) info += "| FPS: ${fpsMatch.group(1)} ";
      if (speedMatch != null) info += "| Speed: ${speedMatch.group(1)}x";

      if (fpsMatch != null || speedMatch != null) _bufferedLog = info;
    });

    final exitCode = await _process!.exitCode;

    _process = null;

    if (exitCode != 0) throw Exception("FFmpeg error code: $exitCode");
  }

  void _startDbTimer(int itemId) {
    _dbUpdateTimer?.cancel();
    _dbUpdateTimer = Timer.periodic(const Duration(milliseconds: 1000), (
      timer,
    ) {
      if (_bufferedProgress > 0 || _bufferedLog.isNotEmpty) {
        _isarService.updateVideoState(itemId, _bufferedProgress, _bufferedLog);
      }
    });
  }

  void _resetState() {
    _bufferedProgress = 0.0;
    _bufferedLog = "";
    _totalTasks = 1;
    _currentTaskIndex = 0;
    _dbUpdateTimer?.cancel();
    _currentUploader = null;
  }

  void cancelCurrent() {
    _dbUpdateTimer?.cancel();
    _process?.kill();
    _currentUploader?.pause();
  }

  // --- CẬP NHẬT HÀM NÀY ĐỂ NHẬN THAM SỐ TOOL PATH ---
  Future<void> _convertToPng(
    String tsFolderPath,
    String pngFolderPath,
    String toolFolderPath,
  ) async {
    final fakeiconFolderPath = p.join(toolFolderPath, 'fakeicon');

    final fakeiconDir = Directory(fakeiconFolderPath);
    final tsDir = Directory(tsFolderPath);
    final pngDir = Directory(pngFolderPath);

    if (!await pngDir.exists()) await pngDir.create(recursive: true);
    if (!await fakeiconDir.exists()) throw Exception("Missing fakeicon folder");

    final fakeiconFiles = fakeiconDir
        .listSync()
        .where((item) => p.extension(item.path) == '.png')
        .toList();
    if (fakeiconFiles.isEmpty) throw Exception("No fake icons found");

    final tsFiles =
        tsDir
            .listSync()
            .where((item) => p.extension(item.path) == '.ts')
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

    final random = Random();

    for (final tsFile in tsFiles) {
      final randomPngFile = fakeiconFiles[random.nextInt(fakeiconFiles.length)];
      final outputFileName = '${p.basenameWithoutExtension(tsFile.path)}.png';
      final outputFile = File(p.join(pngFolderPath, outputFileName));

      final sink = outputFile.openWrite();
      await sink.addStream((randomPngFile as File).openRead());
      await sink.addStream((tsFile as File).openRead());
      await sink.close();

      await tsFile.delete();
    }

    final m3u8File = File(p.join(tsFolderPath, 'output.m3u8'));
    if (await m3u8File.exists()) {
      await m3u8File.copy(p.join(pngFolderPath, 'output.m3u8'));
    }
    try {
      await tsDir.delete(recursive: true);
    } catch (_) {}
  }
}
