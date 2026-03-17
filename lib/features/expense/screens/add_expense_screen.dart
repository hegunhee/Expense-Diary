import 'package:expense_tracker/core/utils/layout_utils.dart';
import 'package:expense_tracker/core/widgets/picker/date_picker_widget.dart';
import 'package:expense_tracker/core/widgets/picker/time_spinner_widget.dart';
import 'package:expense_tracker/features/expense/controllers/add_expense_form_controller.dart';
import 'package:expense_tracker/features/expense/controllers/expense_controller.dart';
import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_form_mode.dart';
import 'package:expense_tracker/features/expense/widgets/expense_form/amount_input_field.dart';
import 'package:expense_tracker/features/expense/widgets/expense_form/category_selector_widget.dart';
import 'package:expense_tracker/features/expense/widgets/expense_form/date_time_selector_widget.dart';
import 'package:expense_tracker/features/expense/widgets/expense_form/emotion_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 지출 추가/수정 화면
class AddExpenseScreen extends ConsumerStatefulWidget {
  /// 지출 추가/수정 화면 생성자
  const AddExpenseScreen({super.key, required this.mode});

  /// 지출 추가/수정인지 판별하는 변수(수정의 경우 내부적으로 기존의 지출값을 가지고 있음)
  final ExpenseFormMode mode;

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  final _emotionChangeReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 금액 입력 제한 리스너
    _amountController.addListener(() {
      final text = _amountController.text.replaceAll(',', '');
      final amount = int.tryParse(text) ?? 0;

      if (amount > 1000000) {
        _amountController.text = '1,000,000';
        _amountController.selection = TextSelection.fromPosition(
          TextPosition(offset: _amountController.text.length),
        );

        // 토스트 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('금액은 100만원을 초과할 수 없습니다'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    // 수정 모드인 경우 기존 텍스트 데이터로 초기화
    final formMode = widget.mode;
    if (formMode is Edit) {
      _titleController.text = formMode.originalExpense.title;
      _amountController.text = formMode.originalExpense.amount
          .toString()
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
      _memoController.text = formMode.originalExpense.memo ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _memoController.dispose();
    _emotionChangeReasonController.dispose();
    super.dispose();
  }

  void _saveExpense() {
    final formController = ref.read(
      addExpenseFormControllerProvider(widget.mode).notifier,
    );
    final formMode = widget.mode;

    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('지출 이름을 입력해주세요')),
      );
      return;
    }

    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('금액을 입력해주세요')),
      );
      return;
    }

    // 감정이 변경되었는데 변경 사유를 입력하지 않은 경우
    if (formController.isEmotionChanged(formMode) &&
        _emotionChangeReasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('감정 변경 사유를 입력해주세요'),
          backgroundColor: Color(0xFFF44336),
        ),
      );
      return;
    }

    final amount =
        int.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
    final memo =
        _memoController.text.isEmpty ? null : _memoController.text;

    if (formMode is Edit) {
      final changedExpense = formController.buildUpdatedExpense(
        mode: formMode,
        title: _titleController.text,
        amount: amount,
        memo: memo,
        emotionChangeReason: _emotionChangeReasonController.text.trim(),
      );
      ref
          .read(expenseControllerProvider.notifier)
          .updateExpense(changedExpense);
    } else {
      final expenseForm = formController.buildExpenseForm(
        title: _titleController.text,
        amount: amount,
        memo: memo,
      );
      ref.read(expenseControllerProvider.notifier).addExpense(expenseForm);
    }
    Navigator.pop(context);
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, int expenseId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            '삭제 확인',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: const Text(
            '삭제 하시겠습니까?',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(expenseControllerProvider.notifier)
                    .deleteExpense(expenseId);
                Navigator.of(dialogContext).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(); // 수정 화면 닫기
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('삭제되었습니다'),
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '삭제',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formMode = widget.mode;
    final formState = ref.watch(addExpenseFormControllerProvider(formMode));
    final formController = ref.read(
      addExpenseFormControllerProvider(formMode).notifier,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          formMode is Edit ? '지출 수정' : '새로운 지출 추가',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: formMode is Edit
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.black),
                  onPressed: () => _showDeleteDialog(
                    context,
                    ref,
                    formMode.originalExpense.id,
                  ),
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: systemBarsPadding(context),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 지출 이름
                    const Text(
                      '지출 이름',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: '예) 친구와 커피',
                        hintStyle: const TextStyle(color: Color(0xFF666666)),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 금액 (위젯으로 분리)
                    AmountInputField(
                      controller: _amountController,
                    ),

                    const SizedBox(height: 24),

                    // 날짜 및 시간 선택
                    DateTimeSelectorWidget(
                      selectedDate: formState.selectedDate,
                      onDateTap: formController.toggleDatePicker,
                      onTimeTap: formController.toggleTimePicker,
                    ),

                    const SizedBox(height: 24),

                    // 날짜 피커
                    if (formState.showDatePicker)
                      DatePickerWidget(
                        selectedDate: formState.selectedDate,
                        onDateChanged: formController.updateDate,
                      ),

                    // 시간 스피너
                    if (formState.showTimePicker)
                      TimeSpinnerWidget(
                        selectedDate: formState.selectedDate,
                        onTimeChanged: formController.updateTime,
                      ),

                    if (formState.showDatePicker || formState.showTimePicker)
                      const SizedBox(height: 24),

                    // 지출 카테고리 (위젯으로 분리)
                    CategorySelectorWidget(
                      selectedCategory: formState.selectedCategory,
                      onChanged: formController.updateCategory,
                    ),

                    const SizedBox(height: 24),

                    // 감정 카테고리 (위젯으로 분리)
                    EmotionSelectorWidget(
                      selectEmotion: formState.selectedEmotion,
                      onChanged: formController.updateEmotion,
                    ),

                    // 감정 변경 사유 (감정이 변경된 경우에만 표시)
                    if (formController.isEmotionChanged(formMode)) ...[
                      const SizedBox(height: 24),
                      const Text(
                        '변경 사유',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _emotionChangeReasonController,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '왜 생각이 바뀌었나요?',
                          hintStyle: const TextStyle(color: Color(0xFF666666)),
                          filled: true,
                          fillColor: const Color(0xFFFFF9E6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFB74D),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFB74D),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF9800),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // 메모
                    const Text(
                      '메모 (선택 사항)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _memoController,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: '메모 추가...',
                        hintStyle: const TextStyle(color: Color(0xFF666666)),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 저장 버튼 - 하단 고정
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    formMode is Edit ? '수정' : '저장',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}