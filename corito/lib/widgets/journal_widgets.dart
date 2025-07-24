// /lib/widgets/journal_widgets.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

// 각 질문을 담는 카드 위젯. 한 질문에 대한 답변과 확인 로직을 포함하도록 개선되었습니다.
class QuestionCard extends StatefulWidget {
  final String question;
  final ValueChanged<String> onAnswered;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onAnswered,
  });

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final TextEditingController _textController = TextEditingController();
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _confirmAnswer() {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _isAnswered = true;
    });

    // 햅틱 피드백 (마리 퀴리의 아이디어)
    HapticFeedback.lightImpact();

    // 0.5초 후 다음 질문으로 넘어갑니다 (애니메이션 시간)
    Timer(const Duration(milliseconds: 500), () {
      widget.onAnswered(_textController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        color: Colors.white.withOpacity(0.05),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.question,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      readOnly: _isAnswered,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: '당신의 생각을 기록하십시오...',
                        hintStyle: TextStyle(color: Colors.white30),
                        border: InputBorder.none,
                      ),
                      // 답변이 확정되면 텍스트 색상을 청록색으로 변경 (레오나르도의 아이디어)
                      style: TextStyle(
                        color: _isAnswered
                            ? const Color(0xFF00ACC1)
                            : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (!_isAnswered)
                    IconButton(
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white70,
                      ),
                      onPressed: _confirmAnswer,
                      tooltip: '답변 확정',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// [5단계] 화해의 의식을 위한 특별 위젯 (이전과 동일, 변경 없음)
class ReconciliationWidget extends StatefulWidget {
  final VoidCallback onSubmit;
  const ReconciliationWidget({super.key, required this.onSubmit});

  @override
  _ReconciliationWidgetState createState() => _ReconciliationWidgetState();
}

class _ReconciliationWidgetState extends State<ReconciliationWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final String _oldBelief = "나는 무대체질이 아니야.";
  String _newTruth = "";
  bool _isReleased = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startRitual() {
    if (_newTruth.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('새로운 진실을 선언해주십시오.')));
      return;
    }
    setState(() {
      _isReleased = true;
    });
    _animationController.forward();
    // 3초 후 다음 스테이지로 넘어갑니다.
    Timer(const Duration(seconds: 4), widget.onSubmit);
  }

  @override
  Widget build(BuildContext context) {
    return _isReleased ? _buildReleaseAnimation() : _buildRitualInput();
  }

  // '화해의 의식'을 위한 입력 위젯
  Widget _buildRitualInput() {
    return Column(
      children: [
        QuestionCard(
          question: '과거의 나에게 보내는 위로와 감사의 편지를 작성하십시오.',
          onAnswered: (answer) {}, // 편지 내용은 MVP에서 저장하지 않고 즉시 확인처리
        ),
        const SizedBox(height: 20),
        Text('당신을 옭아매던 낡은 믿음:', style: TextStyle(color: Colors.orange[200])),
        Text(
          '"$_oldBelief"',
          style: TextStyle(
            fontSize: 20,
            color: Colors.orange[200],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 20),
        Card(
          color: Colors.white.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '그 믿음을 깨부술, 당신만의 \'새로운 진실\'을 선언하십시오.',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    _newTruth = value;
                  },
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: '새로운 진실을 입력...',
                    hintStyle: TextStyle(color: Colors.white30),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _startRitual, child: const Text('해방시키기')),
      ],
    );
  }

  // '해방' 애니메이션 위젯
  Widget _buildReleaseAnimation() {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final value = _animationController.value;
          return Column(
            children: [
              // 뉴턴 경의 아이디어: 낡은 믿음이 유리처럼 깨지는 연출
              FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.0, 0.3),
                  ),
                ),
                child: Text(
                  '"$_oldBelief"',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange[200],
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // 아인슈타인의 아이디어: 새로운 진실이 빛나며 나타나는 연출
              FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.4, 1.0),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00ACC1).withOpacity(value), // 청록색 빛
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00ACC1).withOpacity(value * 0.7),
                        blurRadius: 20 * value,
                        spreadRadius: 5 * value,
                      ),
                    ],
                  ),
                  child: Text(
                    '"$_newTruth"',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // 마리 퀴리의 아이디어: 편지가 하늘로 날아가는 연출
              FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.5, 1.0),
                  ),
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(0, -5),
                  ).animate(_animationController),
                  child: const Icon(
                    Icons.mail_outline,
                    size: 50,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
