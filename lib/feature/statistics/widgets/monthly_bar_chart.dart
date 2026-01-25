import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/mock/mock_data.dart';

/// A bar chart widget for displaying monthly expense trends.
///
/// Features:
/// - Animated bar chart using fl_chart
/// - X-axis with month labels
/// - Interactive touch for values
/// - Gradient bar colors
class MonthlyBarChart extends StatefulWidget {
  const MonthlyBarChart({
    super.key,
    this.monthlyData,
    this.monthLabels,
  });

  final List<double>? monthlyData;
  final List<String>? monthLabels;

  @override
  State<MonthlyBarChart> createState() => _MonthlyBarChartState();
}

class _MonthlyBarChartState extends State<MonthlyBarChart> {
  int _touchedIndex = -1;

  List<double> get _data => widget.monthlyData ?? MockData.monthlySpending;
  List<String> get _labels => widget.monthLabels ?? MockData.monthLabels;

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
            'Monthly Spending',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.lightOnBackground,
                    tooltipRoundedRadius: AppSizes.radiusSm,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '\$${rod.toY.toStringAsFixed(0)}',
                        TextStyle(
                          color: isDark ? Colors.white : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.spot == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex = response.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < _labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSizes.sm),
                            child: Text(
                              _labels[value.toInt()],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: value.toInt() == _touchedIndex
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                                fontWeight: value.toInt() == _touchedIndex
                                    ? FontWeight.w600
                                    : null,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          '\$${value.toInt()}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _getMaxY() / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark
                          ? AppColors.darkOutline.withValues(alpha: 0.2)
                          : AppColors.lightOutline.withValues(alpha: 0.3),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: _buildBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxY() {
    final maxValue = _data.reduce((a, b) => a > b ? a : b);
    return (maxValue * 1.2).ceilToDouble();
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(_data.length, (index) {
      final isTouched = index == _touchedIndex;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: _data[index],
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSizes.radiusSm),
              topRight: Radius.circular(AppSizes.radiusSm),
            ),
            gradient: LinearGradient(
              colors: isTouched
                  ? [AppColors.primary, AppColors.secondary]
                  : [
                      AppColors.primary.withValues(alpha: 0.7),
                      AppColors.secondary.withValues(alpha: 0.7),
                    ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxY(),
              color: AppColors.primary.withValues(alpha: 0.05),
            ),
          ),
        ],
      );
    });
  }
}
