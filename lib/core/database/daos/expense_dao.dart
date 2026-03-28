import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/database/entities/expense_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'expense_dao.g.dart';

/// ExpenseDao 제공자
final expenseDaoProvider = Provider<ExpenseDao>((ref) {
  final db = ref.read(appDatabaseProvider);
  return ExpenseDao(db);
});

/// Expense 관련 DB 접근 객체
@DriftAccessor(tables: [ExpenseEntity])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  /// ExpenseDao 생성자
  ExpenseDao(super.attachedDatabase);

  /// 모든 지출 조회 (최신순)
  Future<List<ExpenseEntityData>> getAllExpenses() {
    return (select(
      expenseEntity,
    )..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
  }

  /// Id를 기준으로 지출 조회
  Future<ExpenseEntityData?> getById(int id) {
    return (select(
      expenseEntity,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 지출 추가
  Future<int> addExpense(ExpenseEntityCompanion entity) {
    return into(expenseEntity).insert(entity);
  }

  /// 지출 수정 (id 기준 교체)
  Future<bool> updateExpense(ExpenseEntityCompanion entity) {
    return update(expenseEntity).replace(entity);
  }

  /// 지출 삭제 (id 기준)
  Future<int> deleteExpense(int id) {
    return (delete(expenseEntity)..where((t) => t.id.equals(id))).go();
  }

  /// 제목으로 검색
  Future<List<ExpenseEntityData>> searchByTitle(String query) {
    if (query.isEmpty) {
      return getAllExpenses();
    }

    final pattern = '%${query.toLowerCase()}%';
    return (select(expenseEntity)
          ..where((t) => t.title.lower().like(pattern))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  /// 카테고리별 필터링 (카테고리는 text 컬럼)
  Future<List<ExpenseEntityData>> filterByCategory(String category) {
    return (select(expenseEntity)
          ..where((t) => t.category.equals(category))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  /// 감정 상태별 필터링 (emotion 컬럼 사용)
  Future<List<ExpenseEntityData>> filterByStatus(String emotion) {
    return (select(expenseEntity)
          ..where((t) => t.emotion.equals(emotion))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  /// 필터링된 지출 조회 (Stream)
  ///
  /// [emotion] 감정 필터 (null이면 모든 감정)
  /// [startDate] 시작 날짜
  /// [endDate] 종료 날짜 (해당 날짜의 23:59:59까지 포함)
  Stream<List<ExpenseEntityData>> watchExpenses({
    String? emotion,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final query = select(expenseEntity);

    // endDate의 하루 전체를 포함하도록 23:59:59로 조정
    final inclusiveEndDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
    );

    // 날짜 필터 (필수)
    query.where(
      (t) =>
          t.date.isBiggerOrEqualValue(startDate) &
          t.date.isSmallerOrEqualValue(inclusiveEndDate),
    );

    // 감정 필터 (선택)
    if (emotion != null) {
      query.where((t) => t.emotion.equals(emotion));
    }

    // 최신순 정렬
    query.orderBy([(t) => OrderingTerm.desc(t.date)]);

    return query.watch();
  }
}
