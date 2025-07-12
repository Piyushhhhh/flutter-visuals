import 'dart:math' as dart_math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/visual_effects_models.dart';
import '../core/constants/app_constants.dart';
import '../core/extensions/offset_extensions.dart';

/// Main painter that delegates to specialized painters
class VisualEffectsPainter extends CustomPainter {
  final VisualEffectsState state;

  const VisualEffectsPainter({required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    // Paint based on current effect type
    switch (state.currentEffectType) {
      case EffectType.particleTrail:
        _ParticlePainter.paint(canvas, state.particles);
        break;
      case EffectType.rippleEffect:
        _RipplePainter.paint(canvas, state.ripples);
        break;
      case EffectType.springObject:
        _SpringObjectPainter.paint(canvas, state.springObject);
        break;
      case EffectType.scribbleDraw:
        _PaintStrokePainter.paint(canvas, state.paintStrokes);
        break;
      case EffectType.sparkleTrail:
        _SparklePainter.paint(canvas, state.sparkles);
        break;
      case EffectType.bezierWeb:
        _BezierWebPainter.paint(canvas, state.bezierWebs);
        _DynamicLinePainter.paint(canvas, state.dynamicLines);
        break;
      case EffectType.floatingBlobs:
        _FloatingBallPainter.paint(canvas, state.floatingBalls);
        break;
    }

    // Always paint cursor
    _CursorPainter.paint(canvas, state.cursorPosition, state.currentPaintColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Painter for paint strokes
class _PaintStrokePainter {
  static void paint(Canvas canvas, List<PaintStroke> strokes) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(stroke.position, stroke.size, paint);
    }
  }
}

/// Painter for dynamic lines
class _DynamicLinePainter {
  static void paint(Canvas canvas, List<DynamicLine> lines) {
    for (final line in lines) {
      if (line.points.length > 1) {
        final paint = Paint()
          ..color = line.color
          ..strokeWidth = AppConstants.lineStrokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        final path = Path();
        path.moveTo(line.points.first.dx, line.points.first.dy);
        for (int i = 1; i < line.points.length; i++) {
          path.lineTo(line.points[i].dx, line.points[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }
}

/// Painter for floating balls
class _FloatingBallPainter {
  static void paint(Canvas canvas, List<FloatingBall> balls) {
    for (final ball in balls) {
      // Shadow
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        ball.position + const Offset(2, 2),
        AppConstants.ballRadius,
        shadowPaint,
      );

      // Main ball
      final paint = Paint()
        ..color = ball.color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(ball.position, AppConstants.ballRadius, paint);

      // Highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        ball.position - const Offset(3, 3),
        AppConstants.ballRadius * 0.3,
        highlightPaint,
      );
    }
  }
}

/// Painter for spring object
class _SpringObjectPainter {
  static void paint(Canvas canvas, SpringObject? springObject) {
    if (springObject == null) return;

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      springObject.position + const Offset(2, 2),
      AppConstants.springObjectRadius,
      shadowPaint,
    );

    // Main object
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        springObject.position, AppConstants.springObjectRadius, paint);

    // Inner ring
    final innerPaint = Paint()
      ..color = Colors.orange.darker(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(springObject.position,
        AppConstants.springObjectRadius * 0.7, innerPaint);

    // Highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      springObject.position - const Offset(4, 4),
      AppConstants.springObjectRadius * 0.3,
      highlightPaint,
    );
  }
}

/// Painter for particles
class _ParticlePainter {
  static void paint(Canvas canvas, List<Particle> particles) {
    for (final particle in particles) {
      // Glow effect
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(particle.life * 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          particle.position, AppConstants.particleRadius * 2, glowPaint);

      // Main particle
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.life)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(particle.position, AppConstants.particleRadius, paint);
    }
  }
}

/// Painter for sparkles
class _SparklePainter {
  static void paint(Canvas canvas, List<Sparkle> sparkles) {
    for (final sparkle in sparkles) {
      final opacity = sparkle.life;
      final sparkleSize =
          AppConstants.sparkleRadius * 3 * sparkle.size; // Increased base size

      // Glow effect
      final glowPaint = Paint()
        ..color = sparkle.color.withOpacity(opacity * 0.3)
        ..style = PaintingStyle.fill;

      // Draw glow circles
      canvas.drawCircle(
        sparkle.position,
        sparkleSize * 2,
        glowPaint,
      );

      // Star shape with rainbow color
      final paint = Paint()
        ..color = sparkle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final path = Path();
      final center = sparkle.position;

      // Create 6-pointed star for more sparkle effect
      for (int i = 0; i < 6; i++) {
        final angle = (i * 2 * 3.14159) / 6;
        final outerRadius = sparkleSize;
        final innerRadius = sparkleSize * 0.5;

        final outerX = center.dx + outerRadius * cos(angle);
        final outerY = center.dy + outerRadius * sin(angle);

        final innerAngle = angle + 3.14159 / 6;
        final innerX = center.dx + innerRadius * cos(innerAngle);
        final innerY = center.dy + innerRadius * sin(innerAngle);

        if (i == 0) {
          path.moveTo(outerX, outerY);
        } else {
          path.lineTo(outerX, outerY);
        }
        path.lineTo(innerX, innerY);
      }
      path.close();

      canvas.drawPath(path, paint);

      // Add a bright center dot
      final centerPaint = Paint()
        ..color = Colors.white.withOpacity(opacity * 0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        sparkle.position,
        sparkleSize * 0.3,
        centerPaint,
      );

      // Add sparkle "rays" effect
      final rayPaint = Paint()
        ..color = sparkle.color.withOpacity(opacity * 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 * sparkle.size
        ..strokeCap = StrokeCap.round;

      // Draw cross rays
      canvas.drawLine(
        Offset(sparkle.position.dx - sparkleSize * 0.8, sparkle.position.dy),
        Offset(sparkle.position.dx + sparkleSize * 0.8, sparkle.position.dy),
        rayPaint,
      );
      canvas.drawLine(
        Offset(sparkle.position.dx, sparkle.position.dy - sparkleSize * 0.8),
        Offset(sparkle.position.dx, sparkle.position.dy + sparkleSize * 0.8),
        rayPaint,
      );
    }
  }
}

/// Painter for ripples
class _RipplePainter {
  static void paint(Canvas canvas, List<Ripple> ripples) {
    for (final ripple in ripples) {
      final paint = Paint()
        ..color = Colors.blue.withOpacity(ripple.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(ripple.position, ripple.radius, paint);

      // Inner ripple
      if (ripple.radius > 10) {
        final innerPaint = Paint()
          ..color = Colors.cyan.withOpacity(ripple.opacity * 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawCircle(ripple.position, ripple.radius * 0.6, innerPaint);
      }
    }
  }
}

/// Painter for animated shapes
class _AnimatedShapePainter {
  static void paint(Canvas canvas, List<AnimatedShape> shapes) {
    for (final shape in shapes) {
      final paint = Paint()
        ..color = Colors.purple.withOpacity(0.7 * shape.scale)
        ..style = PaintingStyle.fill;

      if (shape.type == ShapeType.circle) {
        // Gradient circle
        final gradient = RadialGradient(
          colors: [
            Colors.purple.withOpacity(0.8 * shape.scale),
            Colors.purple.withOpacity(0.3 * shape.scale),
          ],
        );

        final gradientPaint = Paint()
          ..shader = gradient.createShader(
            Rect.fromCircle(
              center: shape.position,
              radius: AppConstants.shapeRadius * shape.scale,
            ),
          );

        canvas.drawCircle(
          shape.position,
          AppConstants.shapeRadius * shape.scale,
          gradientPaint,
        );
      } else {
        // Triangle
        final path = Path();
        final size = AppConstants.triangleSize * shape.scale;
        path.moveTo(shape.position.dx, shape.position.dy - size);
        path.lineTo(shape.position.dx - size, shape.position.dy + size);
        path.lineTo(shape.position.dx + size, shape.position.dy + size);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }
}

/// Painter for UI cards
class _UICardPainter {
  static void paint(Canvas canvas, List<UICard> cards) {
    for (final card in cards) {
      canvas.save();
      canvas.translate(card.position.dx, card.position.dy);
      canvas.scale(card.scale);
      canvas.rotate(card.rotation);

      // Card shadow
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      final shadowRect = Rect.fromCenter(
        center: const Offset(2, 2),
        width: AppConstants.cardWidth,
        height: AppConstants.cardHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(shadowRect, const Radius.circular(8)),
        shadowPaint,
      );

      // Main card
      final paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: AppConstants.cardWidth,
        height: AppConstants.cardHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        paint,
      );

      // Card border
      final borderPaint = Paint()
        ..color = Colors.grey.shade300
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppConstants.cardBorderWidth;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        borderPaint,
      );

      // Card content (simple lines)
      final contentPaint = Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      for (int i = 0; i < 3; i++) {
        final y = -15.0 + (i * 10);
        canvas.drawLine(
          Offset(-20, y),
          Offset(20, y),
          contentPaint,
        );
      }

      canvas.restore();
    }
  }
}

/// Painter for bezier webs
class _BezierWebPainter {
  static void paint(Canvas canvas, List<BezierWeb> webs) {
    for (final web in webs) {
      if (web.controlPoints.length >= 2) {
        final paint = Paint()
          ..color = web.color.withOpacity(web.opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;

        final path = Path();
        path.moveTo(web.controlPoints.first.dx, web.controlPoints.first.dy);

        // Create smooth bezier curves through all points
        for (int i = 1; i < web.controlPoints.length - 1; i++) {
          final current = web.controlPoints[i];
          final next = web.controlPoints[i + 1];

          // Create control point for smoother curve
          final controlPoint = Offset(
            current.dx + (next.dx - current.dx) * 0.5,
            current.dy + (next.dy - current.dy) * 0.5,
          );

          path.quadraticBezierTo(
            current.dx,
            current.dy,
            controlPoint.dx,
            controlPoint.dy,
          );
        }

        // Connect to the last point
        if (web.controlPoints.length > 1) {
          path.lineTo(web.controlPoints.last.dx, web.controlPoints.last.dy);
        }

        canvas.drawPath(path, paint);

        // Add glow effect
        final glowPaint = Paint()
          ..color = web.color.withOpacity(web.opacity * 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6.0
          ..strokeCap = StrokeCap.round;

        canvas.drawPath(path, glowPaint);
      }
    }
  }
}

/// Painter for cursor with shadow and glow
class _CursorPainter {
  static void paint(
      Canvas canvas, Offset? cursorPosition, Color currentPaintColor) {
    if (cursorPosition == null) return;

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      cursorPosition + const Offset(3, 3),
      AppConstants.cursorShadowRadius,
      shadowPaint,
    );

    // Glow
    final glowGradient = RadialGradient(
      colors: [
        currentPaintColor.withOpacity(0.4),
        currentPaintColor.withOpacity(0.0),
      ],
    );

    final glowPaint = Paint()
      ..shader = glowGradient.createShader(
        Rect.fromCircle(
          center: cursorPosition,
          radius: AppConstants.cursorGlowRadius,
        ),
      );
    canvas.drawCircle(cursorPosition, AppConstants.cursorGlowRadius, glowPaint);

    // Main cursor
    final cursorPaint = Paint()
      ..color = currentPaintColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(cursorPosition, AppConstants.cursorRadius, cursorPaint);

    // Inner ring
    final ringPaint = Paint()
      ..color = currentPaintColor.darker(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
        cursorPosition, AppConstants.cursorRadius * 0.7, ringPaint);

    // Inner highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      cursorPosition - const Offset(5, 5),
      AppConstants.cursorHighlightRadius,
      highlightPaint,
    );
  }
}

// Helper functions for trigonometry
double cos(double angle) => dart_math.cos(angle);
double sin(double angle) => dart_math.sin(angle);
