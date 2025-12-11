import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import màn hình chính

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt chữ Debug ở góc
      title: 'HLS Auto Encoder & Uploader Pro',

      // Thiết lập giao diện tối chuyên nghiệp (Dark Mode)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1E1E), // Màu nền tối dịu mắt
        ),
        useMaterial3: true,
        fontFamily: 'Segoe UI', // Font chuẩn đẹp trên Windows
        // Custom style cho Tooltip
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),

      // Trỏ về màn hình chính
      home: const EncoderHomePage(),
    );
  }
}
