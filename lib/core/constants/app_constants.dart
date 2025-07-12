class AppConstants {
  // Animation durations
  static const Duration mainAnimationDuration = Duration(seconds: 1);
  static const Duration rippleAnimationDuration = Duration(milliseconds: 800);
  static const Duration sparkleAnimationDuration = Duration(milliseconds: 600);
  static const Duration springAnimationDuration = Duration(milliseconds: 300);
  static const Duration shapeAnimationDuration = Duration(milliseconds: 500);
  static const Duration shadowAnimationDuration = Duration(milliseconds: 400);
  static const Duration paintAnimationDuration = Duration(milliseconds: 200);
  static const Duration cardAnimationDuration = Duration(milliseconds: 700);

  // Physics constants
  static const double springForce = 0.1;
  static const double dampingForce = 0.8;
  static const double ballInteractionDistance = 50.0;
  static const double ballPushForce = 0.5;
  static const double particleDecay = 0.02;
  static const double particleVelocityDecay = 0.98;

  // Visual constants
  static const int maxParticles = 20;
  static const int floatingBallCount = 8;
  static const int sparklesPerTouch = 3;
  static const int sparklesPerTap = 5;
  static const double ballRadius = 15.0;
  static const double springObjectRadius = 20.0;
  static const double particleRadius = 3.0;
  static const double sparkleRadius = 2.0;
  static const double paintStrokeSize = 8.0;
  static const double cursorRadius = 20.0;
  static const double cursorGlowRadius = 30.0;
  static const double cursorShadowRadius = 25.0;
  static const double cursorHighlightRadius = 8.0;

  // UI Card constants
  static const double cardWidth = 60.0;
  static const double cardHeight = 80.0;
  static const double cardBorderWidth = 2.0;

  // Shape constants
  static const double shapeRadius = 20.0;
  static const double triangleSize = 15.0;

  // Probability constants
  static const double shapeSpawnProbability = 0.1;
  static const double cardSpawnProbability = 0.05;

  // Line drawing constants
  static const double lineStrokeWidth = 3.0;

  // Screen bounds (will be updated dynamically)
  static const double defaultScreenWidth = 400.0;
  static const double defaultScreenHeight = 800.0;
}
