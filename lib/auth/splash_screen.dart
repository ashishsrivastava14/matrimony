import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimony_app/core/theme.dart';
import '../widgets/powered_by_footer.dart';

/// Splash screen with rich gradient, floating hearts, and staggered text.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ─── animation controllers ───────────────────────────────────────────
  late final AnimationController _bgCtrl;
  late final AnimationController _contentCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _floatCtrl;

  // ─── animations ──────────────────────────────────────────────────────
  late final Animation<double> _bgFade;
  late final Animation<double> _ringScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _headlineFade;
  late final Animation<Offset> _headlineSlide;
  late final Animation<double> _accentFade;
  late final Animation<double> _ctaFade;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    // Background gradient + ring ─────────────────────────────────────────
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _bgFade = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeOut);
    _ringScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bgCtrl,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Content stagger ────────────────────────────────────────────────────
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _logoFade = CurvedAnimation(
      parent: _contentCtrl,
      curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
    );
    _taglineFade = CurvedAnimation(
      parent: _contentCtrl,
      curve: const Interval(0.15, 0.40, curve: Curves.easeIn),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(_taglineFade);
    _headlineFade = CurvedAnimation(
      parent: _contentCtrl,
      curve: const Interval(0.30, 0.60, curve: Curves.easeIn),
    );
    _headlineSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(_headlineFade);
    _accentFade = CurvedAnimation(
      parent: _contentCtrl,
      curve: const Interval(0.50, 0.75, curve: Curves.easeIn),
    );
    _ctaFade = CurvedAnimation(
      parent: _contentCtrl,
      curve: const Interval(0.70, 1.0, curve: Curves.easeIn),
    );

    // Pulse for the ring ─────────────────────────────────────────────────
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Floating hearts ────────────────────────────────────────────────────
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Start sequence
    _bgCtrl.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _contentCtrl.forward();
    });

    // Navigate away
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/role-selection');
      }
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _contentCtrl.dispose();
    _pulseCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  // ─── build ───────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      bottomSheet: const PoweredByFooter(),
      body: Stack(
        children: [
          // ── gradient background ──────────────────────────────────────
          FadeTransition(
            opacity: _bgFade,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF00695C), // dark teal
                    Color(0xFF00897B), // primary teal
                    Color(0xFF26A69A), // lighter teal
                    Color(0xFFFF8F00), // golden amber
                  ],
                  stops: [0.0, 0.35, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // ── decorative circles ───────────────────────────────────────
          Positioned(
            top: -size.width * 0.25,
            right: -size.width * 0.20,
            child: FadeTransition(
              opacity: _bgFade,
              child: Container(
                width: size.width * 0.7,
                height: size.width * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -size.width * 0.30,
            left: -size.width * 0.25,
            child: FadeTransition(
              opacity: _bgFade,
              child: Container(
                width: size.width * 0.8,
                height: size.width * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),

          // ── floating hearts ──────────────────────────────────────────
          ..._buildFloatingHearts(size),

          // ── main content ─────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // pulsing ring + icon
                    ScaleTransition(
                      scale: _ringScale,
                      child: AnimatedBuilder(
                        animation: _pulse,
                        builder: (_, child) => Transform.scale(
                          scale: _pulse.value,
                          child: child,
                        ),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Colors.white24,
                                Colors.white10,
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            size: 54,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // App name
                    FadeTransition(
                      opacity: _logoFade,
                      child: Text(
                        'AP Matrimony',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tagline slide-up
                    SlideTransition(
                      position: _taglineSlide,
                      child: FadeTransition(
                        opacity: _taglineFade,
                        child: Text(
                          'Biggest Matrimony Service for AP',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.85),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Divider accent
                    FadeTransition(
                      opacity: _accentFade,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDividerLine(),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.auto_awesome,
                            size: 18,
                            color: AppColors.premiumGold,
                          ),
                          const SizedBox(width: 10),
                          _buildDividerLine(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Main headline
                    SlideTransition(
                      position: _headlineSlide,
                      child: FadeTransition(
                        opacity: _headlineFade,
                        child: Column(
                          children: [
                            Text(
                              '"Find Someone Who',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: Colors.white.withValues(alpha: 0.95),
                                height: 1.3,
                              ),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFFFFD700),
                                  Color(0xFFFFAB40),
                                  Color(0xFFFFD700),
                                ],
                              ).createShader(bounds),
                              child: Text(
                                'TRULY',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 6,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            Text(
                              'Gets You"',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dancingScript(
                                fontSize: 38,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Bottom CTA shimmer text
                    FadeTransition(
                      opacity: _ctaFade,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: AppColors.premiumGold,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '1 Crore+ Happy Customers',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Loading dots
                    FadeTransition(
                      opacity: _ctaFade,
                      child: _AnimatedLoadingDots(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── helpers ─────────────────────────────────────────────────────────

  Widget _buildDividerLine() {
    return Container(
      width: 40,
      height: 1.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.6),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingHearts(Size size) {
    final rng = math.Random(42);
    return List.generate(8, (i) {
      final startX = rng.nextDouble() * size.width;
      final delay = rng.nextDouble();
      final heartSize = 12.0 + rng.nextDouble() * 14;
      return AnimatedBuilder(
        animation: _floatCtrl,
        builder: (_, __) {
          final t = ((_floatCtrl.value + delay) % 1.0);
          final y = size.height * (1.0 - t);
          final x = startX + math.sin(t * math.pi * 2 + i) * 30;
          return Positioned(
            left: x,
            top: y,
            child: Opacity(
              opacity: (1.0 - t).clamp(0.0, 0.45),
              child: Icon(
                Icons.favorite,
                size: heartSize,
                color: i.isEven
                    ? Colors.white.withValues(alpha: 0.35)
                    : const Color(0xFFFFAB40).withValues(alpha: 0.35),
              ),
            ),
          );
        },
      );
    });
  }
}

// ─── Animated loading dots ─────────────────────────────────────────────
class _AnimatedLoadingDots extends StatefulWidget {
  final Color color;
  const _AnimatedLoadingDots({required this.color});

  @override
  State<_AnimatedLoadingDots> createState() => _AnimatedLoadingDotsState();
}

class _AnimatedLoadingDotsState extends State<_AnimatedLoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.2;
            final t = ((_ctrl.value - delay) % 1.0).clamp(0.0, 1.0);
            final scale = 0.5 + 0.5 * math.sin(t * math.pi);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
