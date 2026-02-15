import 'package:flutter/material.dart';

/// 튜토리얼 컨텐츠 위젯
/// 제목과 설명을 표시하는 재사용 가능한 위젯
class TutorialContentWidget extends StatelessWidget {
  /// 튜토리얼 컨텐츠 위젯 생성자
  const TutorialContentWidget({
    required this.title,
    required this.description,
    super.key,
  });

  /// 튜토리얼 제목
  final String title;

  /// 튜토리얼 설명
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
