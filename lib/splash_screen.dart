import 'package:flutter/material.dart';
import 'dart:async';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();

    Timer(const Duration(milliseconds: 3000), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => AuthScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE6F0FF), Color(0xFFCCE0FF)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return SizedBox(
                    height: 100,
                    width: 100,
                    child: CustomPaint(
                      painter: DropletPainter(
                        fillPercentage: _animation.value,
                        isDarkMode: false,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'DripAIyze',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Because, every drop counts !!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropletPainter extends CustomPainter {
  final double fillPercentage;
  final bool isDarkMode;

  DropletPainter({required this.fillPercentage, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final outlinePaint = Paint()
      ..color = Colors.blue.shade500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.fill;

    final path = Path();

    // Draw droplet shape
    path.moveTo(size.width * 0.5, 0);
    path.quadraticBezierTo(
        size.width * 0.1, size.height * 0.5,
        size.width * 0.5, size.height
    );
    path.quadraticBezierTo(
        size.width * 0.9, size.height * 0.5,
        size.width * 0.5, 0
    );

    // Draw the outline
    canvas.drawPath(path, outlinePaint);

    // Create clipping path for the fill based on percentage
    final fillPath = Path();
    fillPath.moveTo(size.width * 0.5, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.lineTo(0, size.height - (size.height * fillPercentage));
    fillPath.lineTo(size.width, size.height - (size.height * fillPercentage));
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Create the intersection of the droplet and the fill rectangle
    final combinedPath = Path.combine(
        PathOperation.intersect,
        path,
        fillPath
    );

    // Draw the fill
    canvas.drawPath(combinedPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant DropletPainter oldDelegate) {
    return oldDelegate.fillPercentage != fillPercentage;
  }
}