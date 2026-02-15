import 'package:expense_tracker/core/utils/layout_utils.dart';
import 'package:expense_tracker/core/widgets/tutorial/tutorial_content_widget.dart';
import 'package:expense_tracker/features/expense/controllers/expense_controller.dart';
import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/screens/add_expense_screen.dart';
import 'package:expense_tracker/features/expense/screens/search_screen.dart';
import 'package:expense_tracker/features/expense/screens/statistics_screen.dart';
import 'package:expense_tracker/features/expense/widgets/expense_list/empty_expense_state.dart';
import 'package:expense_tracker/features/expense/widgets/expense_list/expense_card_widget.dart';
import 'package:expense_tracker/features/expense/widgets/expense_list/expense_summary_card.dart';
import 'package:expense_tracker/features/expense/widgets/expense_list/filter_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// 지출 목록 화면
class ExpenseListScreen extends ConsumerStatefulWidget {
  /// 지출 목록 화면 생성자
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  // 튜토리얼 타겟 키들 (지출 추가, 상단바 아래의 필터들, 지출 리스트들)
  final GlobalKey _addButtonKey = GlobalKey();
  final GlobalKey _filterKey = GlobalKey();
  final GlobalKey _expenseListKey = GlobalKey();

  var _hasShownTutorial = false;

  @override
  void initState() {
    super.initState();
  }

  void _showTutorial() {
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'filter',
        keyTarget: _filterKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            child: const TutorialContentWidget(
              title: '감정 필터',
              description: '감정별로 지출을 필터링해서 볼 수 있어요.\n 돈을 사용하고 난 감정을 확인해보세요!',
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'expense-list',
        keyTarget: _expenseListKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const TutorialContentWidget(
              title: '가계부 목록',
              description: '기록한 지출 내역을 확인하고\n클릭해서 수정하거나 삭제할 수 있어요.',
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'add-button',
        keyTarget: _addButtonKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const TutorialContentWidget(
              title: '지출 추가하기',
              description: '여기를 눌러서 새로운 지출을 기록하세요!\n감정과 함께 지출을 관리할 수 있어요.',
            ),
          ),
        ],
      ),
    ];

    TutorialCoachMark(
      targets: targets,
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expenseControllerProvider);

    // 데이터 로딩 완료 후 튜토리얼 표시 (한 번만, 추후 Controller로 관리 예정)
    if (!_hasShownTutorial && expensesAsync.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _hasShownTutorial = true;
        _showTutorial();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          '지출 목록',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bar_chart,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: systemBarsPadding(context),
        child: expensesAsync.when(
          data: (state) {
            final expenses = state.filteredExpenses;
            final selectedFilter = state.filter;
            final totalAmount = state.totalAmount;
            return Column(
              children: [
                // 필터 탭
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        FilterChipWidget(
                          key: _filterKey,
                          label: '전체',
                          isSelected: selectedFilter == null,
                          onTap: () => ref
                              .read(expenseControllerProvider.notifier)
                              .setFilter(null),
                        ),
                        const SizedBox(width: 8),
                        FilterChipWidget(
                          label: '잘 쓴 돈',
                          isSelected: selectedFilter == ExpenseEmotions.good,
                          onTap: () => ref
                              .read(expenseControllerProvider.notifier)
                              .setFilter(ExpenseEmotions.good),
                        ),
                        const SizedBox(width: 8),
                        FilterChipWidget(
                          label: '그저 그런 돈',
                          isSelected: selectedFilter == ExpenseEmotions.normal,
                          onTap: () => ref
                              .read(expenseControllerProvider.notifier)
                              .setFilter(ExpenseEmotions.normal),
                        ),
                        const SizedBox(width: 8),
                        FilterChipWidget(
                          label: '아까운 돈',
                          isSelected: selectedFilter == ExpenseEmotions.regret,
                          onTap: () => ref
                              .read(expenseControllerProvider.notifier)
                              .setFilter(ExpenseEmotions.regret),
                        ),
                        const SizedBox(width: 8),
                        FilterChipWidget(
                          label: '후회한 돈',
                          isSelected: selectedFilter == ExpenseEmotions.bad,
                          onTap: () => ref
                              .read(expenseControllerProvider.notifier)
                              .setFilter(ExpenseEmotions.bad),
                        ),
                      ],
                    ),
                  ),
                ),

                // 총 금액 (위젯으로 분리)
                ExpenseSummaryCard(
                  totalAmount: totalAmount,
                  selectedFilter: selectedFilter,
                ),

                const SizedBox(height: 8),

                // 지출 목록
                Expanded(
                  key: _expenseListKey,
                  child: expenses.isEmpty
                      ? const EmptyExpenseState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final expense = expenses[index];
                            final showDate =
                                index == 0 ||
                                !_isSameDay(
                                  expense.date,
                                  expenses[index - 1].date,
                                );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (showDate) ...[
                                  if (index > 0) const SizedBox(height: 24),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      _formatDate(expense.date),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF4CAF50),
                                      ),
                                    ),
                                  ),
                                ],
                                ExpenseCardWidget(expense: expense),
                                const SizedBox(height: 12),
                              ],
                            );
                          },
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('오류가 발생했습니다: $error')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _addButtonKey,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExpenseScreen(mode: Create()),
            ),
          );
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) {
      return '오늘';
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return '어제';
    } else {
      return DateFormat('M월 d일').format(date);
    }
  }
}
