import 'dart:ui';
import 'dart:math' as math;

extension OffsetExtensions on Offset {
  /// Normalizes the offset to a unit vector
  Offset normalized() {
    final magnitude = distance;
    if (magnitude == 0) return Offset.zero;
    return this / magnitude;
  }

  /// Adds random jitter to the offset
  Offset withJitter(double maxJitter) {
    final random = math.Random();
    return this +
        Offset(
          (random.nextDouble() - 0.5) * maxJitter,
          (random.nextDouble() - 0.5) * maxJitter,
        );
  }

  /// Clamps the offset within given bounds
  Offset clampToBounds(Size bounds) {
    return Offset(
      dx.clamp(0.0, bounds.width),
      dy.clamp(0.0, bounds.height),
    );
  }

  /// Rotates the offset by given angle in radians
  Offset rotated(double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return Offset(
      dx * cos - dy * sin,
      dx * sin + dy * cos,
    );
  }
}

extension ColorExtensions on Color {
  /// Creates a color with modified opacity
  Color withOpacityFactor(double factor) {
    return withOpacity((opacity * factor).clamp(0.0, 1.0));
  }

  /// Creates a lighter version of the color
  Color lighter(double factor) {
    return Color.lerp(this, const Color(0xFFFFFFFF), factor) ?? this;
  }

  /// Creates a darker version of the color
  Color darker(double factor) {
    return Color.lerp(this, const Color(0xFF000000), factor) ?? this;
  }
}
