import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Splash screen shown on app start with celebration theme
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnim = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/role-selection');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade50,
              Colors.orange.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative bunting flags at top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: const Size(double.infinity, 120),
                painter: _BuntingPainter(),
              ),
            ),
            
            // Main content
            FadeTransition(
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
                    // Logo with gradient background
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFFFF9800)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Color(0xFFFF9800),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'tamil\nmatrimony',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Celebration text with decorative elements
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Starburst decoration
                        CustomPaint(
                          size: const Size(200, 200),
                          painter: _StarburstPainter(),
                        ),
                        
                        Column(
                          children: [
                            const Text(
                              'Celebrating!',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF00ACC1),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Big "24" with gradient effect
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF9C27B0),
                                  Color(0xFFFF9800),
                                  Color(0xFF4CAF50),
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                '24',
                                style: TextStyle(
                                  fontSize: 120,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // "Years of Matchmaking!" banner
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00ACC1),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Years of Matchmaking!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Success stats
                    const Column(
                      children: [
                        Text(
                          '10 Million+',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E2E2E),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Happy Marriages',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2E2E2E),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Gratitude message
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'We are truly grateful for your trust in us',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for decorative bunting flags at the top
class _BuntingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFF9C27B0), // Purple
      const Color(0xFFFF9800), // Orange
      const Color(0xFF4CAF50), // Green
      const Color(0xFFE91E63), // Pink
    ];
    
    const flagWidth = 30.0;
    const flagHeight = 40.0;
    final flagCount = (size.width / flagWidth).ceil();
    
    for (int i = 0; i < flagCount; i++) {
      final x = i * flagWidth;
      final color = colors[i % colors.length];
      
      final path = Path()
        ..moveTo(x, 20)
        ..lineTo(x + flagWidth, 20)
        ..lineTo(x + flagWidth, 20 + flagHeight)
        ..lineTo(x + flagWidth / 2, 20 + flagHeight - 10)
        ..lineTo(x, 20 + flagHeight)
        ..close();
      
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      canvas.drawPath(path, paint);
    }
    
    // Draw the string line
    final linePaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(
      const Offset(0, 20),
      Offset(size.width, 20),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for starburst/firework effect behind the number
class _StarburstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final colors = [
      const Color(0xFFFFEB3B).withValues(alpha: 0.3), // Yellow
      const Color(0xFFFF9800).withValues(alpha: 0.3), // Orange
      const Color(0xFF4CAF50).withValues(alpha: 0.3), // Green
    ];
    
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final length = 80.0 + (i % 3) * 10;
      
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      
      final end = Offset(
        center.dx + math.cos(angle) * length,
        center.dy + math.sin(angle) * length,
      );
      
      canvas.drawLine(center, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
