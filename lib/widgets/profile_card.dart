import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/profile_model.dart';
import '../l10n/app_localizations.dart';

/// Reusable profile card matching AP Matrimony style
class ProfileCard extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback? onTap;
  final VoidCallback? onSendInterest;
  final VoidCallback? onDontShow;
  final bool showActions;

  const ProfileCard({
    super.key,
    required this.profile,
    this.onTap,
    this.onSendInterest,
    this.onDontShow,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo section
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: Container(
                    color: Colors.grey.shade200,
                    child: Image.asset(
                      profile.profileImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Center(
                        child: Icon(Icons.person, size: 60,
                            color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
                // Photo verified badge
                if (profile.isPhotoVerified)
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_user,
                              size: 14, color: Colors.greenAccent),
                          const SizedBox(width: 4),
                          Text(l10n.photoVerified,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                // Photo count
                if (profile.photos.isNotEmpty)
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '1/${profile.photos.length}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                // Shortlist button
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.bookmark_border,
                          color: Colors.white, size: 20),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),

            // Info section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges row
                  Row(
                    children: [
                      if (profile.isVerified) ...[
                        _Badge(
                          icon: Icons.verified,
                          label: l10n.idVerified,
                          color: AppColors.verified,
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (profile.isPremium)
                        _Badge(
                          icon: Icons.workspace_premium,
                          label: l10n.premiumMember,
                          color: AppColors.accent,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Name
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Member ID & last active
                  Text(
                    '${profile.membershipId} | Last active at ${_formatLastActive(profile.lastActive)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Details
                  Text(
                    '${profile.age} yrs, ${profile.height}, ${profile.caste}, ${profile.education}, ${profile.occupation}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    profile.city,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  if (showActions) ...[
                    const SizedBox(height: 12),
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Don't Show
                        GestureDetector(
                          onTap: onDontShow,
                          child: Column(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.error, width: 1.5),
                                  color:
                                      AppColors.error.withValues(alpha: 0.06),
                                ),
                                child: const Icon(Icons.close,
                                    color: AppColors.error, size: 20),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                l10n.dontShow,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Send Interest
                        GestureDetector(
                          onTap: onSendInterest,
                          child: Column(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.accent,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accent
                                          .withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.favorite,
                                    color: Colors.white, size: 22),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                l10n.sendInterest,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastActive(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Compact horizontal profile card for "Recently Joined" etc.
class ProfileCardCompact extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback? onTap;

  const ProfileCardCompact({
    super.key,
    required this.profile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  profile.profileImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.person, size: 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          profile.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (profile.isVerified)
                        const Icon(Icons.verified,
                            size: 14, color: AppColors.verified),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${profile.age} yrs, ${profile.city}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
