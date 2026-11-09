import 'package:flutter/material.dart';

class PasswordIcon extends StatelessWidget {
  const PasswordIcon({super.key, required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: const Size(21, 21),
        painter: _PasswordIconPainter(
          visible,
          Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _PasswordIconPainter extends CustomPainter {
  const _PasswordIconPainter(this.visible, this.color);

  final bool visible;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final eye = Path();
    if (visible) {
      eye
        ..moveTo(3, 3)
        ..lineTo(21, 21)
        ..moveTo(10.6, 5.1)
        ..arcToPoint(const Offset(12, 5), radius: const Radius.circular(12))
        ..cubicTo(18.5, 5, 22, 12, 22, 12)
        ..arcToPoint(
          const Offset(18.5, 16.5),
          radius: const Radius.circular(19),
        )
        ..moveTo(6, 6.5)
        ..arcToPoint(
          const Offset(2, 12),
          radius: const Radius.circular(22),
          clockwise: false,
        )
        ..cubicTo(2, 12, 5.5, 19, 12, 19)
        ..arcToPoint(
          const Offset(17.4, 17.6),
          radius: const Radius.circular(12),
          clockwise: false,
        )
        ..moveTo(10, 10)
        ..arcToPoint(
          const Offset(14, 14),
          radius: const Radius.circular(2.8),
          clockwise: false,
        );
    } else {
      eye
        ..moveTo(2, 12)
        ..cubicTo(2, 12, 5.5, 5, 12, 5)
        ..cubicTo(18.5, 5, 22, 12, 22, 12)
        ..cubicTo(22, 12, 18.5, 19, 12, 19)
        ..cubicTo(5.5, 19, 2, 12, 2, 12)
        ..close();
      canvas.drawCircle(const Offset(12, 12), 3, stroke);
    }
    canvas.drawPath(eye, stroke);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PasswordIconPainter oldDelegate) =>
      visible != oldDelegate.visible || color != oldDelegate.color;
}
