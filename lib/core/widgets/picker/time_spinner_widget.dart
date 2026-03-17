import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 시간 설정하는 스피너 위젯
class TimeSpinnerWidget extends StatelessWidget {
  /// 설정된 날짜, 콜백을 받고 있습니다.
  const TimeSpinnerWidget({
    required this.selectedDate,
    required this.onTimeChanged,
    super.key,
  });

  /// 선택되어있는 날짜 (시, 분 사용)
  final DateTime selectedDate;

  /// 시간 변경 콜백
  final ValueChanged<TimeOfDay> onTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        use24hFormat: true,
        itemExtent: 40,
        initialDateTime: DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedDate.hour,
          selectedDate.minute,
        ),
        onDateTimeChanged: (DateTime newDateTime) {
          onTimeChanged(
            TimeOfDay(
              hour: newDateTime.hour,
              minute: newDateTime.minute,
            ),
          );
        },
      ),
    );
  }
}
