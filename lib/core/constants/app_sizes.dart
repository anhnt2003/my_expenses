import 'package:flutter/material.dart';

class AppSizes {
  AppSizes._();

  /* Spacing Constants */
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  /* Border Radius */
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 100.0;

  /* Border Radius - BorderRadius objects */
  static const BorderRadius borderRadiusXs =
      BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(Radius.circular(radiusXl));

  /* Icon Sizes */
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  /* Standard Widget Dimensions */
  static const double buttonHeight = 48.0;
  static const double buttonHeightSm = 36.0;
  static const double textFieldHeight = 56.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 80.0;
  static const double fabSize = 56.0;
  static const double fabSizeSm = 40.0;

  /* Card Dimensions */
  static const double cardMinHeight = 80.0;
  static const double cardElevation = 2.0;
  static const double cardElevationHover = 8.0;

  /* Avatar Sizes */
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;

  /* Category Icon Container */
  static const double categoryIconSize = 40.0;
  static const double categoryIconSizeLg = 56.0;

  /* Animation Durations (milliseconds) */
  static const int animFast = 150;
  static const int animNormal = 300;
  static const int animSlow = 500;

  /* Screen Breakpoints */
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;

  /* Content Max Width */
  static const double maxContentWidth = 600.0;
}
