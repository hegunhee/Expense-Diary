import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/entities/expense_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Database 제공자
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.production();
});

/// DB 객체
@DriftDatabase(tables: [ExpenseEntity])
class AppDatabase extends _$AppDatabase {
  /// 생성자
  AppDatabase._(super.e);

  /// 실제 앱에서 사용하는 파일 기반 DB 인스턴스를 생성한다.
  factory AppDatabase.production() => AppDatabase._(_openConnection());

  /// 테스트에서만 사용하는 인메모리 DB 인스턴스를 생성한다.
  /// 앱의 실제 app.db 파일에는 어떤 영향도 주지 않는다.
  factory AppDatabase.inMemoryForTest() =>
      AppDatabase._(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase.createInBackground(file);
  });
}
