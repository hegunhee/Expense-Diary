import 'package:expense_tracker/features/expense/controllers/expense_controller.dart';
import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/repositories//expense_repository.dart';
import 'package:expense_tracker/features/expense/screens/emotion_detail_screen.dart';
import 'package:expense_tracker/features/expense/screens/statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_expense_repository.dart';

void main() {
  late MockExpenseRepository mockService;

  setUp(() {
    mockService = MockExpenseRepository();
  });

  group('StatisticsScreen 테스트', () {
    testWidgets('데이터가 없을 때 안내 메시지가 표시된다', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            expenseRepositoryProvider.overrideWithValue(mockService),
            expenseControllerProvider.overrideWith(ExpenseController.new),
          ],
          child: const MaterialApp(home: StatisticsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // 안내 메시지 확인
      expect(find.text('아직 지출 데이터가 없습니다'), findsOneWidget);
      expect(find.byIcon(Icons.insert_chart_outlined), findsOneWidget);
    });
  });

  group('EmotionDetailScreen 테스트', () {
    testWidgets('해당 감정의 지출만 표시된다', (tester) async {
      // 다양한 감정의 지출 추가
      await mockService.addExpense(
        Expense(
          id: '1',
          title: '좋은 점심',
          amount: 10000,
          category: ExpenseCategory.food,
          emotion: ExpenseEmotions.good,
          date: DateTime.now(),
        ),
      );
      await mockService.addExpense(
        Expense(
          id: '2',
          title: '아까운 커피',
          amount: 5000,
          category: ExpenseCategory.food,
          emotion: ExpenseEmotions.regret,
          date: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            expenseRepositoryProvider.overrideWithValue(mockService),
          ],
          child: const MaterialApp(
            home: EmotionDetailScreen(emotion: ExpenseEmotions.good),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 잘 쓴 돈만 표시
      expect(find.text('좋은 점심'), findsOneWidget);
      expect(find.text('아까운 커피'), findsNothing);
    });

    testWidgets('요약 카드가 표시된다', (tester) async {
      // 샘플 데이터 추가
      await mockService.addExpense(
        Expense(
          id: '1',
          title: '점심',
          amount: 10000,
          category: ExpenseCategory.food,
          emotion: ExpenseEmotions.good,
          date: DateTime.now(),
        ),
      );
      await mockService.addExpense(
        Expense(
          id: '2',
          title: '저녁',
          amount: 15000,
          category: ExpenseCategory.food,
          emotion: ExpenseEmotions.good,
          date: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            expenseRepositoryProvider.overrideWithValue(mockService),
          ],
          child: const MaterialApp(
            home: EmotionDetailScreen(emotion: ExpenseEmotions.good),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 요약 카드 확인
      expect(find.text('총 2건'), findsOneWidget);
      expect(find.text('25,000원'), findsOneWidget);
    });

    testWidgets('데이터가 없을 때 안내 메시지가 표시된다', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            expenseRepositoryProvider.overrideWithValue(mockService),
          ],
          child: const MaterialApp(
            home: EmotionDetailScreen(emotion: ExpenseEmotions.good),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 안내 메시지 확인
      expect(find.text('아직 잘 쓴 돈 지출이 없습니다'), findsOneWidget);
    });

    testWidgets('지출 카드를 클릭하면 수정 화면으로 이동한다', (tester) async {
      // 샘플 데이터 추가
      await mockService.addExpense(
        Expense(
          id: '1',
          title: '점심',
          amount: 10000,
          category: ExpenseCategory.food,
          emotion: ExpenseEmotions.good,
          date: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            expenseRepositoryProvider.overrideWithValue(mockService),
          ],
          child: const MaterialApp(
            home: EmotionDetailScreen(emotion: ExpenseEmotions.good),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 지출 카드 클릭
      await tester.tap(find.text('점심'));
      await tester.pumpAndSettle();

      // 수정 화면으로 이동 확인
      expect(find.text('지출 수정'), findsOneWidget);
    });

    testWidgets('감정 변경 이력이 표시된다', (tester) async {
      // 감정 변경 이력이 있는 지출 추가
      await mockService.addExpense(
        Expense(
          id: '1',
          title: '점심',
          amount: 10000,
          category: ExpenseCategory.food,
          emotion: ExpenseEmotions.regret,
          date: DateTime.now(),
          previousEmotion: ExpenseEmotions.good,
          emotionChangeReason: '생각보다 별로였음',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            expenseRepositoryProvider.overrideWithValue(mockService),
          ],
          child: const MaterialApp(
            home: EmotionDetailScreen(emotion: ExpenseEmotions.regret),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 감정 변경 이력 확인
      expect(find.textContaining('생각보다 별로였음'), findsOneWidget);
    });
  });
}
