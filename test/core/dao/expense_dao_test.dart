import 'package:drift/drift.dart' hide isNotNull;
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/database/daos/expense_dao.dart';
import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ExpenseDao dao;

  setUp(() {
    // 인메모리 테스트용 DB 사용 (실제 파일에 영향 없음)
    db = AppDatabase.inMemoryForTest();
    dao = ExpenseDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ExpenseDao', () {
    test('addExpense / getAllExpenses', () async {
      final companion = ExpenseEntityCompanion.insert(
        title: '점심',
        amount: 10000,
        category: ExpenseCategory.food.name,
        emotion: ExpenseEmotions.good.name,
        date: DateTime(2024, 1, 2),
        memo: const Value('맛있었다'),
      );

      final id = await dao.addExpense(companion);
      final all = await dao.getAllExpenses();

      expect(all.length, 1);
      final row = all.first;
      expect(row.id, id);
      expect(row.title, '점심');
      expect(row.amount, 10000);
      expect(row.category, 'food');
      expect(row.emotion, 'good');
      expect(row.memo, '맛있었다');
    });

    test('getById returns correct row', () async {
      final id = await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '택시',
          amount: 8000,
          category: ExpenseCategory.transport.name,
          emotion: ExpenseEmotions.normal.name,
          date: DateTime(2024, 1, 2),
        ),
      );

      final row = await dao.getById(id);

      expect(row, isNotNull);
      expect(row!.id, id);
      expect(row.title, '택시');
      expect(row.amount, 8000);
    });

    test('updateExpense replaces row', () async {
      final id = await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '점심',
          amount: 10000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.good.name,
          date: DateTime(2024, 1, 2),
        ),
      );

      final updated = ExpenseEntityCompanion(
        id: Value(id),
        title: const Value('점심(수정)'),
        amount: const Value(12000),
        category: Value(ExpenseCategory.food.name),
        emotion: Value(ExpenseEmotions.regret.name),
        date: Value(DateTime(2024, 1, 2)),
      );

      final ok = await dao.updateExpense(updated);
      expect(ok, isTrue);

      final row = await dao.getById(id);
      expect(row, isNotNull);
      expect(row!.title, '점심(수정)');
      expect(row.amount, 12000);
      expect(row.emotion, 'regret');
    });

    test('deleteExpense removes row', () async {
      final id = await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '커피',
          amount: 5000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.good.name,
          date: DateTime(2024, 1, 3),
        ),
      );

      var all = await dao.getAllExpenses();
      expect(all.length, 1);

      await dao.deleteExpense(id);

      all = await dao.getAllExpenses();
      expect(all, isEmpty);
    });

    test('searchByTitle filters and sorts', () async {
      await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '친구랑 점심',
          amount: 15000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.good.name,
          date: DateTime(2024, 1, 2),
        ),
      );
      await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '아까운 커피',
          amount: 5000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.regret.name,
          date: DateTime(2024, 1, 2),
        ),
      );

      final result = await dao.searchByTitleOrMemo('점심');

      expect(result.length, 1);
      expect(result.first.title, '친구랑 점심');
    });

    test('filterByCategory returns only matching category', () async {
      await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '점심',
          amount: 10000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.good.name,
          date: DateTime(2024, 1, 2),
        ),
      );
      await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '지하철',
          amount: 1500,
          category: ExpenseCategory.transport.name,
          emotion: ExpenseEmotions.normal.name,
          date: DateTime(2024, 1, 2),
        ),
      );

      final food = await dao.filterByCategory(ExpenseCategory.food.name);

      expect(food.length, 1);
      expect(food.first.category, 'food');
      expect(food.first.title, '점심');
    });

    test('filterByStatus returns only matching emotion', () async {
      await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '좋은 점심',
          amount: 10000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.good.name,
          date: DateTime(2024, 1, 2),
        ),
      );
      await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '아까운 커피',
          amount: 5000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.regret.name,
          date: DateTime(2024, 1, 2),
        ),
      );

      final regret = await dao.filterByStatus(ExpenseEmotions.regret.name);

      expect(regret.length, 1);
      expect(regret.first.emotion, 'regret');
      expect(regret.first.title, '아까운 커피');
    });

    group('watchExpenses - 감정 필터링', () {
      test('감정 필터가 null이면 모든 감정 데이터 반환', () async {
        // Given: 다양한 감정의 데이터 추가
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '좋은 점심',
            amount: 10000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 15),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '아까운 커피',
            amount: 5000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.regret.name,
            date: DateTime(2024, 1, 16),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '후회한 택시',
            amount: 20000,
            category: ExpenseCategory.transport.name,
            emotion: ExpenseEmotions.bad.name,
            date: DateTime(2024, 1, 17),
          ),
        );

        // When: 감정 필터 없이 조회
        final stream = dao.watchExpenses(
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        // Then: 모든 데이터 반환
        final result = await stream.first;
        expect(result.length, 3);
      });

      test('특정 감정으로 필터링하면 해당 감정만 반환', () async {
        // Given: 다양한 감정의 데이터 추가
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '좋은 점심',
            amount: 10000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 15),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '좋은 저녁',
            amount: 15000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 16),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '아까운 커피',
            amount: 5000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.regret.name,
            date: DateTime(2024, 1, 17),
          ),
        );

        // When: 'good' 감정으로 필터링
        final stream = dao.watchExpenses(
          emotion: ExpenseEmotions.good.name,
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        // Then: 'good' 감정만 반환
        final result = await stream.first;
        expect(result.length, 2);
        expect(result.every((e) => e.emotion == 'good'), isTrue);
        expect(result.map((e) => e.title).toList(), ['좋은 저녁', '좋은 점심']);
      });
    });

    group('watchExpenses - 날짜 필터링', () {
      test('1월 전체 조회 시 1월 31일 데이터까지 포함', () async {
        // Given: 1월 1일부터 2월 1일까지 데이터 추가
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '1월 1일',
            amount: 10000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '1월 15일',
            amount: 15000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 15),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '1월 31일',
            amount: 20000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 31),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '2월 1일',
            amount: 25000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 2),
          ),
        );

        // When: 1월 전체 조회
        final stream = dao.watchExpenses(
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        // Then: 1월 데이터만 반환 (1일, 15일, 31일)
        final result = await stream.first;
        expect(result.length, 3);
        expect(result.map((e) => e.title).toList(), [
          '1월 31일',
          '1월 15일',
          '1월 1일',
        ]);
      });

      test('1월 31일 23:59:59 데이터도 포함', () async {
        // Given: 1월 31일 다양한 시간대 데이터 추가
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '1월 31일 00:00',
            amount: 10000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 31),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '1월 31일 23:59',
            amount: 15000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 31, 23, 59, 59),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '2월 1일 00:00',
            amount: 20000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 2),
          ),
        );

        // When: 1월 전체 조회
        final stream = dao.watchExpenses(
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        // Then: 1월 31일 23:59:59까지 포함, 2월 1일은 제외
        final result = await stream.first;
        expect(result.length, 2);
        expect(result.map((e) => e.title).toList(), [
          '1월 31일 23:59',
          '1월 31일 00:00',
        ]);
      });

      test('날짜 범위 밖의 데이터는 제외', () async {
        // Given: 다양한 월의 데이터 추가
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '12월 데이터',
            amount: 10000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2023, 12, 31),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '1월 데이터',
            amount: 15000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 15),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '2월 데이터',
            amount: 20000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 2),
          ),
        );

        // When: 1월만 조회
        final stream = dao.watchExpenses(
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        // Then: 1월 데이터만 반환
        final result = await stream.first;
        expect(result.length, 1);
        expect(result.first.title, '1월 데이터');
      });
    });

    group('watchExpenses - Stream 반응성', () {
      test('데이터 추가 시 Stream이 자동으로 갱신', () async {
        // Given: 초기 데이터 1개
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '초기 데이터',
            amount: 10000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 15),
          ),
        );

        final stream = dao.watchExpenses(
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        // When: Stream 구독 후 데이터 추가
        final emissions = <List<ExpenseEntityData>>[];
        final subscription = stream.listen(emissions.add);

        // 첫 번째 emit 대기
        await Future.delayed(const Duration(milliseconds: 100));

        // 새 데이터 추가
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '추가 데이터',
            amount: 15000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 16),
          ),
        );

        // Stream 갱신 대기
        await Future.delayed(const Duration(milliseconds: 100));

        // Then: Stream이 2번 emit (초기 1개 → 추가 후 2개)
        expect(emissions.length, greaterThanOrEqualTo(2));
        expect(emissions.first.length, 1);
        expect(emissions.last.length, 2);

        await subscription.cancel();
      });

      test('데이터 삭제 시 Stream이 자동으로 갱신', () async {
        // Given: 초기 데이터 2개
        final id1 = await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '데이터 1',
            amount: 10000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 15),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '데이터 2',
            amount: 15000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 16),
          ),
        );

        final stream = dao.watchExpenses(
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        // When: Stream 구독 후 데이터 삭제
        final emissions = <List<ExpenseEntityData>>[];
        final subscription = stream.listen(emissions.add);

        await Future.delayed(const Duration(milliseconds: 100));

        // 데이터 삭제
        await dao.deleteExpense(id1);

        await Future.delayed(const Duration(milliseconds: 100));

        // Then: Stream이 2번 emit (초기 2개 → 삭제 후 1개)
        expect(emissions.length, greaterThanOrEqualTo(2));
        expect(emissions.first.length, 2);
        expect(emissions.last.length, 1);
        expect(emissions.last.first.title, '데이터 2');

        await subscription.cancel();
      });

      test('데이터 수정 시 Stream이 자동으로 갱신', () async {
        // Given: 초기 데이터 1개
        final id = await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '원본 데이터',
            amount: 10000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 15),
          ),
        );

        final stream = dao.watchExpenses(
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        // When: Stream 구독 후 데이터 수정
        final emissions = <List<ExpenseEntityData>>[];
        final subscription = stream.listen(emissions.add);

        await Future.delayed(const Duration(milliseconds: 100));

        // 데이터 수정
        await dao.updateExpense(
          ExpenseEntityCompanion(
            id: Value(id),
            title: const Value('수정된 데이터'),
            amount: const Value(20000),
            category: Value(ExpenseCategory.food.name),
            emotion: Value(ExpenseEmotions.regret.name),
            date: Value(DateTime(2024, 1, 15)),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 100));

        // Then: Stream이 갱신되고 수정된 데이터 반환
        expect(emissions.length, greaterThanOrEqualTo(2));
        expect(emissions.last.first.title, '수정된 데이터');
        expect(emissions.last.first.amount, 20000);
        expect(emissions.last.first.emotion, 'regret');

        await subscription.cancel();
      });

      test('필터 범위 밖 데이터 추가 시 Stream에 영향 없음', () async {
        // Given: 1월 데이터 1개
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '1월 데이터',
            amount: 10000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 15),
          ),
        );

        final stream = dao.watchExpenses(
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        // When: Stream 구독 후 2월 데이터 추가
        final emissions = <List<ExpenseEntityData>>[];
        final subscription = stream.listen(emissions.add);

        await Future.delayed(const Duration(milliseconds: 100));

        // 2월 데이터 추가 (필터 범위 밖)
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '2월 데이터',
            amount: 15000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 2),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 100));

        // Then: 1월 필터에는 여전히 1개만 표시
        expect(emissions.last.length, 1);
        expect(emissions.last.first.title, '1월 데이터');

        await subscription.cancel();
      });
    });

    group('watchExpenses - 복합 필터링', () {
      test('감정 + 날짜 필터 동시 적용', () async {
        // Given: 다양한 감정과 날짜의 데이터
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '1월 good',
            amount: 10000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 1, 15),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '1월 regret',
            amount: 15000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.regret.name,
            date: DateTime(2024, 1, 16),
          ),
        );
        await dao.addExpense(
          ExpenseEntityCompanion.insert(
            title: '2월 good',
            amount: 20000,
            category: ExpenseCategory.food.name,
            emotion: ExpenseEmotions.good.name,
            date: DateTime(2024, 2),
          ),
        );

        // When: 1월 + good 필터
        final stream = dao.watchExpenses(
          emotion: ExpenseEmotions.good.name,
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        // Then: 1월의 good만 반환
        final result = await stream.first;
        expect(result.length, 1);
        expect(result.first.title, '1월 good');
      });
    });
  });
}
