import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/mock/mock_data.dart';

/// A pie chart widget for displaying expense breakdown by category.
///
/// Features:
/// - Animated pie chart using fl_chart
/// - Category legend with colors
/// - Interactive touch for details
class ExpensePieChart extends StatefulWidget {
  const ExpensePieChart({
    super.key,
    this.categorySpending,
  });

  final Map<String, double>? categorySpending;

  @override
  State<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int _touchedIndex = -1;

  Map<String, double> get _data =>
      widget.categorySpending ?? MockData.categorySpending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
          SizedBox(
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
                      sections: _buildSections(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  flex: 2,
                  child: _buildLegend(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final entries = _data.entries.toList();
    final total = _data.values.fold(0.0, (sum, v) => sum + v);

    return List.generate(entries.length, (index) {
      final entry = entries[index];
      final isTouched = index == _touchedIndex;
      final percentage = (entry.value / total) * 100;
      final color = _getCategoryColor(entry.key);

      return PieChartSectionData(
        color: color,
        value: entry.value,
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

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);
    final entries = _data.entries.toList();
    final total = _data.values.fold(0.0, (sum, v) => sum + v);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: entries.map((entry) {
          final percentage = (entry.value / total) * 100;
          final color = _getCategoryColor(entry.key);
          final isSelected = entries.indexOf(entry) == _touchedIndex;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
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
                    entry.key,
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

  Color _getCategoryColor(String categoryName) {
    final category = MockData.categories.firstWhere(
      (c) => c.name == categoryName,
      orElse: () => MockData.categories.last,
    );
    return category.color;
  }
}
