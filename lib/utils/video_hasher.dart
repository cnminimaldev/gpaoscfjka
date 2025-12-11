import 'dart:io';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class VideoHasher {
  static Future<String> getFastHash(String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw Exception("File không tồn tại: $filePath");
    }

    final len = await file.length(); // Lấy kích thước file

    // Mở file để đọc random
    final raf = await file.open(mode: FileMode.read);

    try {
      // Tăng kích thước mẫu lên 64KB để an toàn hơn khi bỏ qua Time
      const int sampleSize = 64 * 1024;

      final output = AccumulatorSink<Digest>();
      final input = md5.startChunkedConversion(output);

      // 1. Luôn đưa kích thước file vào hash (Yếu tố quan trọng nhất)
      input.add(utf8.encode('$len'));

      // Trường hợp file quá nhỏ (nhỏ hơn 3 lần mẫu thử) -> Đọc hết
      if (len < sampleSize * 3) {
        input.add(await raf.read(len));
      } else {
        // 2. Đọc ĐẦU file
        await raf.setPosition(0);
        input.add(await raf.read(sampleSize));

        // 3. Đọc GIỮA file (Quan trọng để thay thế yếu tố Thời gian)
        // Vị trí giữa = Tổng chia 2 trừ đi nửa mẫu thử
        final middlePos = (len ~/ 2) - (sampleSize ~/ 2);
        await raf.setPosition(middlePos);
        input.add(await raf.read(sampleSize));

        // 4. Đọc CUỐI file
        await raf.setPosition(len - sampleSize);
        input.add(await raf.read(sampleSize));
      }

      input.close();
      final digest = output.events.single;

      return digest.toString();
    } catch (e) {
      rethrow;
    } finally {
      await raf.close();
    }
  }
}
