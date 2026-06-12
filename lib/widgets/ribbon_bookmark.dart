import 'package:flutter/material.dart';

class RibbonBookmark extends StatelessWidget {
  const RibbonBookmark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 30),
      painter: _RibbonPainter(),
    );
  }
}

class _RibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF900000) // Crimson red
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2, size.height - 8); // V-cut at the bottom
    path.lineTo(0, size.height);
    path.close();

    // Subtle drop shadow for realism
    canvas.drawShadow(path, Colors.black, 2.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
