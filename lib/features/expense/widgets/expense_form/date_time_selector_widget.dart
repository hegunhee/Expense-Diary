import 'package:expense_tracker/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// 날짜 및 시간 선택 위젯
class DateTimeSelectorWidget extends StatelessWidget {
  /// 날짜 및 시간 선택 위젯 생성자
  const DateTimeSelectorWidget({
    super.key,
    required this.selectedDate,
    required this.onDateTap,
    required this.onTimeTap,
  });

  /// 선택된 날짜
  final DateTime selectedDate;

  /// 날짜 탭 콜백
  final VoidCallback onDateTap;

  /// 시간 탭 콜백
  final VoidCallback onTimeTap;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '날짜 및 시간',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onDateTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF4CAF50),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${selectedDate.year}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.day.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: onTimeTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF4CAF50),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
