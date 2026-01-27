import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../providers/statistics_provider.dart';

/* A bar chart widget for displaying monthly expense trends using real data */

class MonthlyBarChart extends ConsumerStatefulWidget {
  const MonthlyBarChart({super.key});

  @override
  ConsumerState<MonthlyBarChart> createState() => _MonthlyBarChartState();
}

class _MonthlyBarChartState extends ConsumerState<MonthlyBarChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final barDataAsync = ref.watch(barChartDataProvider);

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
          barDataAsync.when(
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

  Widget _buildChart(BuildContext context, List<BarChartDataItem> data) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (data.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No data yet')),
      );
    }

    final maxY = _getMaxY(data);
    final labels = data.map((d) => d.label).toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightOnBackground,
              tooltipRoundedRadius: AppSizes.radiusSm,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  CurrencyFormatter.format(rod.toY),
                  const TextStyle(
                    color: Colors.white,
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
                  if (value.toInt() >= 0 && value.toInt() < labels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: AppSizes.sm),
                      child: Text(
                        labels[value.toInt()],
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
                    CurrencyFormatter.formatCompact(value),
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
            horizontalInterval: maxY > 0 ? maxY / 4 : 25,
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
          barGroups: _buildBarGroups(data, maxY),
        ),
      ),
    );
  }

  double _getMaxY(List<BarChartDataItem> data) {
    if (data.isEmpty) return 100;
    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    if (maxValue == 0) return 100;
    return (maxValue * 1.2).ceilToDouble();
  }

  List<BarChartGroupData> _buildBarGroups(
    List<BarChartDataItem> data,
    double maxY,
  ) {
    return List.generate(data.length, (index) {
      final isTouched = index == _touchedIndex;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index].value,
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
              toY: maxY,
              color: AppColors.primary.withValues(alpha: 0.05),
            ),
          ),
        ],
      );
    });
  }
}
