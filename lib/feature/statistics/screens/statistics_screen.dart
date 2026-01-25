import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/core/mock/mock_data.dart';
import 'package:my_expenses/feature/statistics/widgets/expense_pie_chart.dart';
import 'package:my_expenses/feature/statistics/widgets/monthly_bar_chart.dart';
import 'package:my_expenses/feature/statistics/widgets/stats_summary_card.dart';

/// The main statistics screen.
///
/// Features:
/// - Period selector (Week, Month, Year)
/// - Summary stats cards (Total, Average, Highest)
/// - Category pie chart
/// - Monthly trend bar chart
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedPeriod = 'month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.statsTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildPeriodSelector(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummarySection(),
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

  Widget _buildPeriodSelector(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final periods = [
      ('week', AppStrings.statsPeriodWeek),
      ('month', AppStrings.statsPeriodMonth),
      ('year', AppStrings.statsPeriodYear),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        child: Row(
          children: periods.map((period) {
            final isSelected = _selectedPeriod == period.$1;
            return Padding(
              padding: const EdgeInsets.only(right: AppSizes.sm),
              child: FilterChip(
                label: Text(period.$2),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => _selectedPeriod = period.$1);
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

  Widget _buildSummarySection() {
    // Calculate stats from mock data
    final expenses = MockData.expenses;
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final average = expenses.isNotEmpty ? total / expenses.length : 0.0;
    final highest = expenses.isNotEmpty
        ? expenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b)
        : 0.0;

    return StatsSummaryRow(
      total: total,
      average: average,
      highest: highest,
    );
  }
}
