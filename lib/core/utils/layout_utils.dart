import 'package:flutter/material.dart';

/// 시스템 하단 네비게이션바의 패딩을 측정해주는 함수 (추가적으로 하단에 한해서 extra 값을 추가 가능)
EdgeInsets systemBarsPadding(BuildContext context, {double extra = 0}) {
  final padding = MediaQuery.of(context).viewPadding;
  return EdgeInsets.only(bottom: padding.bottom + extra);
}
