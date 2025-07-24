// /lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'growth_journal_screen.dart';

// 홈 화면. 사용자의 '문제 결정체'들이 나타날 공간입니다.
// MVP에서는 '성장통 극복' 템플릿을 시작하는 역할만 수행합니다.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Corito - The Cogito Journal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 레오나르도 다 빈치의 아이디어에 따라,
            // 사용자의 첫 행동을 유도하는 시각적 상징을 배치합니다.
            Icon(
              Icons.add_circle_outline,
              size: 80,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            // 마리 퀴리의 아이디어에 따라,
            // 사용자를 맞이하는 따뜻한 안내 문구를 배치합니다.
            const Text(
              '당신의 생각을 기다리고 있습니다.',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () {
                // '성장통 극복' 템플릿 여정을 시작합니다.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GrowthJournalScreen()),
                );
              },
              child: const Text(
                '\'성장통 극복\' 시작하기',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}