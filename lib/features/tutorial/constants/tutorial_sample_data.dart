import 'package:expense_tracker/features/expense/models/expense.dart';

/// 튜토리얼용 샘플 지출 데이터 (감정 변경도 적절히 섞어서 사용)
List<Expense> getTutorialSampleExpenses() {
  final now = DateTime.now();

  return [
    Expense(
      id: 1,
      title: '카페 라떼',
      amount: 5500,
      category: ExpenseCategory.food,
      date: now.subtract(const Duration(hours: 2)),
      emotion: ExpenseEmotions.good,
      memo: '친구와 즐거운 수다를 나누며 마신 커피. 오랜만에 만나서 정말 좋았어요!',
      createdAt: now.subtract(const Duration(hours: 2)),
    ),
    Expense(
      id: 2,
      title: '점심 식사',
      amount: 12000,
      category: ExpenseCategory.food,
      date: now.subtract(const Duration(hours: 5)),
      emotion: ExpenseEmotions.good,
      previousEmotion: ExpenseEmotions.normal,
      emotionChangeReason: '처음엔 그냥 배고파서 먹었는데, 생각해보니 맛있는 음식을 먹을 수 있다는 게 감사하네요',
      memo: '혼자 먹었지만 맛있는 식사였어요. 건강하게 먹을 수 있어서 감사합니다.',
      createdAt: now.subtract(const Duration(hours: 5)),
      updatedAt: now.subtract(const Duration(hours: 4)),
    ),
    Expense(
      id: 3,
      title: '새 운동화',
      amount: 89000,
      category: ExpenseCategory.shopping,
      date: now.subtract(const Duration(days: 1)),
      emotion: ExpenseEmotions.regret,
      previousEmotion: ExpenseEmotions.good,
      emotionChangeReason:
          '처음엔 예쁘고 좋다고 생각했는데, 집에 와서 보니 비슷한 신발이 이미 있었어요. 충동구매였던 것 같아요.',
      memo: '세일한다길래 샀는데... 집에 비슷한 게 있었네요. 다음엔 꼭 필요한지 생각하고 사야겠어요.',
      createdAt: now.subtract(const Duration(days: 1)),
      updatedAt: now.subtract(const Duration(hours: 12)),
    ),
    Expense(
      id: 4,
      title: '영화 티켓',
      amount: 15000,
      category: ExpenseCategory.culture,
      date: now.subtract(const Duration(days: 2)),
      emotion: ExpenseEmotions.good,
      memo: '기대했던 영화! 스토리도 좋고 영상미도 훌륭했어요. 극장에서 봐서 더 몰입감 있었습니다.',
      createdAt: now.subtract(const Duration(days: 2)),
    ),
  ];
}
