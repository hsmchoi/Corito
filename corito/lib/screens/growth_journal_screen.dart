// /lib/screens/growth_journal_screen.dart
import 'package:flutter/material.dart';
import '../data/template_data.dart';
import '../widgets/journal_widgets.dart';

// '성장통 극복' 템플릿의 5단계 여정을 관리하는 메인 화면입니다.
class GrowthJournalScreen extends StatefulWidget {
  const GrowthJournalScreen({super.key});

  @override
  _GrowthJournalScreenState createState() => _GrowthJournalScreenState();
}

class _GrowthJournalScreenState extends State<GrowthJournalScreen> {
  int _currentStage = 0; // 현재 진행 중인 단계 (0-4)
  final Map<int, List<String>> _answers = {}; // 각 단계별 답변 저장

  void _nextStage() {
    // 모든 질문에 답했는지 간단히 확인
    if (_answers[_currentStage]?.any((answer) => answer.isEmpty) ?? true && _currentStage < 4) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 질문에 답해주세요.')),
      );
      return;
    }

    setState(() {
      if (_currentStage < growthTemplate.length - 1) {
        _currentStage++;
      } else {
        // 마지막 단계 이후, 홈으로 돌아가거나 결과 화면을 보여줄 수 있습니다.
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stageData = growthTemplate[_currentStage];
    final stageTitle = stageData['title'] as String;
    final questions = stageData['questions'] as List<String>;

    // 각 단계의 답변 리스트 초기화
    _answers.putIfAbsent(_currentStage, () => List.filled(questions.length, ''));

    return Scaffold(
      appBar: AppBar(
        title: Text('성장통 극복 (${_currentStage + 1}/5)'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stageTitle, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            // 마지막 단계에서는 특별한 '화해의 의식' 위젯을 보여줍니다.
            if (_currentStage == 4)
              ReconciliationWidget(
                onSubmit: _nextStage,
              )
            else
              // 일반 단계에서는 질문 카드들을 보여줍니다.
              ...List.generate(questions.length, (index) {
                return QuestionCard(
                  question: questions[index],
                  onChanged: (value) {
                    _answers[_currentStage]![index] = value;
                  },
                );
              }),
            const SizedBox(height: 40),
            if (_currentStage < 4)
              Center(
                child: ElevatedButton(
                  onPressed: _nextStage,
                  child: const Text('다음 단계로'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}