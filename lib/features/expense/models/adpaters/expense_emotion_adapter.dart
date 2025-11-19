import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:hive/hive.dart';

/// 지출 감정 어댑터(DB용, ordial값보다는 name값을 사용하고싶어서 직접 커스텀)
class ExpenseEmotionsAdapter extends TypeAdapter<ExpenseEmotions> {
  @override
  final typeId = 1;

  @override
  ExpenseEmotions read(BinaryReader reader) {
    return ExpenseEmotions.values.byName(reader.readString());
  }

  @override
  void write(BinaryWriter writer, ExpenseEmotions obj) {
    writer.writeString(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseEmotionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
