import 'package:flutter/material.dart';

/// 시스템 하단 네비게이션바의 패딩을 측정해주는 함수 (추가적으로 하단에 한해서 extra 값을 추가 가능)
/// 키보드가 올라왔을 때는 하단 패딩을 적용하지 않음
EdgeInsets systemBarsPadding(BuildContext context, {double extra = 0}) {
  final padding = MediaQuery.of(context).viewPadding;
  final viewInsets = MediaQuery.of(context).viewInsets;

  // 키보드가 올라왔을 때는 하단 패딩 제거
  final bottomPadding = viewInsets.bottom > 0 ? 0.0 : padding.bottom + extra;

  return EdgeInsets.only(bottom: bottomPadding);
}
