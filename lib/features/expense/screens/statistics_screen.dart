import 'package:expense_tracker/core/themes/app_colors.dart';
import 'package:expense_tracker/core/utils/layout_utils.dart';
import 'package:expense_tracker/features/expense/models/expense_filter.dart';
import 'package:expense_tracker/features/expense/models/expense_statistics.dart';
import 'package:expense_tracker/features/expense/providers/expense_analytics_provider.dart';
import 'package:expense_tracker/features/expense/screens/emotion_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// 통계 화면
class StatisticsScreen extends ConsumerWidget {
  /// 통계 화면 생성자
  const StatisticsScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  /// 시작 날짜
  final DateTime startDate;

  /// 종료 날짜
  final DateTime endDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ExpenseFilter(
      startDate: startDate,
      endDate: endDate,
    );
    final analyticsAsync = ref.watch(expenseAnalyticsStreamProvider(filter));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '감정 통계',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: systemBarsPadding(context),
        child: analyticsAsync.when(
          data: (analytics) => Column(
            children: [
              _buildDateRangeHeader(context, filter.startDate, filter.endDate),
              Expanded(
                child: analytics.totalCount == 0
                    ? _buildEmptyState(context)
                    : _buildStatisticsContent(analytics, context),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _buildEmptyState(context),
        ),
      ),
    );
  }

  Widget _buildDateRangeHeader(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
  ) {
    final dateFormat = DateFormat('yyyy.MM.dd');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: context.colors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            '${dateFormat.format(startDate)} ~ ${dateFormat.format(endDate)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insert_chart_outlined,
            size: 80,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            '아직 지출 데이터가 없습니다',
            style: TextStyle(fontSize: 16, color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsContent(
    ExpenseAnalytics statistics,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(
            context,
            statistics.totalAmount,
            statistics.totalCount,
          ),
          const SizedBox(height: 24),
          Text(
            '감정별 분석',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...statistics.emotionStats.map((emotionStat) {
            return _buildStatCard(
              emotionStat: emotionStat,
              totalCount: statistics.totalCount,
              context: context,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    int totalAmount,
    int totalCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '전체 지출',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${NumberFormat('#,###').format(totalAmount)}원',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '총 $totalCount건',
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required EmotionStatistics emotionStat,
    required int totalCount,
    required BuildContext context,
  }) {
    final percentage = emotionStat.getPercentage(totalCount);
    final emotion = emotionStat.emotion;
    final count = emotionStat.count;
    final amount = emotionStat.amount;

    return GestureDetector(
      onTap: count > 0
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmotionDetailScreen(
                    emotion: emotion,
                    startDate: startDate,
                    endDate: endDate,
                  ),
                ),
              );
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: context.colors.textPrimary.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  emotion.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emotion.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: emotion.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$count건 · ${NumberFormat('#,###').format(amount)}원',
                        style: TextStyle(
                          fontSize: 13,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: emotion.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: context.colors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(emotion.color),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
