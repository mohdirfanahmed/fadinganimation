import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FadingTextAnimation(),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  bool _showFrame = false;
  bool _showImage = true;
  bool _rotateImage = false;

  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Rotates continuously
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void toggleFrame(bool value) {
    setState(() {
      _showFrame = value;
    });
  }

  void toggleImageVisibility() {
    setState(() {
      _showImage = !_showImage;
    });
  }

  void toggleRotation() {
    setState(() {
      _rotateImage = !_rotateImage;
      if (_rotateImage) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fading Text & Image Animation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: toggleVisibility,
              child: AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: _showFrame
                      ? BoxDecoration(
                          border: Border.all(color: Colors.blueAccent, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        )
                      : null,
                  child: const Text(
                    'Hello, Flutter!',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _showImage
                ? AnimatedBuilder(
                    animation: _rotationController,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: AssetImage('assets/img2.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotateImage
                            ? _rotationController.value * 2 * math.pi
                            : 0,
                        child: child,
                      );
                    },
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: Icon(Icons.play_arrow),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Show Frame'),
              value: _showFrame,
              onChanged: toggleFrame,
            ),
            SwitchListTile(
              title: Text('Show Image'),
              value: _showImage,
              onChanged: (bool value) {
                toggleImageVisibility();
              },
            ),
            SwitchListTile(
              title: Text('Rotate Image'),
              value: _rotateImage,
              onChanged: (bool value) {
                toggleRotation();
              },
            ),
          ],
        ),
      ),
    );
  }
}