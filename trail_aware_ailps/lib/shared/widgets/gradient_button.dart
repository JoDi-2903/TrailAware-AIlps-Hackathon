import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/glass_morphism.dart';

/// Primary action button with Alpine Modernism styling.
/// Supports solid fill (default) or transparent outlined variant.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.outlined = false,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool outlined;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: fullWidth ? double.infinity : null,
          // Reduced horizontal padding so "DISPATCH TEAM" + icon fits in ~117px
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: outlined
                ? AppColors.transparent
                : (isEnabled ? AppColors.primary : AppColors.surfaceContainerHigh),
            border: outlined
                ? Border.all(color: AppColors.primary, width: 1)
                : null,
            borderRadius: BorderRadius.circular(8),
            boxShadow: (outlined || !isEnabled) ? null : GlassMorphism.fabShadow,
          ),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  size: 18,
                  color: outlined ? AppColors.primary : AppColors.onPrimary,
                ),
                const SizedBox(width: 6),
              ],
              // Flexible prevents overflow when button is in a constrained Expanded
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextStyles.labelCaps.copyWith(
                    color: outlined
                        ? AppColors.primary
                        : (isEnabled ? AppColors.onPrimary : AppColors.outline),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
