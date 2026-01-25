import 'package:flutter/material.dart';
import 'package:my_expenses/core/constants/app_colors.dart';
import 'package:my_expenses/core/constants/app_sizes.dart';

/// A reusable settings tile widget.
///
/// Features:
/// - Icon, title, and subtitle layout
/// - Trailing widget support (switch, chevron, value text)
/// - Tap handling with ripple effect
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  /// Creates a settings tile with a switch
  factory SettingsTile.withSwitch({
    Key? key,
    required String title,
    String? subtitle,
    Widget? leading,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return SettingsTile(
      key: key,
      title: title,
      subtitle: subtitle,
      leading: leading,
      enabled: enabled,
      trailing: Switch.adaptive(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeThumbColor: AppColors.primary,
        activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
      ),
      onTap: enabled ? () => onChanged(!value) : null,
    );
  }

  /// Creates a settings tile with a chevron icon
  factory SettingsTile.navigation({
    Key? key,
    required String title,
    String? subtitle,
    Widget? leading,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return SettingsTile(
      key: key,
      title: title,
      subtitle: subtitle,
      leading: leading,
      enabled: enabled,
      trailing: Icon(
        Icons.chevron_right_rounded,
        color:
            enabled ? AppColors.lightOnSurfaceVariant : AppColors.lightOutline,
      ),
      onTap: onTap,
    );
  }

  /// Creates a settings tile with a value display
  factory SettingsTile.withValue({
    Key? key,
    required String title,
    String? subtitle,
    Widget? leading,
    required String value,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return SettingsTile(
      key: key,
      title: title,
      subtitle: subtitle,
      leading: leading,
      enabled: enabled,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: enabled ? AppColors.primary : AppColors.lightOutline,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppSizes.xs),
          Icon(
            Icons.chevron_right_rounded,
            color: enabled
                ? AppColors.lightOnSurfaceVariant
                : AppColors.lightOutline,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: AppSizes.borderRadiusMd,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: AppSizes.borderRadiusMd,
              border: Border.all(
                color: isDark
                    ? AppColors.darkOutline.withValues(alpha: 0.3)
                    : AppColors.lightOutline.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  _buildLeadingIcon(context),
                  const SizedBox(width: AppSizes.md),
                ],
                Expanded(child: _buildContent(context)),
                if (trailing != null) ...[
                  const SizedBox(width: AppSizes.sm),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: AppSizes.categoryIconSize,
      height: AppSizes.categoryIconSize,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: AppSizes.borderRadiusSm,
      ),
      child: leading is Icon
          ? IconTheme(
              data: const IconThemeData(
                color: AppColors.primary,
                size: AppSizes.iconMd,
              ),
              child: leading!,
            )
          : leading,
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSizes.xs),
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// A section header for grouping settings tiles
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.sm,
            bottom: AppSizes.sm,
          ),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...children.map((child) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: child,
            )),
      ],
    );
  }
}
