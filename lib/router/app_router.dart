import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_expenses/feature/categories/screens/categories_screen.dart';
import 'package:my_expenses/feature/expenses/screens/add_expense_screen.dart';
import 'package:my_expenses/feature/expenses/screens/expenses_list_screen.dart';
import 'package:my_expenses/feature/home/screens/home_screen.dart';
import 'package:my_expenses/feature/settings/screens/settings_screen.dart';
import 'package:my_expenses/feature/statistics/screens/statistics_screen.dart';
import 'package:my_expenses/router/route_names.dart';
import 'package:my_expenses/shared/widgets/main_shell.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.home,
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.expenses,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ExpensesListScreen(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const AddExpenseScreen(),
              ),
              GoRoute(
                path: 'edit',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const EditExpenseScreen(),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.statistics,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StatisticsScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.categories,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CategoriesScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
}
