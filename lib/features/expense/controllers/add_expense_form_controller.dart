import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_form.dart';
import 'package:expense_tracker/features/expense/models/expense_form_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 지출 추가/수정 폼 상태
class AddExpenseFormState {
  /// 생성자
  const AddExpenseFormState({
    required this.selectedCategory,
    required this.selectedEmotion,
    required this.selectedDate,
    this.showDatePicker = false,
    this.showTimePicker = false,
  });

  /// 선택된 카테고리
  final ExpenseCategory selectedCategory;

  /// 선택된 감정
  final ExpenseEmotions selectedEmotion;

  /// 선택된 날짜 및 시간
  final DateTime selectedDate;

  /// 날짜 피커 표시 여부
  final bool showDatePicker;

  /// 시간 피커 표시 여부
  final bool showTimePicker;

  /// 복사 메서드
  AddExpenseFormState copyWith({
    ExpenseCategory? selectedCategory,
    ExpenseEmotions? selectedEmotion,
    DateTime? selectedDate,
    bool? showDatePicker,
    bool? showTimePicker,
  }) {
    return AddExpenseFormState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedEmotion: selectedEmotion ?? this.selectedEmotion,
      selectedDate: selectedDate ?? this.selectedDate,
      showDatePicker: showDatePicker ?? this.showDatePicker,
      showTimePicker: showTimePicker ?? this.showTimePicker,
    );
  }
}

/// 지출 추가/수정 폼 컨트롤러
class AddExpenseFormController
    extends FamilyNotifier<AddExpenseFormState, ExpenseFormMode> {
  @override
  AddExpenseFormState build(ExpenseFormMode arg) {
    final mode = arg;
    if (mode is Edit) {
      return AddExpenseFormState(
        selectedCategory: mode.originalExpense.category,
        selectedEmotion: mode.originalExpense.emotion,
        selectedDate: mode.originalExpense.date,
      );
    }
    return AddExpenseFormState(
      selectedCategory: ExpenseCategory.food,
      selectedEmotion: ExpenseEmotions.good,
      selectedDate: DateTime.now(),
    );
  }

  /// 카테고리 변경
  void updateCategory(ExpenseCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// 감정 변경
  void updateEmotion(ExpenseEmotions emotion) {
    state = state.copyWith(selectedEmotion: emotion);
  }

  /// 날짜 변경 (날짜 부분만)
  void updateDate(DateTime date) {
    state = state.copyWith(
      selectedDate: state.selectedDate.copyWith(
        year: date.year,
        month: date.month,
        day: date.day,
      ),
    );
  }

  /// 시간 변경
  void updateTime(TimeOfDay time) {
    state = state.copyWith(
      selectedDate: state.selectedDate.copyWith(
        hour: time.hour,
        minute: time.minute,
      ),
    );
  }

  /// 날짜 피커 토글 (시간 피커와 상호 배제)
  void toggleDatePicker() {
    final showing = !state.showDatePicker;
    state = state.copyWith(
      showDatePicker: showing,
      showTimePicker: showing ? false : state.showTimePicker,
    );
  }

  /// 시간 피커 토글 (날짜 피커와 상호 배제)
  void toggleTimePicker() {
    final showing = !state.showTimePicker;
    state = state.copyWith(
      showTimePicker: showing,
      showDatePicker: showing ? false : state.showDatePicker,
    );
  }

  /// 감정이 변경되었는지 여부
  bool isEmotionChanged(ExpenseFormMode mode) {
    return switch (mode) {
      Create() => false,
      Edit(:final originalEmotion) => originalEmotion != state.selectedEmotion,
    };
  }

  /// 새 지출 폼 생성
  ExpenseForm buildExpenseForm({
    required String title,
    required int amount,
    required String? memo,
  }) {
    return ExpenseForm(
      title: title,
      amount: amount,
      category: state.selectedCategory,
      emotion: state.selectedEmotion,
      date: state.selectedDate,
      memo: memo,
    );
  }

  /// 수정된 지출 생성
  Expense buildUpdatedExpense({
    required Edit mode,
    required String title,
    required int amount,
    required String? memo,
    required String? emotionChangeReason,
  }) {
    final emotionChanged = isEmotionChanged(mode);
    return mode.originalExpense.copyWith(
      title: title,
      category: state.selectedCategory,
      emotion: state.selectedEmotion,
      amount: amount,
      memo: memo,
      date: state.selectedDate,
      previousEmotion: emotionChanged
          ? mode.originalEmotion
          : mode.originalExpense.previousEmotion,
      emotionChangeReason: emotionChanged
          ? emotionChangeReason
          : mode.originalExpense.emotionChangeReason,
    );
  }
}

/// 지출 추가/수정 폼 컨트롤러 프로바이더
final addExpenseFormControllerProvider =
    NotifierProvider.family<
      AddExpenseFormController,
      AddExpenseFormState,
      ExpenseFormMode
    >(AddExpenseFormController.new);
