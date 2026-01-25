import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/core/mock/mock_data.dart';
import 'package:my_expenses/feature/home/widgets/expense_summary_card.dart';
import 'package:my_expenses/feature/home/widgets/recent_expenses_list.dart';
import 'package:my_expenses/feature/home/widgets/quick_add_fab.dart';
import 'package:my_expenses/router/route_names.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreeting(context, theme),
                    const SizedBox(height: AppSizes.lg),
                    _buildMainSummaryCard(),
                    const SizedBox(height: AppSizes.md),
                    _buildSmallSummaryCards(),
                    const SizedBox(height: AppSizes.lg),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: RecentExpensesList(
                onSeeAllPressed: () => context.go(RouteNames.expenses),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSizes.xxl),
            ),
          ],
        ),
      ),
      floatingActionButton: QuickAddFab(
        onPressed: () => context.push(RouteNames.addExpense),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, ThemeData theme) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;

    if (hour < 12) {
      greeting = 'Good morning';
      icon = Icons.wb_sunny_rounded;
    } else if (hour < 17) {
      greeting = 'Good afternoon';
      icon = Icons.wb_sunny_outlined;
    } else {
      greeting = 'Good evening';
      icon = Icons.nights_stay_rounded;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: AppSizes.borderRadiusSm,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: AppSizes.iconMd,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.lightOnSurfaceVariant,
              ),
            ),
            Text(
              AppStrings.homeGreeting,
              style: theme.textTheme.headlineSmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainSummaryCard() {
    return ExpenseSummaryCard(
      totalAmount: MockData.thisMonthSpending,
      periodLabel: AppStrings.homeThisMonth,
      previousAmount: 450.00,
    );
  }

  Widget _buildSmallSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: SmallSummaryCard(
            label: AppStrings.homeThisWeek,
            amount: MockData.thisWeekSpending,
            icon: Icons.calendar_today_rounded,
            iconColor: AppColors.info,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: SmallSummaryCard(
            label: AppStrings.homeTotalSpending,
            amount: MockData.totalSpending,
            icon: Icons.account_balance_wallet_rounded,
            iconColor: AppColors.success,
          ),
        ),
      ],
    );
  }
}
