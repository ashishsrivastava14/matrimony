import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';

/// Verified / Premium badge widget
class VerifiedBadge extends StatelessWidget {
  final bool isVerified;
  final bool isPremium;
  final double size;

  const VerifiedBadge({
    super.key,
    this.isVerified = false,
    this.isPremium = false,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isVerified)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.verified.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: size, color: AppColors.verified),
                const SizedBox(width: 3),
                Text(
                  l10n.idVerified,
                  style: TextStyle(
                    fontSize: size - 4,
                    color: AppColors.verified,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        if (isVerified && isPremium) const SizedBox(width: 6),
        if (isPremium)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium,
                    size: size, color: AppColors.accent),
                const SizedBox(width: 3),
                Text(
                  l10n.premium,
                  style: TextStyle(
                    fontSize: size - 4,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
