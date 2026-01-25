import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';
import 'package:my_expenses/core/constants/app_strings.dart';
import 'package:my_expenses/shared/widgets/custom_button.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.message,
    this.icon,
    this.onRetry,
    this.retryLabel,
  });

  final String? message;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline_rounded,
                size: AppSizes.iconXl,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              message ?? AppStrings.commonError,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSizes.lg),
              CustomButton(
                onPressed: onRetry,
                label: retryLabel ?? AppStrings.commonRetry,
                variant: CustomButtonVariant.outlined,
                icon: Icons.refresh_rounded,
                width: 160,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
