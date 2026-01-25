import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';

/// A tappable field that opens a date picker.
///
/// Displays the formatted selected date and integrates with
/// the Material date picker.
class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.label,
    this.hint,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? label;
  final String? hint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: AppSizes.xs),
        ],
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? () => _showDatePicker(context) : null,
            borderRadius: AppSizes.borderRadiusMd,
            child: Container(
              height: AppSizes.textFieldHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
                    : AppColors.lightSurfaceVariant.withValues(alpha: 0.5),
                borderRadius: AppSizes.borderRadiusMd,
                border: Border.all(
                  color: isDark
                      ? AppColors.darkOutline.withValues(alpha: 0.5)
                      : AppColors.lightOutline.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: AppSizes.iconSm,
                    color: enabled
                        ? theme.colorScheme.primary
                        : theme.disabledColor,
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? _formatDate(selectedDate!)
                          : (hint ?? 'Select date'),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: selectedDate != null
                            ? (enabled
                                ? theme.colorScheme.onSurface
                                : theme.disabledColor)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: enabled
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.disabledColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final theme = Theme.of(context);
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today, ${DateFormat('MMM d, y').format(date)}';
    } else if (dateOnly == yesterday) {
      return 'Yesterday, ${DateFormat('MMM d, y').format(date)}';
    } else {
      return DateFormat('EEEE, MMM d, y').format(date);
    }
  }
}
