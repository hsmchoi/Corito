// /lib/screens/growth_journal_screen.dart
import 'package:flutter/material.dart';
import '../data/template_data.dart';
import '../widgets/journal_widgets.dart';

// '성장통 극복' 템플릿의 5단계 여정을 관리하는 메인 화면입니다.
// 사용자 요청에 따라, 질문을 '하나씩' 보여주고 '이펙트'를 추가하는 방식으로 개선되었습니다.
class GrowthJournalScreen extends StatefulWidget {
  const GrowthJournalScreen({super.key});

  @override
  _GrowthJournalScreenState createState() => _GrowthJournalScreenState();
}

class _GrowthJournalScreenState extends State<GrowthJournalScreen> {
  int _currentStage = 0;
  int _currentQuestionIndex = 0;
  final Map<String, String> _answers = {}; // (stage-questionIndex)를 키로 답변 저장

  void _onQuestionAnswered(String question, String answer) {
    setState(() {
      // 답변을 저장합니다.
      _answers['$_currentStage-$_currentQuestionIndex'] = answer;

      final questionsInStage = (growthTemplate[_currentStage]['questions'] as List<String>);
      
      // 현재 스테이지의 다음 질문으로 이동합니다.
      if (_currentQuestionIndex < questionsInStage.length - 1) {
        _currentQuestionIndex++;
      } else {
        // 현재 스테이지의 모든 질문에 답했을 경우, 다음 스테이지로 넘어갑니다.
        if (_currentStage < growthTemplate.length - 1) {
          _currentStage++;
          _currentQuestionIndex = 0;
        } else {
          // 모든 여정이 끝났습니다.
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stageData = growthTemplate[_currentStage];
    final stageTitle = stageData['title'] as String;
    final questions = stageData['questions'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Text('성장통 극복 (${_currentStage + 1}/5)'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stageTitle, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            
            // 마지막 단계에서는 특별한 '화해의 의식' 위젯을 보여줍니다.
            if (_currentStage == 4)
              ReconciliationWidget(
                onSubmit: () => Navigator.pop(context),
              )
            else
              // AnimatedSwitcher를 사용하여 질문이 전환될 때 부드러운 페이드 효과를 줍니다.
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: QuestionCard(
                  // key를 사용하여 AnimatedSwitcher가 다른 위젯임을 인지하게 합니다.
                  key: ValueKey<String>('$_currentStage-$_currentQuestionIndex'),
                  question: questions[_currentQuestionIndex],
                  onAnswered: (answer) {
                    _onQuestionAnswered(questions[_currentQuestionIndex], answer);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}