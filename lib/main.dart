import 'package:flutter/material.dart';
import 'controllers/visual_effects_controller.dart';
import 'widgets/interactive_canvas.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Interactive Visuals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
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
      body: InteractiveCanvas(controller: _controller),
    );
  }
}
