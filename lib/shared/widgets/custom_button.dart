import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';

enum CustomButtonVariant { primary, secondary, outlined, text }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.variant = CustomButtonVariant.primary,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
    this.height,
  });

  final VoidCallback? onPressed;
  final String label;
  final CustomButtonVariant variant;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isEnabled && !isLoading ? onPressed : null;

    return SizedBox(
      width: width,
      height: height ?? AppSizes.buttonHeight,
      child: _buildButton(context, effectiveOnPressed),
    );
  }

  Widget _buildButton(BuildContext context, VoidCallback? onPressed) {
    final child = _buildChild();

    switch (variant) {
      case CustomButtonVariant.primary:
        return ElevatedButton(
          onPressed: onPressed,
          child: child,
        );
      case CustomButtonVariant.secondary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.onSecondary,
          ),
          child: child,
        );
      case CustomButtonVariant.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          child: child,
        );
      case CustomButtonVariant.text:
        return TextButton(
          onPressed: onPressed,
          child: child,
        );
    }
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: AppSizes.iconSm,
        height: AppSizes.iconSm,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSizes.iconSm),
          const SizedBox(width: AppSizes.sm),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
