import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  static const String _keyWorkingDir = 'working_directory';
  static const String _keyToolDir = 'tool_directory'; // Key mới
  static const String _defaultWorkingDir = r'C:\HLS_Tool\Work';

  // --- Working Directory ---
  Future<String> getWorkingDir() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyWorkingDir) ?? _defaultWorkingDir;
  }

  Future<void> setWorkingDir(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWorkingDir, path);
  }

  // --- Tool Directory (MỚI) ---

  // Hàm này trả về null nếu chưa cài đặt (để logic bên kia tự fallback về Portable)
  Future<String?> getCustomToolDir() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToolDir);
  }

  Future<void> setToolDir(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToolDir, path);
  }

  Future<void> clearToolDir() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToolDir);
  }
}
