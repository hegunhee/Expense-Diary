import 'package:flutter/material.dart';

///  날짜 피커 위젯
class DatePickerWidget extends StatelessWidget {
  /// 날짜 피커 위젯 생성자
  const DatePickerWidget({
    required this.selectedDate,
    required this.onDateChanged,
    super.key,
  });

  /// 선택된 날짜
  final DateTime selectedDate;

  /// 날짜가 변경될 때 콜백
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: CalendarDatePicker(
        initialDate: selectedDate,

        /// 임의로 2020년부터 2100년 사이의 값을 가지도록 설정
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
        onDateChanged: onDateChanged,
      ),
    );
  }
}
