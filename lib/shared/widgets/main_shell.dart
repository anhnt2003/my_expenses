import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/router/route_names.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _calculateSelectedIndex(location);

    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.lightShadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: NavigationBar(
        height: AppSizes.bottomNavHeight,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: AppStrings.navHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: AppStrings.navExpenses,
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: AppStrings.navStatistics,
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category_rounded),
            label: AppStrings.navCategories,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: AppStrings.navSettings,
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith(RouteNames.expenses)) return 1;
    if (location.startsWith(RouteNames.statistics)) return 2;
    if (location.startsWith(RouteNames.categories)) return 3;
    if (location.startsWith(RouteNames.settings)) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;
      case 1:
        context.go(RouteNames.expenses);
        break;
      case 2:
        context.go(RouteNames.statistics);
        break;
      case 3:
        context.go(RouteNames.categories);
        break;
      case 4:
        context.go(RouteNames.settings);
        break;
    }
  }
}
