import 'package:expense_tracker/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// 앱 전체에서 사용되는 테마 설정을 정의하는 클래스
class AppTheme {
  /// 라이트 모드 테마 설정을 반환합니다.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // datePicker는 고유 Theme 데이터의 색상을 가지므로 설정
      datePickerTheme: DatePickerThemeData(
        todayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.light.surface;
          }
          return AppColors.light.tertiary;
        }),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.light.primary;
          }
          return AppColors.light.surface;
        }),
        todayBorder: BorderSide.none,
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.light.primary;
          }
          return null;
        }),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppColors.light,
      ],
    );
  }
}
