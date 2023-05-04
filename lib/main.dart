import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const ProgressBarApp());
}

class ProgressBarApp extends StatelessWidget {
  const ProgressBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Timer? _resetTimer;
  bool _toggle = true;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30))
          ..addListener(() {
            setState(() {});
          });

    _animationController.forward();
    _startResetTimer();
  }

  void _startResetTimer() {
    _resetTimer?.cancel();

    _resetTimer =
        Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      if (!_toggle) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }

      _toggle = !_toggle;
    });
  }

  Color getColorFromProgress(double progress) {
    return Color.lerp(Colors.blue, Colors.red, progress)!;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorTween = ColorTween(
      begin: Colors.white,
      end: Colors.orange,
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          backgroundColor:
              _animationController.status == AnimationStatus.forward
                  ? Colors.white
                  : colorTween.lerp(_animationController.value),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        getColorFromProgress(_animationController.value)),
                    value: _animationController.value,
                  ),
                ),
                const SizedBox(height: 16),
                Text(_toggle ? 'Increasing...' : 'Resetting...'),
              ],
            ),
          ),
        );
      },
    );
  }
}
