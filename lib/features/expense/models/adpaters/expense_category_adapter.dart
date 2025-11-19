import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:hive/hive.dart';

/// 지출 카테고리 어댑터 (식비, 교통비 기타 등등...) 이것또한 숫자값이 아니라 각 고유의 이름으로 저장하는게 좋다
class ExpenseCategoryAdapter extends TypeAdapter<ExpenseCategory> {
  /// 타입 아이디
  static const adapterTypeId = 0;
  @override
  final typeId = adapterTypeId;

  @override
  ExpenseCategory read(BinaryReader reader) {
    return ExpenseCategory.values.byName(reader.readString());
  }

  @override
  void write(BinaryWriter writer, ExpenseCategory obj) {
    writer.writeString(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
