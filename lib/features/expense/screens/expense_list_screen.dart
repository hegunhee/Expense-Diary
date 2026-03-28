import 'package:expense_tracker/core/themes/app_colors.dart';
import 'package:expense_tracker/core/utils/layout_utils.dart';
import 'package:expense_tracker/core/widgets/tutorial/tutorial_content_widget.dart';
import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_filter.dart';
import 'package:expense_tracker/features/expense/providers/expense_list_stream_provider.dart';
import 'package:expense_tracker/features/expense/screens/add_expense_screen.dart';
import 'package:expense_tracker/features/expense/screens/search_screen.dart';
import 'package:expense_tracker/features/expense/screens/statistics_screen.dart';
import 'package:expense_tracker/features/expense/widgets/expense_list/empty_expense_state.dart';
import 'package:expense_tracker/features/expense/widgets/expense_list/expense_card_widget.dart';
import 'package:expense_tracker/features/expense/widgets/expense_list/expense_summary_card.dart';
import 'package:expense_tracker/features/expense/widgets/expense_list/filter_chip_widget.dart';
import 'package:expense_tracker/features/tutorial/controllers/tutorial_controller.dart';
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

  // 필터 상태
  late ExpenseFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = ExpenseFilter.thisMonth();
  }

  void _updateFilter(ExpenseFilter newFilter) {
    setState(() {
      _filter = newFilter;
    });
  }

  /// 튜토리얼 모드인지 확인
  bool _isTutorialMode(TutorialState tutorialState) {
    return !tutorialState.hasSeenTutorial &&
        tutorialState.tutorialData.isNotEmpty;
  }

  /// 표시할 지출 목록 가져오기 (튜토리얼 모드면 샘플 데이터, 아니면 실제 데이터)
  List<Expense> _getDisplayExpenses(
    TutorialState tutorialState,
    List<Expense> realExpenses,
  ) {
    return _isTutorialMode(tutorialState)
        ? tutorialState.tutorialData
        : realExpenses;
  }

  /// 총 금액 계산 (튜토리얼 모드면 샘플 데이터 기준, 아니면 실제 데이터 기준)
  int _getTotalAmount(TutorialState tutorialState, int realTotalAmount) {
    return _isTutorialMode(tutorialState)
        ? tutorialState.tutorialData.fold<int>(0, (sum, e) => sum + e.amount)
        : realTotalAmount;
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
              description: '감정별로 지출을 필터링해서 볼 수 있어요.\n 지출이 발생한 감정을 확인해보세요!',
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
              description: '새로운 지출을 기록하세요!\n감정과 함께 지출을 관리할 수 있어요.',
            ),
          ),
        ],
      ),
    ];

    TutorialCoachMark(
      targets: targets,
      onFinish: () {
        // 튜토리얼 완료 시 상태 저장
        ref.read(tutorialControllerProvider.notifier).setTutorialShown();
      },
      onSkip: () {
        // 튜토리얼 건너뛰기 시에도 상태 저장
        ref.read(tutorialControllerProvider.notifier).setTutorialShown();
        return true;
      },
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final tutorialState = ref.watch(tutorialControllerProvider);
    final expensesAsync = ref.watch(expenseListStreamProvider(_filter));

    // 이전 데이터 캐싱 (깜빡임 방지)
    final cachedExpenses = expensesAsync.when(
      data: (data) => data,
      loading: () => expensesAsync.value ?? [],
      error: (_, _) => expensesAsync.value ?? [],
    );

    // 데이터 로딩 완료 후 튜토리얼을 본적이 없다면 튜토리얼 표시
    if (!tutorialState.hasSeenTutorial && expensesAsync.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
        child: Builder(
          builder: (context) {
            final displayExpenses = _getDisplayExpenses(
              tutorialState,
              cachedExpenses,
            );
            final totalAmount = _getTotalAmount(
              tutorialState,
              cachedExpenses.fold<int>(
                0,
                (int sum, Expense e) => sum + e.amount,
              ),
            );
            final selectedFilter = _filter.emotion;

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
                          onTap: () => _updateFilter(
                            _filter.copyWith(clearEmotion: true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilterChipWidget(
                          label: '잘 쓴 돈',
                          isSelected: selectedFilter == ExpenseEmotions.good,
                          onTap: () => _updateFilter(
                            _filter.copyWith(emotion: ExpenseEmotions.good),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilterChipWidget(
                          label: '그저 그런 돈',
                          isSelected: selectedFilter == ExpenseEmotions.normal,
                          onTap: () => _updateFilter(
                            _filter.copyWith(emotion: ExpenseEmotions.normal),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilterChipWidget(
                          label: '아까운 돈',
                          isSelected: selectedFilter == ExpenseEmotions.regret,
                          onTap: () => _updateFilter(
                            _filter.copyWith(emotion: ExpenseEmotions.regret),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilterChipWidget(
                          label: '후회한 돈',
                          isSelected: selectedFilter == ExpenseEmotions.bad,
                          onTap: () => _updateFilter(
                            _filter.copyWith(emotion: ExpenseEmotions.bad),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 총 금액 (위젯으로 분리)
                ExpenseSummaryCard(
                  totalAmount: totalAmount,
                  selectedFilter: selectedFilter,
                  selectedDate: _filter.startDate,
                  onMonthChanged: (DateTime newDate) {
                    _updateFilter(
                      _filter.copyWith(
                        startDate: DateTime(newDate.year, newDate.month),
                        endDate: DateTime(newDate.year, newDate.month + 1, 0),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // 지출 목록
                Expanded(
                  key: _expenseListKey,
                  child: displayExpenses.isEmpty
                      ? const EmptyExpenseState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: displayExpenses.length,
                          itemBuilder: (context, index) {
                            final expense = displayExpenses[index];
                            final showDate =
                                index == 0 ||
                                !_isSameDay(
                                  expense.date,
                                  displayExpenses[index - 1].date,
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

        /// colorScheme이 없음에 따라 플로팅 액션 버튼 색상 지정
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.textPrimary,
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
