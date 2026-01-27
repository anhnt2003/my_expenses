import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../providers/statistics_provider.dart';

/* A pie chart widget for displaying expense breakdown by category using real data */

class ExpensePieChart extends ConsumerStatefulWidget {
  const ExpensePieChart({super.key});

  @override
  ConsumerState<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends ConsumerState<ExpensePieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final pieDataAsync = ref.watch(pieChartDataProvider);

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppSizes.borderRadiusLg,
        border: Border.all(
          color: isDark
              ? AppColors.darkOutline.withValues(alpha: 0.3)
              : AppColors.lightOutline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending by Category',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          pieDataAsync.when(
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: AppLoadingWidget()),
            ),
            error: (error, _) => SizedBox(
              height: 200,
              child: Center(child: Text('Error: $error')),
            ),
            data: (result) => result.fold(
              (failure) => SizedBox(
                height: 200,
                child: Center(child: Text('Error: ${failure.message}')),
              ),
              (data) => _buildChart(context, data),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<PieChartDataItem> data) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No expenses yet')),
      );
    }

    final total = data.fold(0.0, (sum, item) => sum + item.value);

    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          response.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _buildSections(data, total),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            flex: 2,
            child: _buildLegend(context, data, total),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
    List<PieChartDataItem> data,
    double total,
  ) {
    return List.generate(data.length, (index) {
      final item = data[index];
      final isTouched = index == _touchedIndex;
      final percentage = (item.value / total) * 100;

      return PieChartSectionData(
        color: item.color,
        value: item.value,
        title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: isTouched ? 60 : 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.55,
      );
    });
  }

  Widget _buildLegend(
    BuildContext context,
    List<PieChartDataItem> data,
    double total,
  ) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final percentage = (item.value / total) * 100;
          final isSelected = index == _touchedIndex;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: item.color.withValues(alpha: 0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : null,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
