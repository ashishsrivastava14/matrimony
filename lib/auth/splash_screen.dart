import 'package:flutter/material.dart';
import 'dart:math';
import '../core/theme.dart';

/// Diverse Indian wedding couple images — Hindu, Tamil, Maharashtrian, etc.
const _splashCoupleImages = [
  'https://images.unsplash.com/photo-1610173826608-e311c4781e40?w=400&h=500&fit=crop',  // Hindu wedding couple with garlands
  'https://images.unsplash.com/photo-1637259883498-f5939e13eb53?w=400&h=500&fit=crop',  // Tamil bride & groom thali ceremony
  'https://images.unsplash.com/photo-1621665421558-831f91fd8f1b?w=400&h=500&fit=crop',  // Maharashtrian couple in traditional attire
  'https://images.unsplash.com/photo-1614093302611-8efc4de12964?w=400&h=500&fit=crop',  // South Indian wedding mangalsutra
  'https://images.unsplash.com/photo-1604604557984-245cea7ed41c?w=400&h=500&fit=crop',  // Indian bride & groom portrait
  'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=400&h=500&fit=crop',  // Hindu wedding fire ceremony
  'https://images.unsplash.com/photo-1583037189850-1921ae7c6c22?w=400&h=500&fit=crop',  // Indian couple with henna
  'https://images.unsplash.com/photo-1609151376730-f246fae4d5a4?w=400&h=500&fit=crop',  // Couple in silk saree & dhoti
  'https://images.unsplash.com/photo-1605774337664-7a846e9cdf17?w=400&h=500&fit=crop',  // Indian wedding celebrations
  'https://images.unsplash.com/photo-1622396090075-ab6b8396dccc?w=400&h=500&fit=crop',  // Couple in gold jewellery
  'https://images.unsplash.com/photo-1609951651556-5334e2706168?w=400&h=500&fit=crop',  // Telugu couple wedding
  'https://images.unsplash.com/photo-1600096194534-95cf5ece04cf?w=400&h=500&fit=crop',  // Indian couple together
];

/// Splash screen shown on app start with couple-photo collage background
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _numberScaleAnim;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic),
    );
    _numberScaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeCtrl,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _fadeCtrl.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/role-selection');
      }
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background couple photo collage ──
          _SplashPhotoCollage(screenSize: size),

          // ── Dark gradient overlay ──
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  const Color(0xFF004D40).withValues(alpha: 0.85),
                  const Color(0xFF004D40).withValues(alpha: 0.95),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // ── Subtle floating hearts ──
          ..._buildFloatingHearts(size),

          // ── Foreground content ──
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: AnimatedBuilder(
                animation: _slideAnim,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _slideAnim.value),
                  child: child,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // ── Logo ──
                    ScaleTransition(
                      scale: _pulseAnim,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.08),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tamil Matrimony',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(color: Colors.black45, blurRadius: 12),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // ── Celebration text ──
                    Text(
                      'Celebrating',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.85),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Big "26" with scale animation ──
                    ScaleTransition(
                      scale: _numberScaleAnim,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFFFD54F),
                            Color(0xFFFFB74D),
                            Colors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          '10',
                          style: TextStyle(
                            fontSize: 110,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                            letterSpacing: 6,
                            shadows: [
                              Shadow(color: Colors.black38, blurRadius: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // ── "Years of Matchmaking!" pill ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Text(
                        'Years of Matchmaking!',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── Stats ──
                    const Text(
                      '10 Million+',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black38, blurRadius: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Happy Marriages',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // ── Bottom gratitude ──
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.volunteer_activism_rounded,
                            color: Colors.white.withValues(alpha: 0.5),
                            size: 22,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'We are truly grateful for your trust in us',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.6),
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

  List<Widget> _buildFloatingHearts(Size size) {
    final rng = Random(99);
    return List.generate(14, (i) {
      final left = rng.nextDouble() * size.width;
      final top = rng.nextDouble() * size.height;
      final heartSize = 10.0 + rng.nextDouble() * 20;
      final opacity = 0.03 + rng.nextDouble() * 0.07;
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
// Splash background photo collage
// ─────────────────────────────────────────────────────────────────────────────
class _SplashPhotoCollage extends StatelessWidget {
  final Size screenSize;
  const _SplashPhotoCollage({required this.screenSize});

  @override
  Widget build(BuildContext context) {
    const cols = 3;
    final tileWidth = screenSize.width / cols;
    final heights = [
      tileWidth * 1.35,
      tileWidth * 1.05,
      tileWidth * 1.25,
    ];

    final tiles = <Widget>[];
    int imgIdx = 0;
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
              url: _splashCoupleImages[imgIdx % _splashCoupleImages.length],
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
