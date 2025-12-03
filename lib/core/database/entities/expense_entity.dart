import 'package:drift/drift.dart';

/// 지출 Entity(DB에 저장하는 값)
class ExpenseEntity extends Table {
  /// DB Primary Key : autoIncrement
  IntColumn get id => integer().autoIncrement()();

  /// 지출 이름
  TextColumn get title => text()();

  /// 지출 금액
  IntColumn get amount => integer()();

  /// 지출 카테고리
  TextColumn get category => text()();

  /// 지출 감정
  TextColumn get emotion => text()();

  /// 지출 날짜
  DateTimeColumn get date => dateTime()();

  /// 메모
  TextColumn get memo => text().nullable()();

  /// 이전 감정
  TextColumn get previousEmotion => text().nullable()();

  /// 감정 변경 사유
  TextColumn get emotionChangeReason => text().nullable()();

  /// 생성 시간
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 수정 시간
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
