import 'package:flutter/material.dart';
import '../controllers/visual_effects_controller.dart';
import '../painters/visual_effects_painter.dart';

/// Interactive canvas widget for visual effects
class InteractiveCanvas extends StatefulWidget {
  final VisualEffectsController controller;

  const InteractiveCanvas({
    super.key,
    required this.controller,
  });

  @override
  State<InteractiveCanvas> createState() => _InteractiveCanvasState();
}

class _InteractiveCanvasState extends State<InteractiveCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 16), // ~60 FPS
      vsync: this,
    );

    // Start animation loop
    _animationController.repeat();
    _animationController.addListener(() {
      widget.controller.updateAllEffects();
    });

    // Initialize floating balls
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.initializeFloatingBalls();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Update screen size in controller
        widget.controller.updateScreenSize(constraints.biggest);

        return GestureDetector(
          onPanUpdate: (details) {
            widget.controller.onPanUpdate(details.localPosition);
          },
          onPanStart: (details) {
            widget.controller.onPanStart(details.localPosition);
          },
          onPanEnd: (details) {
            widget.controller.onPanEnd();
          },
          onTapDown: (details) {
            widget.controller.onTapDown(details.localPosition);
          },
          child: ListenableBuilder(
            listenable: widget.controller,
            builder: (context, child) {
              return CustomPaint(
                painter: VisualEffectsPainter(state: widget.controller.state),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
