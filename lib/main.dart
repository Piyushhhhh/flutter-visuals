import 'package:flutter/material.dart';
import 'controllers/visual_effects_controller.dart';
import 'widgets/interactive_canvas.dart';
import 'widgets/effect_selector.dart';
import 'models/visual_effects_models.dart';

void main() {
  runApp(const VisualsApp());
}

class VisualsApp extends StatelessWidget {
  const VisualsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Visuals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InteractiveVisualsPage(),
    );
  }
}

class _DynamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VisualEffectsController controller;
  final VoidCallback onColorChange;
  final VoidCallback onClear;
  final bool Function(Color) isDarkColor;
  final IconData Function(EffectType) getEffectIcon;

  const _DynamicAppBar({
    required this.controller,
    required this.onColorChange,
    required this.onClear,
    required this.isDarkColor,
    required this.getEffectIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final currentColor = controller.state.currentPaintColor;
        final isDark = isDarkColor(currentColor);

        return AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  currentColor.withOpacity(0.9),
                  currentColor.withOpacity(0.7),
                  currentColor.withOpacity(0.5),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: currentColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          title: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Interactive Visuals'),
                  ],
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    color:
                        (isDark ? Colors.white : Colors.black).withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        getEffectIcon(controller.state.currentEffectType),
                        size: 14,
                        color: (isDark ? Colors.white : Colors.black)
                            .withOpacity(0.8),
                      ),
                      const SizedBox(width: 4),
                      Text(controller.state.currentEffectType.displayName),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 4),
              child: IconButton(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        (isDark ? Colors.white : Colors.black).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.color_lens,
                    color: isDark ? Colors.white : Colors.black,
                    size: 20,
                  ),
                ),
                onPressed: onColorChange,
                tooltip: 'Change Paint Color',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        (isDark ? Colors.white : Colors.black).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.clear_all,
                    color: isDark ? Colors.white : Colors.black,
                    size: 20,
                  ),
                ),
                onPressed: onClear,
                tooltip: 'Clear All Effects',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class InteractiveVisualsPage extends StatefulWidget {
  const InteractiveVisualsPage({super.key});

  @override
  State<InteractiveVisualsPage> createState() => _InteractiveVisualsPageState();
}

class _InteractiveVisualsPageState extends State<InteractiveVisualsPage> {
  late final VisualEffectsController _controller;
  bool _showEffectSelector = false;

  @override
  void initState() {
    super.initState();
    _controller = VisualEffectsController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEffectSelector() {
    setState(() {
      _showEffectSelector = !_showEffectSelector;
    });
  }

  void _onEffectChanged(EffectType effectType) {
    _controller.changeEffectType(effectType);
    setState(() {
      _showEffectSelector = false;
    });
  }

  // Helper method to determine if a color is dark
  bool _isDarkColor(Color color) {
    // Calculate luminance using the standard formula
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance < 0.5;
  }

  // Helper method to get appropriate icon for each effect type
  IconData _getEffectIcon(EffectType effectType) {
    switch (effectType) {
      case EffectType.particleTrail:
        return Icons.scatter_plot;
      case EffectType.rippleEffect:
        return Icons.water_drop;
      case EffectType.springObject:
        return Icons.sports_basketball;
      case EffectType.scribbleDraw:
        return Icons.brush;
      case EffectType.sparkleTrail:
        return Icons.auto_awesome;
      case EffectType.bezierWeb:
        return Icons.timeline;
      case EffectType.floatingBlobs:
        return Icons.bubble_chart;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _DynamicAppBar(
        controller: _controller,
        onColorChange: _controller.changePaintColor,
        onClear: _controller.clearAllEffects,
        isDarkColor: _isDarkColor,
        getEffectIcon: _getEffectIcon,
      ),
      body: Stack(
        children: [
          InteractiveCanvas(controller: _controller),
          if (_showEffectSelector)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListenableBuilder(
                    listenable: _controller,
                    builder: (context, child) {
                      return EffectSelector(
                        currentEffect: _controller.state.currentEffectType,
                        onEffectChanged: _onEffectChanged,
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _toggleEffectSelector,
            backgroundColor: Colors.deepPurple,
            heroTag: "effect_selector",
            child: const Icon(Icons.auto_awesome),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _controller.changePaintColor,
            backgroundColor: Colors.orange,
            heroTag: "color_picker",
            child: const Icon(Icons.palette),
          ),
        ],
      ),
    );
  }
}
