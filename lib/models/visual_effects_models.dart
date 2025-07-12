import 'dart:ui';
import 'package:flutter/foundation.dart';

/// Enum for different visual effect types
enum EffectType {
  particleTrail(
      'Particle Trail', 'Trails of colorful particles following the finger'),
  rippleEffect(
      'Ripple Effect', 'Touch creates expanding circles (like water ripples)'),
  springObject(
      'Spring Object', 'A ball follows your finger with spring physics'),
  scribbleDraw('Scribble Draw', 'Freehand drawing with fading ink'),
  sparkleTrail(
      'Sparkle Trail', 'Glitter/sparkles left behind as you drag your finger'),
  bezierWeb('Bezier Web', 'Connects finger path with curved bezier lines'),
  floatingBlobs(
      'Floating Blobs', 'Touch interacts with autonomous bouncing blobs');

  const EffectType(this.displayName, this.description);
  final String displayName;
  final String description;
}

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
  final Color color;
  final double size;

  const Sparkle({
    required this.position,
    required this.life,
    required this.color,
    this.size = 1.0,
  });

  Sparkle copyWith({
    Offset? position,
    double? life,
    Color? color,
    double? size,
  }) {
    return Sparkle(
      position: position ?? this.position,
      life: life ?? this.life,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Sparkle &&
        other.position == position &&
        other.life == life &&
        other.color == color &&
        other.size == size;
  }

  @override
  int get hashCode {
    return position.hashCode ^ life.hashCode ^ color.hashCode ^ size.hashCode;
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

/// Represents a bezier web connection
@immutable
class BezierWeb extends VisualEffect {
  final List<Offset> controlPoints;
  final Color color;
  final double opacity;

  const BezierWeb({
    required this.controlPoints,
    required this.color,
    required this.opacity,
  });

  BezierWeb copyWith({
    List<Offset>? controlPoints,
    Color? color,
    double? opacity,
  }) {
    return BezierWeb(
      controlPoints: controlPoints ?? this.controlPoints,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BezierWeb &&
        listEquals(other.controlPoints, controlPoints) &&
        other.color == color &&
        other.opacity == opacity;
  }

  @override
  int get hashCode {
    return controlPoints.hashCode ^ color.hashCode ^ opacity.hashCode;
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
  final List<BezierWeb> bezierWebs;
  final SpringObject? springObject;
  final Color currentPaintColor;
  final bool isDrawing;
  final EffectType currentEffectType;

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
    this.bezierWebs = const [],
    this.springObject,
    required this.currentPaintColor,
    this.isDrawing = false,
    this.currentEffectType = EffectType.particleTrail,
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
    List<BezierWeb>? bezierWebs,
    SpringObject? springObject,
    Color? currentPaintColor,
    bool? isDrawing,
    EffectType? currentEffectType,
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
      bezierWebs: bezierWebs ?? this.bezierWebs,
      springObject: springObject ?? this.springObject,
      currentPaintColor: currentPaintColor ?? this.currentPaintColor,
      isDrawing: isDrawing ?? this.isDrawing,
      currentEffectType: currentEffectType ?? this.currentEffectType,
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
        listEquals(other.bezierWebs, bezierWebs) &&
        other.springObject == springObject &&
        other.currentPaintColor == currentPaintColor &&
        other.isDrawing == isDrawing &&
        other.currentEffectType == currentEffectType;
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
        bezierWebs.hashCode ^
        springObject.hashCode ^
        currentPaintColor.hashCode ^
        isDrawing.hashCode ^
        currentEffectType.hashCode;
  }
}
