import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../core/constants.dart';

/// Clean, simple role-selection screen.
/// Primary CTA for end users; secondary access for Mediator & Admin.
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
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00796B), // deep teal
              Color(0xFF00897B), // primary teal
              Color(0xFF009688), // lighter teal
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slideUp,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // ── Logo ──────────────────────────────────────────
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.15),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── App name ──────────────────────────────────────
                    Text(
                      AppConstants.appName,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.tagline,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // ── Primary CTA: Get Started (User) ──────────────
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => _navigateToLogin(UserRole.user),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryDark,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Browse as Guest ───────────────────────────────
                    TextButton(
                      onPressed: () => _navigateToLogin(UserRole.guest),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'Browse as Guest',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white54,
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // ── Divider ───────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 0.5,
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
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
                    const SizedBox(height: 18),

                    // ── Admin & Mediator row ─────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _SecondaryRoleButton(
                            icon: Icons.handshake_outlined,
                            label: 'Mediator',
                            onTap: () =>
                                _navigateToLogin(UserRole.mediator),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _SecondaryRoleButton(
                            icon: Icons.admin_panel_settings_outlined,
                            label: 'Admin',
                            onTap: () => _navigateToLogin(UserRole.admin),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── Footer ────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: Colors.white.withValues(alpha: 0.45),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppConstants.yearsText,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.5),
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
  final VoidCallback onTap;

  const _SecondaryRoleButton({
    required this.icon,
    required this.label,
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
              color: Colors.white.withValues(alpha: 0.20),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white70, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
