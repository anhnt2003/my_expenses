import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /* Primary Colors */
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color onPrimary = Colors.white;

  /* Secondary Colors */
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryLight = Color(0xFFA78BFA);
  static const Color secondaryDark = Color(0xFF7C3AED);
  static const Color onSecondary = Colors.white;

  /* Semantic Colors */
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color onSuccess = Colors.white;

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color onError = Colors.white;

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color onWarning = Colors.black;

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color onInfo = Colors.white;

  /* Light Theme Colors */
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightOnBackground = Color(0xFF1E293B);
  static const Color lightOnSurface = Color(0xFF334155);
  static const Color lightOnSurfaceVariant = Color(0xFF64748B);
  static const Color lightOutline = Color(0xFFCBD5E1);
  static const Color lightDivider = Color(0xFFE2E8F0);

  /* Dark Theme Colors */
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkOnBackground = Color(0xFFF1F5F9);
  static const Color darkOnSurface = Color(0xFFE2E8F0);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);
  static const Color darkOutline = Color(0xFF475569);
  static const Color darkDivider = Color(0xFF334155);

  /* Category Colors */
  static const Color categoryFood = Color(0xFFF97316);
  static const Color categoryTransport = Color(0xFF3B82F6);
  static const Color categoryShopping = Color(0xFFEC4899);
  static const Color categoryEntertainment = Color(0xFF8B5CF6);
  static const Color categoryBills = Color(0xFF6B7280);
  static const Color categoryHealth = Color(0xFF10B981);
  static const Color categoryEducation = Color(0xFF6366F1);
  static const Color categoryOther = Color(0xFF14B8A6);

  /* Gradients */
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [error, Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF334155)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /* Shadow Colors */
  static const Color lightShadow = Color(0x1A000000);
  static const Color darkShadow = Color(0x40000000);
}
