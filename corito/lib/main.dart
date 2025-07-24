// /lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CoritoApp());
}

class CoritoApp extends StatelessWidget {
  const CoritoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corito - The Cogito Journal',
      theme: ThemeData(
        // '코기토' 게임의 철학에 따라 미니멀한 다크 모드를 기본으로 설정합니다.
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF0D47A1), // 깊고 푸른 동굴의 색
        scaffoldBackgroundColor: const Color(0xFF0A192F), // 동굴 배경색
        fontFamily: 'Roboto', // 가독성 좋은 폰트
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
          headlineSmall: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFFF9800), // 주황색 커서 (불확실성)
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
