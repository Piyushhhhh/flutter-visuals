import 'dart:ui';
import 'package:flutter/foundation.dart';

/// Base class for all visual effect models
@immutable
abstract class VisualEffect {
  const VisualEffect();
}

/// Represents a particle in the particle trail effect
@immutable
class Particle extends VisualEffect {
  final Offset position;
  final Offset velocity;
  final double life;
  final Color color;

  const Particle({
    required this.position,
    required this.velocity,
    required this.life,
    required this.color,
  });

  Particle copyWith({
    Offset? position,
    Offset? velocity,
    double? life,
    Color? color,
  }) {
    return Particle(
      position: position ?? this.position,
      velocity: velocity ?? this.velocity,
      life: life ?? this.life,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Particle &&
        other.position == position &&
        other.velocity == velocity &&
        other.life == life &&
        other.color == color;
  }

  @override
  int get hashCode {
    return position.hashCode ^
        velocity.hashCode ^
        life.hashCode ^
        color.hashCode;
  }
}

/// Represents a ripple effect
@immutable
class Ripple extends VisualEffect {
  final Offset position;
  final double radius;
  final double opacity;

  const Ripple({
    required this.position,
    required this.radius,
    required this.opacity,
  });

  Ripple copyWith({
    Offset? position,
    double? radius,
    double? opacity,
  }) {
    return Ripple(
      position: position ?? this.position,
      radius: radius ?? this.radius,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ripple &&
        other.position == position &&
        other.radius == radius &&
        other.opacity == opacity;
  }

  @override
  int get hashCode {
    return position.hashCode ^ radius.hashCode ^ opacity.hashCode;
  }
}

/// Represents a sparkle effect
@immutable
class Sparkle extends VisualEffect {
  final Offset position;
  final double life;

  const Sparkle({
    required this.position,
    required this.life,
  });

  Sparkle copyWith({
    Offset? position,
    double? life,
  }) {
    return Sparkle(
      position: position ?? this.position,
      life: life ?? this.life,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Sparkle && other.position == position && other.life == life;
  }

  @override
  int get hashCode {
    return position.hashCode ^ life.hashCode;
  }
}

/// Represents a floating ball with physics
@immutable
class FloatingBall extends VisualEffect {
  final Offset position;
  final Offset velocity;
  final Color color;

  const FloatingBall({
    required this.position,
    required this.velocity,
    required this.color,
  });

  FloatingBall copyWith({
    Offset? position,
    Offset? velocity,
    Color? color,
  }) {
    return FloatingBall(
      position: position ?? this.position,
      velocity: velocity ?? this.velocity,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FloatingBall &&
        other.position == position &&
        other.velocity == velocity &&
        other.color == color;
  }

  @override
  int get hashCode {
    return position.hashCode ^ velocity.hashCode ^ color.hashCode;
  }
}

/// Represents a dynamic line drawn by finger movement
@immutable
class DynamicLine extends VisualEffect {
  final List<Offset> points;
  final Color color;

  const DynamicLine({
    required this.points,
    required this.color,
  });

  DynamicLine copyWith({
    List<Offset>? points,
    Color? color,
  }) {
    return DynamicLine(
      points: points ?? this.points,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DynamicLine &&
        listEquals(other.points, points) &&
        other.color == color;
  }

  @override
  int get hashCode {
    return points.hashCode ^ color.hashCode;
  }
}

/// Represents a spring physics object
@immutable
class SpringObject extends VisualEffect {
  final Offset position;
  final Offset velocity;

  const SpringObject({
    required this.position,
    required this.velocity,
  });

  SpringObject copyWith({
    Offset? position,
    Offset? velocity,
  }) {
    return SpringObject(
      position: position ?? this.position,
      velocity: velocity ?? this.velocity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpringObject &&
        other.position == position &&
        other.velocity == velocity;
  }

  @override
  int get hashCode {
    return position.hashCode ^ velocity.hashCode;
  }
}

/// Enum for different shape types
enum ShapeType { circle, triangle }

/// Represents an animated shape
@immutable
class AnimatedShape extends VisualEffect {
  final Offset position;
  final ShapeType type;
  final double scale;

  const AnimatedShape({
    required this.position,
    required this.type,
    required this.scale,
  });

  AnimatedShape copyWith({
    Offset? position,
    ShapeType? type,
    double? scale,
  }) {
    return AnimatedShape(
      position: position ?? this.position,
      type: type ?? this.type,
      scale: scale ?? this.scale,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimatedShape &&
        other.position == position &&
        other.type == type &&
        other.scale == scale;
  }

  @override
  int get hashCode {
    return position.hashCode ^ type.hashCode ^ scale.hashCode;
  }
}

/// Represents a paint stroke
@immutable
class PaintStroke extends VisualEffect {
  final Offset position;
  final Color color;
  final double size;

  const PaintStroke({
    required this.position,
    required this.color,
    required this.size,
  });

  PaintStroke copyWith({
    Offset? position,
    Color? color,
    double? size,
  }) {
    return PaintStroke(
      position: position ?? this.position,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaintStroke &&
        other.position == position &&
        other.color == color &&
        other.size == size;
  }

  @override
  int get hashCode {
    return position.hashCode ^ color.hashCode ^ size.hashCode;
  }
}

/// Represents a UI card
@immutable
class UICard extends VisualEffect {
  final Offset position;
  final double scale;
  final double rotation;

  const UICard({
    required this.position,
    required this.scale,
    required this.rotation,
  });

  UICard copyWith({
    Offset? position,
    double? scale,
    double? rotation,
  }) {
    return UICard(
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UICard &&
        other.position == position &&
        other.scale == scale &&
        other.rotation == rotation;
  }

  @override
  int get hashCode {
    return position.hashCode ^ scale.hashCode ^ rotation.hashCode;
  }
}

/// Represents the state of all visual effects
@immutable
class VisualEffectsState {
  final Offset? cursorPosition;
  final List<Particle> particles;
  final List<Ripple> ripples;
  final List<Sparkle> sparkles;
  final List<FloatingBall> floatingBalls;
  final List<DynamicLine> dynamicLines;
  final List<AnimatedShape> shapes;
  final List<PaintStroke> paintStrokes;
  final List<UICard> uiCards;
  final SpringObject? springObject;
  final Color currentPaintColor;
  final bool isDrawing;

  const VisualEffectsState({
    this.cursorPosition,
    this.particles = const [],
    this.ripples = const [],
    this.sparkles = const [],
    this.floatingBalls = const [],
    this.dynamicLines = const [],
    this.shapes = const [],
    this.paintStrokes = const [],
    this.uiCards = const [],
    this.springObject,
    required this.currentPaintColor,
    this.isDrawing = false,
  });

  VisualEffectsState copyWith({
    Offset? cursorPosition,
    List<Particle>? particles,
    List<Ripple>? ripples,
    List<Sparkle>? sparkles,
    List<FloatingBall>? floatingBalls,
    List<DynamicLine>? dynamicLines,
    List<AnimatedShape>? shapes,
    List<PaintStroke>? paintStrokes,
    List<UICard>? uiCards,
    SpringObject? springObject,
    Color? currentPaintColor,
    bool? isDrawing,
  }) {
    return VisualEffectsState(
      cursorPosition: cursorPosition ?? this.cursorPosition,
      particles: particles ?? this.particles,
      ripples: ripples ?? this.ripples,
      sparkles: sparkles ?? this.sparkles,
      floatingBalls: floatingBalls ?? this.floatingBalls,
      dynamicLines: dynamicLines ?? this.dynamicLines,
      shapes: shapes ?? this.shapes,
      paintStrokes: paintStrokes ?? this.paintStrokes,
      uiCards: uiCards ?? this.uiCards,
      springObject: springObject ?? this.springObject,
      currentPaintColor: currentPaintColor ?? this.currentPaintColor,
      isDrawing: isDrawing ?? this.isDrawing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VisualEffectsState &&
        other.cursorPosition == cursorPosition &&
        listEquals(other.particles, particles) &&
        listEquals(other.ripples, ripples) &&
        listEquals(other.sparkles, sparkles) &&
        listEquals(other.floatingBalls, floatingBalls) &&
        listEquals(other.dynamicLines, dynamicLines) &&
        listEquals(other.shapes, shapes) &&
        listEquals(other.paintStrokes, paintStrokes) &&
        listEquals(other.uiCards, uiCards) &&
        other.springObject == springObject &&
        other.currentPaintColor == currentPaintColor &&
        other.isDrawing == isDrawing;
  }

  @override
  int get hashCode {
    return cursorPosition.hashCode ^
        particles.hashCode ^
        ripples.hashCode ^
        sparkles.hashCode ^
        floatingBalls.hashCode ^
        dynamicLines.hashCode ^
        shapes.hashCode ^
        paintStrokes.hashCode ^
        uiCards.hashCode ^
        springObject.hashCode ^
        currentPaintColor.hashCode ^
        isDrawing.hashCode;
  }
}
