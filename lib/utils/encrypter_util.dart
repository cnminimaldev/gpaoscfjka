import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class EncrypterUtil {
  static String encrypt(String videoId) {
    String password = 'IaMnOtAlOn3';

    // Đệm khóa đến 16 byte (Padding)
    while (password.length < 16) {
      password += '\x00'; // Thêm byte null
    }

    final key = Key.fromUtf8(password);
    // Sử dụng AES Mode ECB như yêu cầu
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));

    final encrypted = encrypter.encrypt(videoId);

    // Logic encode đặc thù của bạn: Base64 -> Utf8 -> Base64
    return base64Encode(utf8.encode(encrypted.base64));
  }
}
