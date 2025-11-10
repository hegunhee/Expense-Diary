import 'package:flutter/material.dart';

/// 검색바 위젯
class SearchBarWidget extends StatelessWidget {
  /// 검색바 위젯 생성자
  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
  });
  
  /// 텍스트 컨트롤러
  final TextEditingController controller;
  
  /// 텍스트 변경 콜백
  final ValueChanged<String> onChanged;
  
  /// 초기화 콜백
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF999999)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                hintText: '지출 이름으로 검색',
                hintStyle: TextStyle(color: Color(0xFF999999)),
                border: InputBorder.none,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Color(0xFF999999)),
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}
