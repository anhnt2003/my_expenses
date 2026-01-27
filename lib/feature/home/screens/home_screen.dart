import 'package:flutter/material.dart';
import '../../../shared/widgets/loading_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../router/route_names.dart';
import '../../../shared/widgets/error_widget.dart' as app;
import '../providers/home_provider.dart';
import '../widgets/expense_summary_card.dart';
import '../widgets/recent_expenses_list.dart';
import '../widgets/quick_add_fab.dart';

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
                    _buildMainSummaryCard(ref),
                    const SizedBox(height: AppSizes.md),
                    _buildSmallSummaryCards(ref),
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

  Widget _buildMainSummaryCard(WidgetRef ref) {
    final monthlyTotal = ref.watch(monthlyTotalProvider);

    return monthlyTotal.when(
      loading: () => const SizedBox(
        height: 120,
        child: Center(child: AppLoadingWidget()),
      ),
      error: (error, _) => app.ErrorWidget(
        message: 'Failed to load monthly total',
        onRetry: () => ref.invalidate(monthlyTotalProvider),
      ),
      data: (result) => result.fold(
        (failure) => app.ErrorWidget(
          message: failure.message,
          onRetry: () => ref.invalidate(monthlyTotalProvider),
        ),
        (amount) => ExpenseSummaryCard(
          totalAmount: amount,
          periodLabel: AppStrings.homeThisMonth,
        ),
      ),
    );
  }

  Widget _buildSmallSummaryCards(WidgetRef ref) {
    final weeklyTotal = ref.watch(weeklyTotalProvider);
    final todayTotal = ref.watch(todayTotalProvider);

    return Row(
      children: [
        Expanded(
          child: weeklyTotal.when(
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: AppLoadingWidget()),
            ),
            error: (_, __) => const SmallSummaryCard(
              label: AppStrings.homeThisWeek,
              amount: 0,
              icon: Icons.calendar_today_rounded,
              iconColor: AppColors.info,
            ),
            data: (result) => result.fold(
              (_) => const SmallSummaryCard(
                label: AppStrings.homeThisWeek,
                amount: 0,
                icon: Icons.calendar_today_rounded,
                iconColor: AppColors.info,
              ),
              (amount) => SmallSummaryCard(
                label: AppStrings.homeThisWeek,
                amount: amount,
                icon: Icons.calendar_today_rounded,
                iconColor: AppColors.info,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: todayTotal.when(
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: AppLoadingWidget()),
            ),
            error: (_, __) => const SmallSummaryCard(
              label: 'Today',
              amount: 0,
              icon: Icons.today_rounded,
              iconColor: AppColors.success,
            ),
            data: (result) => result.fold(
              (_) => const SmallSummaryCard(
                label: 'Today',
                amount: 0,
                icon: Icons.today_rounded,
                iconColor: AppColors.success,
              ),
              (amount) => SmallSummaryCard(
                label: 'Today',
                amount: amount,
                icon: Icons.today_rounded,
                iconColor: AppColors.success,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
