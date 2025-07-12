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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Interactive Visuals'),
                Text(
                  _controller.state.currentEffectType.displayName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _controller.changePaintColor,
            tooltip: 'Change Paint Color',
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _controller.clearAllEffects,
            tooltip: 'Clear All Effects',
          ),
        ],
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
