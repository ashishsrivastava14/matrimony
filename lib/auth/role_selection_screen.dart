import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/constants.dart';

/// Curated Indian married couple / wedding images from Unsplash
const _coupleImages = [
  'https://images.unsplash.com/photo-1583037189850-1921ae7c6c22?w=400&h=500&fit=crop',  // Indian wedding couple
  'https://images.unsplash.com/photo-1604604557984-245cea7ed41c?w=400&h=500&fit=crop',  // Indian bride & groom
  'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=500&fit=crop',  // Happy married couple
  'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=400&h=500&fit=crop',  // Indian wedding ceremony
  'https://images.unsplash.com/photo-1609151376730-f246fae4d5a4?w=400&h=500&fit=crop',  // Couple in traditional attire
  'https://images.unsplash.com/photo-1620735692151-26a7e0748f53?w=400&h=500&fit=crop',  // Indian wedding portrait
  'https://images.unsplash.com/photo-1611516491426-03025e6043c8?w=400&h=500&fit=crop',  // Traditional couple
  'https://images.unsplash.com/photo-1545232979-8bf68ee9b1af?w=400&h=500&fit=crop',  // Wedding celebration
  'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400&h=500&fit=crop',  // Romantic couple
  'https://images.unsplash.com/photo-1600096194534-95cf5ece04cf?w=400&h=500&fit=crop',  // Indian couple together
  'https://images.unsplash.com/photo-1606216794074-735e91aa2c92?w=400&h=500&fit=crop',  // Wedding moment
  'https://images.unsplash.com/photo-1594552072238-b8a33785b261?w=400&h=500&fit=crop',  // Happy couple portrait
];

/// Select role before login — redesigned with couple-photo collage background
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background photo collage ──
          _CouplePhotoCollage(screenSize: size),

          // ── Dark gradient overlay for readability ──
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.60),
                  const Color(0xFF004D40).withValues(alpha: 0.88),
                  const Color(0xFF004D40).withValues(alpha: 0.95),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),

          // ── Decorative floating hearts (subtle) ──
          ..._buildFloatingHearts(size),

          // ── Foreground content ──
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 36),
                    // Logo area with glow
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.10),
                            blurRadius: 30,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Tamil Matrimony',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Select your role to continue',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: UserRole.values.length,
                        itemBuilder: (context, i) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 500 + i * 120),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 24 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: _RoleCard(role: UserRole.values[i]),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.verified,
                              color: Colors.white.withValues(alpha: 0.5),
                              size: 14),
                          const SizedBox(width: 6),
                          Text(
                            AppConstants.yearsText,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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

  /// Tiny translucent heart shapes scattered in background
  List<Widget> _buildFloatingHearts(Size size) {
    final rng = Random(42); // fixed seed for deterministic layout
    return List.generate(12, (i) {
      final left = rng.nextDouble() * size.width;
      final top = rng.nextDouble() * size.height;
      final heartSize = 10.0 + rng.nextDouble() * 18;
      final opacity = 0.04 + rng.nextDouble() * 0.08;
      return Positioned(
        left: left,
        top: top,
        child: Icon(
          Icons.favorite,
          size: heartSize,
          color: Colors.white.withValues(alpha: opacity),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Background photo collage – shows couple images in a mosaic / grid pattern
// ─────────────────────────────────────────────────────────────────────────────
class _CouplePhotoCollage extends StatelessWidget {
  final Size screenSize;
  const _CouplePhotoCollage({required this.screenSize});

  @override
  Widget build(BuildContext context) {
    // 3-column staggered grid to fill the screen
    const cols = 3;
    final tileWidth = screenSize.width / cols;
    // Heights alternate for a staggered look
    final heights = [
      tileWidth * 1.35,
      tileWidth * 1.05,
      tileWidth * 1.25,
    ];

    final tiles = <Widget>[];
    int imgIdx = 0;

    // Generate enough rows to cover screen height
    double accumulatedHeight = 0;
    while (accumulatedHeight < screenSize.height + 200) {
      for (int col = 0; col < cols; col++) {
        final h = heights[col];
        tiles.add(
          Positioned(
            left: col * tileWidth,
            top: accumulatedHeight + (col == 1 ? -tileWidth * 0.18 : 0),
            width: tileWidth,
            height: h,
            child: _CollageImage(
              url: _coupleImages[imgIdx % _coupleImages.length],
            ),
          ),
        );
        imgIdx++;
      }
      accumulatedHeight += heights.reduce(max) * 0.85;
    }

    return ClipRect(
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(children: tiles),
      ),
    );
  }
}

class _CollageImage extends StatelessWidget {
  final String url;
  const _CollageImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppColors.primaryDark.withValues(alpha: 0.25),
              child: Center(
                child: Icon(
                  Icons.favorite,
                  color: Colors.white.withValues(alpha: 0.15),
                  size: 28,
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.primaryDark.withValues(alpha: 0.3),
            child: Center(
              child: Icon(
                Icons.favorite,
                color: Colors.white.withValues(alpha: 0.15),
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  const _RoleCard({required this.role});

  IconData get _icon {
    switch (role) {
      case UserRole.guest:
        return Icons.visibility_rounded;
      case UserRole.user:
        return Icons.person_rounded;
      case UserRole.paid:
        return Icons.star_rounded;
      case UserRole.mediator:
        return Icons.handshake_rounded;
      case UserRole.admin:
        return Icons.admin_panel_settings_rounded;
    }
  }

  Color get _iconColor {
    switch (role) {
      case UserRole.guest:
        return const Color(0xFF80CBC4);
      case UserRole.user:
        return const Color(0xFF81D4FA);
      case UserRole.paid:
        return const Color(0xFFFFD54F);
      case UserRole.mediator:
        return const Color(0xFFFFAB91);
      case UserRole.admin:
        return const Color(0xFFCE93D8);
    }
  }

  String get _description {
    switch (role) {
      case UserRole.guest:
        return 'Browse profiles without registration';
      case UserRole.user:
        return 'Free member with basic features';
      case UserRole.paid:
        return 'Premium member with full access';
      case UserRole.mediator:
        return 'Manage profiles and earn commission';
      case UserRole.admin:
        return 'Full platform management access';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            if (role == UserRole.guest) {
              Navigator.of(context).pushReplacementNamed(
                '/login',
                arguments: role,
              );
            } else {
              Navigator.of(context).pushNamed('/login', arguments: role);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white.withValues(alpha: 0.12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _iconColor.withValues(alpha: 0.35),
                        _iconColor.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _iconColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(_icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white70,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
