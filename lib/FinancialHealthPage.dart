import 'dart:math';
import 'package:flutter/material.dart';

class FinancialHealthPage extends StatefulWidget {
  const FinancialHealthPage({super.key});

  @override
  _FinancialHealthPageState createState() => _FinancialHealthPageState();
}

class _FinancialHealthPageState extends State<FinancialHealthPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _needleAnimation;

  double needleAngle = 0; // Final position of the needle
  final double startAngle = pi * 3 / 4; // Starting angle (leftmost)
  final double endAngle = pi / 4; // Ending angle (rightmost)
  final int segments = 4; // Number of scale segments

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Duration of the needle animation
    );

    // Calculate the needle's target position (e.g., "Good")
    final segmentSize = (endAngle - startAngle) / segments;
    needleAngle = startAngle + 2 * segmentSize; // Target: "Good"

    // Debugging: Log the angles
    debugPrint("Start Angle: $startAngle");
    debugPrint("End Angle: $endAngle");
    debugPrint("Target Needle Angle: $needleAngle");

    // Define the needle animation
    _needleAnimation = Tween<double>(
      begin: startAngle,
      end: needleAngle,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Start the animation
    _controller.forward();
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
        title: const Text("Results"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Scale with Needle
            SizedBox(
              height: 250,
              width: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter: ScalePainter(startAngle, endAngle),
                    size: const Size(250, 250),
                  ),
                  AnimatedBuilder(
                    animation: _needleAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: NeedlePainter(_needleAnimation.value),
                        size: const Size(250, 250),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Result Text
            const Text(
              "Financial Health",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Good",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "You are doing great!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Improvement Actions
            const Text(
              "Improve your Financial Health",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildActionItem(
                    "Emergency Fund Planning",
                    "Find out how to create a robust emergency fund for financial resilience.",
                    Colors.green,
                  ),
                  _buildActionItem(
                    "Incremental Growth",
                    "Gradually increase your savings to cover beyond 6 months, enhancing financial security.",
                    Colors.green,
                  ),
                  _buildActionItem(
                    "Create a Financial Roadmap",
                    "Begin your financial wellness journey by drafting a detailed financial plan.",
                    Colors.orange,
                  ),
                  _buildActionItem(
                    "Budget Optimization",
                    "Optimize your budget to allocate more towards your emergency fund monthly.",
                    Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(String title, String description, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(
            Icons.check_circle,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 14),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Add action logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
          ),
          child: const Text(
            "Take Action",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ScalePainter extends CustomPainter {
  final double startAngle;
  final double endAngle;

  ScalePainter(this.startAngle, this.endAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15 // Thicker arc
      ..strokeCap = StrokeCap.round; // Rounded edges

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Gradient definition
    final gradient = SweepGradient(
      colors: [
        Colors.red,
        Colors.orange,
        Colors.green,
        Colors.blue,
      ],
      stops: [0.0, 0.33, 0.66, 1.0],
    );

    // Apply gradient
    paint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    // Draw the scale arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      endAngle - startAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NeedlePainter extends CustomPainter {
  final double needleAngle;

  NeedlePainter(this.needleAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Needle Base
    final basePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.1, basePaint);

    // Needle
    final needlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final needleX = center.dx + radius * 0.7 * cos(needleAngle);
    final needleY = center.dy + radius * 0.7 * sin(needleAngle);

    canvas.drawLine(center, Offset(needleX, needleY), needlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
