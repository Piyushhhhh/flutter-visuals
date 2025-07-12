import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/visual_effects_models.dart';
import '../core/constants/app_constants.dart';
import '../core/extensions/offset_extensions.dart';

/// Controller for managing visual effects state and logic
class VisualEffectsController extends ChangeNotifier {
  VisualEffectsState _state = const VisualEffectsState(
    currentPaintColor: Colors.blue,
  );

  VisualEffectsState get state => _state;
  Size _screenSize = const Size(
      AppConstants.defaultScreenWidth, AppConstants.defaultScreenHeight);

  final math.Random _random = math.Random();
  final List<Color> _availableColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.cyan,
  ];

  /// Updates the screen size for bounds checking
  void updateScreenSize(Size size) {
    _screenSize = size;
  }

  /// Initializes floating balls
  void initializeFloatingBalls() {
    final balls = <FloatingBall>[];
    for (int i = 0; i < AppConstants.floatingBallCount; i++) {
      balls.add(FloatingBall(
        position: Offset(
          _random.nextDouble() * _screenSize.width,
          _random.nextDouble() * _screenSize.height,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 2,
          (_random.nextDouble() - 0.5) * 2,
        ),
        color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
      ));
    }

    _state = _state.copyWith(floatingBalls: balls);
    notifyListeners();
  }

  /// Updates particles system
  void updateParticles() {
    var particles = List<Particle>.from(_state.particles);

    // Add new particles if cursor is active
    if (_state.cursorPosition != null &&
        particles.length < AppConstants.maxParticles) {
      particles.add(Particle(
        position: _state.cursorPosition!,
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 3,
          (_random.nextDouble() - 0.5) * 3,
        ),
        life: 1.0,
        color: Colors.cyan,
      ));
    }

    // Update existing particles
    particles = particles
        .map((particle) {
          return particle.copyWith(
            position: particle.position + particle.velocity,
            life: particle.life - AppConstants.particleDecay,
            velocity: particle.velocity * AppConstants.particleVelocityDecay,
          );
        })
        .where((particle) => particle.life > 0)
        .toList();

    _state = _state.copyWith(particles: particles);
  }

  /// Updates floating balls physics
  void updateFloatingBalls() {
    final balls = _state.floatingBalls.map((ball) {
      var newPosition = ball.position + ball.velocity;
      var newVelocity = ball.velocity;

      // Bounce off walls
      if (newPosition.dx <= 0 || newPosition.dx >= _screenSize.width) {
        newVelocity = Offset(-newVelocity.dx, newVelocity.dy);
        newPosition =
            Offset(newPosition.dx.clamp(0, _screenSize.width), newPosition.dy);
      }
      if (newPosition.dy <= 0 || newPosition.dy >= _screenSize.height) {
        newVelocity = Offset(newVelocity.dx, -newVelocity.dy);
        newPosition =
            Offset(newPosition.dx, newPosition.dy.clamp(0, _screenSize.height));
      }

      // Cursor interaction
      if (_state.cursorPosition != null) {
        final distance = (_state.cursorPosition! - newPosition).distance;
        if (distance < AppConstants.ballInteractionDistance) {
          final direction = (_state.cursorPosition! - newPosition).normalized();
          newVelocity += direction * AppConstants.ballPushForce;
        }
      }

      return ball.copyWith(
        position: newPosition,
        velocity: newVelocity,
      );
    }).toList();

    _state = _state.copyWith(floatingBalls: balls);
  }

  /// Updates spring object physics
  void updateSpringObject() {
    if (_state.springObject != null && _state.cursorPosition != null) {
      final target = _state.cursorPosition!;
      final current = _state.springObject!.position;

      var velocity = _state.springObject!.velocity;
      velocity += (target - current) * AppConstants.springForce;
      velocity *= AppConstants.dampingForce;

      final newPosition = current + velocity;

      _state = _state.copyWith(
        springObject: _state.springObject!.copyWith(
          position: newPosition,
          velocity: velocity,
        ),
      );
    }
  }

  /// Updates ripples animation
  void updateRipples() {
    final ripples = _state.ripples
        .map((ripple) {
          return ripple.copyWith(
            radius: ripple.radius + 2,
            opacity: (ripple.opacity - 0.02).clamp(0.0, 1.0),
          );
        })
        .where((ripple) => ripple.opacity > 0)
        .toList();

    _state = _state.copyWith(ripples: ripples);
  }

  /// Updates sparkles animation
  void updateSparkles() {
    final sparkles = _state.sparkles
        .map((sparkle) {
          return sparkle.copyWith(
            life: sparkle.life - 0.03,
          );
        })
        .where((sparkle) => sparkle.life > 0)
        .toList();

    _state = _state.copyWith(sparkles: sparkles);
  }

  /// Updates animated shapes
  void updateShapes() {
    final shapes = _state.shapes
        .map((shape) {
          return shape.copyWith(
            scale: (shape.scale + 0.05).clamp(0.0, 1.0),
          );
        })
        .where((shape) => shape.scale < 1.0)
        .toList();

    _state = _state.copyWith(shapes: shapes);
  }

  /// Updates UI cards animation
  void updateUICards() {
    final cards = _state.uiCards
        .map((card) {
          return card.copyWith(
            scale: (card.scale + 0.03).clamp(0.0, 1.0),
            rotation: card.rotation + 0.02,
          );
        })
        .where((card) => card.scale < 1.0)
        .toList();

    _state = _state.copyWith(uiCards: cards);
  }

  /// Handles pan update gesture
  void onPanUpdate(Offset position) {
    _state = _state.copyWith(cursorPosition: position);

    // Create ripple effect
    final ripples = List<Ripple>.from(_state.ripples);
    ripples.add(Ripple(
      position: position,
      radius: 0,
      opacity: 1.0,
    ));

    // Create sparkles
    final sparkles = List<Sparkle>.from(_state.sparkles);
    for (int i = 0; i < AppConstants.sparklesPerTouch; i++) {
      sparkles.add(Sparkle(
        position: position.withJitter(20),
        life: 1.0,
      ));
    }

    // Add paint stroke
    final paintStrokes = List<PaintStroke>.from(_state.paintStrokes);
    paintStrokes.add(PaintStroke(
      position: position,
      color: _state.currentPaintColor,
      size: AppConstants.paintStrokeSize,
    ));

    // Create animated shapes occasionally
    if (_random.nextDouble() < AppConstants.shapeSpawnProbability) {
      final shapes = List<AnimatedShape>.from(_state.shapes);
      shapes.add(AnimatedShape(
        position: position,
        type: _random.nextBool() ? ShapeType.circle : ShapeType.triangle,
        scale: 0.0,
      ));
      _state = _state.copyWith(shapes: shapes);
    }

    // Create UI cards occasionally
    if (_random.nextDouble() < AppConstants.cardSpawnProbability) {
      final cards = List<UICard>.from(_state.uiCards);
      cards.add(UICard(
        position: position,
        scale: 0.0,
        rotation: 0.0,
      ));
      _state = _state.copyWith(uiCards: cards);
    }

    _state = _state.copyWith(
      ripples: ripples,
      sparkles: sparkles,
      paintStrokes: paintStrokes,
    );

    // Start spring object if not exists
    if (_state.springObject == null) {
      _state = _state.copyWith(
        springObject: SpringObject(
          position: position,
          velocity: Offset.zero,
        ),
      );
    }

    notifyListeners();
  }

  /// Handles pan start gesture
  void onPanStart(Offset position) {
    _state = _state.copyWith(
      cursorPosition: position,
      isDrawing: true,
    );

    // Start new dynamic line
    final dynamicLines = List<DynamicLine>.from(_state.dynamicLines);
    dynamicLines.add(DynamicLine(
      points: [position],
      color: _state.currentPaintColor,
    ));

    _state = _state.copyWith(dynamicLines: dynamicLines);
    notifyListeners();
  }

  /// Handles pan end gesture
  void onPanEnd() {
    _state = _state.copyWith(isDrawing: false);
    notifyListeners();
  }

  /// Handles tap down gesture
  void onTapDown(Offset position) {
    _state = _state.copyWith(cursorPosition: position);

    // Create ripple effect
    final ripples = List<Ripple>.from(_state.ripples);
    ripples.add(Ripple(
      position: position,
      radius: 0,
      opacity: 1.0,
    ));

    // Create sparkles
    final sparkles = List<Sparkle>.from(_state.sparkles);
    for (int i = 0; i < AppConstants.sparklesPerTap; i++) {
      sparkles.add(Sparkle(
        position: position.withJitter(30),
        life: 1.0,
      ));
    }

    // Create UI cards
    final cards = List<UICard>.from(_state.uiCards);
    cards.add(UICard(
      position: position,
      scale: 0.0,
      rotation: 0.0,
    ));

    _state = _state.copyWith(
      ripples: ripples,
      sparkles: sparkles,
      uiCards: cards,
    );

    notifyListeners();
  }

  /// Changes the current paint color
  void changePaintColor() {
    final newColor = _availableColors[_random.nextInt(_availableColors.length)];
    _state = _state.copyWith(currentPaintColor: newColor);
    notifyListeners();
  }

  /// Updates all effects (called from animation loop)
  void updateAllEffects() {
    updateParticles();
    updateFloatingBalls();
    updateSpringObject();
    updateRipples();
    updateSparkles();
    updateShapes();
    updateUICards();
    notifyListeners();
  }

  /// Clears all effects
  void clearAllEffects() {
    _state = VisualEffectsState(
      currentPaintColor: _state.currentPaintColor,
    );
    notifyListeners();
  }
}
