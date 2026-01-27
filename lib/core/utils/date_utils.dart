import 'package:intl/intl.dart';

/* Date utility extensions and helpers */

extension AppDateUtils on DateTime {
  /* Format as readable date: Jan 28, 2026 */
  String toFormattedDate() {
    return DateFormat.yMMMd().format(this);
  }

  /* Format as short date: 01/28/26 */
  String toShortDate() {
    return DateFormat.yMd().format(this);
  }

  /* Format as month and year: January 2026 */
  String toMonthYear() {
    return DateFormat.yMMMM().format(this);
  }

  /* Format as day name: Monday */
  String toDayName() {
    return DateFormat.EEEE().format(this);
  }

  /* Format as relative time: Today, Yesterday, or formatted date */
  String toRelativeDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);

    if (date == today) {
      return 'Today';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (date.isAfter(today.subtract(const Duration(days: 7)))) {
      return toDayName();
    } else {
      return toFormattedDate();
    }
  }

  /* Check if date is in current month */
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /* Check if date is in current week */
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /* Get start of day */
  DateTime get startOfDay => DateTime(year, month, day);

  /* Get end of day */
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /* Get start of month */
  DateTime get startOfMonth => DateTime(year, month, 1);

  /* Get end of month */
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59);
}
