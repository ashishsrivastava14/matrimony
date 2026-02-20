import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable "Powered by QuickPrepAI" branded banner.
/// Drop it anywhere — it adapts to its parent's width.
class PoweredByQuickPrepAI extends StatelessWidget {
  const PoweredByQuickPrepAI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // thin gradient separator
        Container(
          width: 120,
          height: 1,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0x5AFFFFFF),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Text(
          'Powered by',
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.55),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomPaint(
              size: const Size(28, 28),
              painter: _QuickPrepAIIconPainter(),
            ),
            const SizedBox(width: 7),
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF29D9F5),
                  letterSpacing: 0.3,
                ),
                children: const [
                  TextSpan(text: 'Quick'),
                  TextSpan(text: 'Prep'),
                  TextSpan(
                    text: 'AI',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── QuickPrepAI icon painter ────────────────────────────────────────────────
class _QuickPrepAIIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;
    const cyColor = Color(0xFF29D9F5);

    // Cyan rounded-square background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, s, s),
        Radius.circular(s * 0.18),
      ),
      Paint()..color = cyColor,
    );

    // White diamond outline
    final cx = s / 2;
    final cy = s / 2;
    final r = s * 0.36;
    final diamondPath = Path()
      ..moveTo(cx, cy - r)
      ..lineTo(cx + r, cy)
      ..lineTo(cx, cy + r)
      ..lineTo(cx - r, cy)
      ..close();
    canvas.drawPath(
      diamondPath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.065,
    );

    // Small white filled square in the centre (rotated 45°)
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(math.pi / 4);
    final half = s * 0.10;
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: half * 2, height: half * 2),
      Paint()..color = Colors.white,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
