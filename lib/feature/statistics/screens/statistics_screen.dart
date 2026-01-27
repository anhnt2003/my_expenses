import 'package:flutter/material.dart';
import '../../../shared/widgets/loading_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/statistics_provider.dart';
import '../widgets/expense_pie_chart.dart';
import '../widgets/monthly_bar_chart.dart';
import '../widgets/stats_summary_card.dart';

/* Statistics screen with real data from providers */

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.statsTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildPeriodSelector(context, ref),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummarySection(ref),
                    const SizedBox(height: AppSizes.lg),
                    const ExpensePieChart(),
                    const SizedBox(height: AppSizes.lg),
                    const MonthlyBarChart(),
                    const SizedBox(height: AppSizes.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedPeriod = ref.watch(statsPeriodProvider);

    final periods = [
      (StatsPeriod.week, AppStrings.statsPeriodWeek),
      (StatsPeriod.month, AppStrings.statsPeriodMonth),
      (StatsPeriod.year, AppStrings.statsPeriodYear),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        child: Row(
          children: periods.map((period) {
            final isSelected = selectedPeriod == period.$1;
            return Padding(
              padding: const EdgeInsets.only(right: AppSizes.sm),
              child: FilterChip(
                label: Text(period.$2),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(statsPeriodProvider.notifier).state = period.$1;
                },
                showCheckmark: false,
                backgroundColor: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSummarySection(WidgetRef ref) {
    final summaryAsync = ref.watch(summaryStatsProvider);

    return summaryAsync.when(
      loading: () => const SizedBox(
        height: 100,
        child: Center(child: AppLoadingWidget()),
      ),
      error: (error, _) => Text('Error: $error'),
      data: (result) => result.fold(
        (failure) => Text('Error: ${failure.message}'),
        (stats) => StatsSummaryRow(
          total: stats.total,
          average: stats.average,
          highest: stats.highest,
        ),
      ),
    );
  }
}
