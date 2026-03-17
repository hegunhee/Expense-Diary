import 'package:expense_tracker/features/expense/models/expense.dart';

/// 지출 추가/수정 모드 (이 화면에 진입한게 추가인지 수정인지 판별하기 위해 사용되는 클래스 )
sealed class ExpenseFormMode {
  const ExpenseFormMode();
}

/// 추가 모드
class Create extends ExpenseFormMode {
  /// 추가의 경우 아무런 값을 가지고 있지 않기때문에 빈 생성자
  const Create();
}

/// 수정 모드
class Edit extends ExpenseFormMode {
  /// 생성자 (기존의 지출 정보와, 감정 상태를 보유중)
  Edit(this.originalExpense, this.originalEmotion);

  /// 기존에 저장되어있는 지출 정보
  final Expense originalExpense;

  /// 기존에 저장되어있는 감정 상태 (기존의 감정이 많이 사용되므로 변수로 추출함)
  final ExpenseEmotions originalEmotion;
}
