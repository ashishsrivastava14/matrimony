import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../widgets/powered_by_footer.dart';

/// Role-selection screen with couple-photo background, strong gradient overlay,
/// and a clean, focused layout for end users.
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _navigateToLogin(UserRole role) {
    if (role == UserRole.guest) {
      Navigator.of(context).pushReplacementNamed('/login', arguments: role);
    } else {
      Navigator.of(context).pushNamed('/login', arguments: role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const PoweredByFooter(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background couple photo ─────────────────────────────────
          Image.asset(
            'assets/images/couples_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // ── Strong gradient overlay for readability ─────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF004D40).withValues(alpha: 0.72),
                  const Color(0xFF00695C).withValues(alpha: 0.82),
                  const Color(0xFF004D40).withValues(alpha: 0.92),
                  const Color(0xFF002E25).withValues(alpha: 0.96),
                ],
                stops: const [0.0, 0.3, 0.65, 1.0],
              ),
            ),
          ),

          // ── Foreground content ──────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slideUp,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      // ── Logo circle ─────────────────────────────────
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.20),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // ── App name ────────────────────────────────────
                      Text(
                        AppConstants.appName,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppConstants.tagline,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.85),
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Decorative accent line ──────────────────────
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _accentLine(),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.auto_awesome,
                            size: 16,
                            color: AppColors.premiumGold.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 8),
                          _accentLine(),
                        ],
                      ),

                      const Spacer(flex: 2),

                      // ── Primary CTA: Get Started ────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => _navigateToLogin(UserRole.user),
                          icon: const Icon(Icons.arrow_forward_rounded,
                              size: 20),
                          label: Text(
                            'Get Started',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryDark,
                            elevation: 4,
                            shadowColor: Colors.black38,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Browse as Guest ─────────────────────────────
                      TextButton.icon(
                        onPressed: () => _navigateToLogin(UserRole.guest),
                        icon: Icon(
                          Icons.visibility_outlined,
                          size: 18,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        label: Text(
                          'Browse as Guest',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.85),
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white54,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // ── Divider ─────────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'Other roles',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.55),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Admin & Mediator row ────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _SecondaryRoleButton(
                              icon: Icons.handshake_outlined,
                              label: 'Mediator',
                              subtitle: 'Manage & earn',
                              onTap: () =>
                                  _navigateToLogin(UserRole.mediator),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _SecondaryRoleButton(
                              icon: Icons.admin_panel_settings_outlined,
                              label: 'Admin',
                              subtitle: 'Platform access',
                              onTap: () =>
                                  _navigateToLogin(UserRole.admin),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Footer ──────────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: AppColors.premiumGold.withValues(alpha: 0.6),
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            AppConstants.yearsText,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.55),
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accentLine() {
    return Container(
      width: 36,
      height: 1.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.5),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Secondary role button — used for Mediator & Admin
// ─────────────────────────────────────────────────────────────────────────────
class _SecondaryRoleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SecondaryRoleButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withValues(alpha: 0.10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white70, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
