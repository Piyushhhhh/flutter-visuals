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

  final List<Color> _rainbowColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.cyan,
    Colors.lime,
    const Color(0xFFFF00FF), // Magenta
    Colors.teal,
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
            life: sparkle.life - 0.015, // Slower decay for longer visibility
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

    switch (_state.currentEffectType) {
      case EffectType.particleTrail:
        // Particles will be generated in updateParticles()
        break;
      case EffectType.rippleEffect:
        final ripples = List<Ripple>.from(_state.ripples);
        ripples.add(Ripple(
          position: position,
          radius: 0,
          opacity: 1.0,
        ));
        _state = _state.copyWith(ripples: ripples);
        break;
      case EffectType.springObject:
        // Spring object will follow in updateSpringObject()
        break;
      case EffectType.scribbleDraw:
        final paintStrokes = List<PaintStroke>.from(_state.paintStrokes);
        paintStrokes.add(PaintStroke(
          position: position,
          color: _state.currentPaintColor,
          size: AppConstants.paintStrokeSize,
        ));
        _state = _state.copyWith(paintStrokes: paintStrokes);
        break;
      case EffectType.sparkleTrail:
        final sparkles = List<Sparkle>.from(_state.sparkles);
        // Create more sparkles with rainbow colors and varied sizes
        for (int i = 0; i < AppConstants.sparklesPerTouch * 2; i++) {
          sparkles.add(Sparkle(
            position: position.withJitter(40),
            life: 1.0,
            color: _rainbowColors[_random.nextInt(_rainbowColors.length)],
            size: 0.8 + _random.nextDouble() * 0.4, // Size between 0.8 and 1.2
          ));
        }
        _state = _state.copyWith(sparkles: sparkles);
        break;
      case EffectType.bezierWeb:
        // Add point to current dynamic line
        if (_state.dynamicLines.isNotEmpty) {
          final dynamicLines = List<DynamicLine>.from(_state.dynamicLines);
          final lastLine = dynamicLines.last;
          final updatedLine = lastLine.copyWith(
            points: [...lastLine.points, position],
          );
          dynamicLines[dynamicLines.length - 1] = updatedLine;
          _state = _state.copyWith(dynamicLines: dynamicLines);
        }
        break;
      case EffectType.floatingBlobs:
        // Floating balls will interact in updateFloatingBalls()
        break;
    }

    notifyListeners();
  }

  /// Handles pan start gesture
  void onPanStart(Offset position) {
    _state = _state.copyWith(
      cursorPosition: position,
      isDrawing: true,
    );

    // Start new dynamic line for bezier web effect
    if (_state.currentEffectType == EffectType.bezierWeb) {
      final dynamicLines = List<DynamicLine>.from(_state.dynamicLines);
      dynamicLines.add(DynamicLine(
        points: [position],
        color: _state.currentPaintColor,
      ));
      _state = _state.copyWith(dynamicLines: dynamicLines);
    }

    notifyListeners();
  }

  /// Handles pan end gesture
  void onPanEnd() {
    _state = _state.copyWith(isDrawing: false);

    // Create bezier web from completed line
    if (_state.currentEffectType == EffectType.bezierWeb &&
        _state.dynamicLines.isNotEmpty) {
      final lastLine = _state.dynamicLines.last;
      if (lastLine.points.length >= 2) {
        final webs = List<BezierWeb>.from(_state.bezierWebs);
        webs.add(BezierWeb(
          controlPoints: lastLine.points,
          color: _state.currentPaintColor,
          opacity: 1.0,
        ));
        _state = _state.copyWith(bezierWebs: webs);
      }
    }

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

    // Create sparkles with rainbow colors
    final sparkles = List<Sparkle>.from(_state.sparkles);
    for (int i = 0; i < AppConstants.sparklesPerTap * 2; i++) {
      sparkles.add(Sparkle(
        position: position.withJitter(50),
        life: 1.0,
        color: _rainbowColors[_random.nextInt(_rainbowColors.length)],
        size: 0.8 + _random.nextDouble() * 0.6, // Size between 0.8 and 1.4
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

  /// Changes the current effect type
  void changeEffectType(EffectType effectType) {
    _state = _state.copyWith(currentEffectType: effectType);
    clearAllEffects();

    // Initialize effect-specific elements
    if (effectType == EffectType.floatingBlobs) {
      initializeFloatingBalls();
    } else if (effectType == EffectType.springObject) {
      _state = _state.copyWith(
        springObject: SpringObject(
          position: const Offset(200, 200),
          velocity: Offset.zero,
        ),
      );
    }

    notifyListeners();
  }

  /// Updates bezier webs
  void updateBezierWebs() {
    final webs = _state.bezierWebs
        .map((web) {
          return web.copyWith(
            opacity: (web.opacity - 0.015).clamp(0.0, 1.0),
          );
        })
        .where((web) => web.opacity > 0)
        .toList();

    _state = _state.copyWith(bezierWebs: webs);
  }

  /// Updates all effects (called from animation loop)
  void updateAllEffects() {
    switch (_state.currentEffectType) {
      case EffectType.particleTrail:
        updateParticles();
        break;
      case EffectType.rippleEffect:
        updateRipples();
        break;
      case EffectType.springObject:
        updateSpringObject();
        break;
      case EffectType.scribbleDraw:
        updateShapes();
        break;
      case EffectType.sparkleTrail:
        updateSparkles();
        break;
      case EffectType.bezierWeb:
        updateBezierWebs();
        break;
      case EffectType.floatingBlobs:
        updateFloatingBalls();
        break;
    }
    notifyListeners();
  }

  /// Clears all effects
  void clearAllEffects() {
    _state = VisualEffectsState(
      currentPaintColor: _state.currentPaintColor,
      currentEffectType: _state.currentEffectType,
    );
    notifyListeners();
  }
}
