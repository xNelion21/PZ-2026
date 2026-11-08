import 'package:flutter/material.dart';

import 'trail_painting.dart';

class AuthTrail extends StatefulWidget {
  const AuthTrail({super.key, required this.claimAnimation});

  final bool Function() claimAnimation;

  @override
  State<AuthTrail> createState() => _AuthTrailState();
}

class _AuthTrailState extends State<AuthTrail>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2500),
    value: 1,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    if (!_started) {
      _started = true;
      if (widget.claimAnimation() && !disableAnimations) {
        _controller.forward(from: 0);
      }
    }
    if (disableAnimations) {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final gutter = MediaQuery.sizeOf(context).width <= 355
                ? 20.0
                : 24.0;
            final width = constraints.maxWidth + 2 * gutter;
            final height = width * 160 / 390;
            return SizedBox(
              height: height,
              child: OverflowBox(
                minWidth: width,
                maxWidth: width,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => CustomPaint(
                    size: Size(width, height),
                    painter: _AuthTrailPainter(
                      elapsed: _controller.value * 2500,
                      color: Theme.of(context).colorScheme.primary,
                      background: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthTrailPainter extends CustomPainter {
  const _AuthTrailPainter({
    required this.elapsed,
    required this.color,
    required this.background,
  });

  final double elapsed;
  final Color color;
  final Color background;

  static Path _route({int curves = 5}) {
    final route = Path()
      ..moveTo(-38, 119)
      ..cubicTo(2, 123, 31, 122, 53, 94);
    if (curves >= 2) route.cubicTo(75, 66, 91, 23, 130, 41);
    if (curves >= 3) route.cubicTo(169, 59, 156, 99, 199, 95);
    if (curves >= 4) route.cubicTo(242, 91, 249, 52, 275, 67);
    if (curves >= 5) route.cubicTo(301, 82, 310, 114, 350, 104);
    return route;
  }

  static final _fullRoute = _route();
  static final _length = _fullRoute.computeMetrics().first.length;
  static final _arrivalTimes = [
    for (final curves in [2, 4, 5])
      2300 * _route(curves: curves).computeMetrics().first.length / _length,
  ];
  static const _points = [Offset(130, 41), Offset(275, 67), Offset(350, 104)];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 390, size.height / 160);
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.3
      ..strokeCap = StrokeCap.round;

    drawDashedTrail(
      canvas,
      _fullRoute,
      line,
      dash: 3.8,
      gap: 6,
      progress: (elapsed / 2300).clamp(0.0, 1.0),
    );
    for (var index = 0; index < _points.length; index++) {
      final timeSinceArrival = elapsed - _arrivalTimes[index];
      if (timeSinceArrival < 0) continue;
      drawTrailCheckpoint(
        canvas,
        point: _points[index],
        radius: index == 2 ? 5.4 : 4.5,
        color: color,
        background: background,
        filled: index == 2,
        strokeWidth: 1.7,
        pulse: (timeSinceArrival / 200).clamp(0.0, 1.0),
        opacity: (timeSinceArrival / 80).clamp(0.0, 1.0),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_AuthTrailPainter oldDelegate) =>
      elapsed != oldDelegate.elapsed ||
      color != oldDelegate.color ||
      background != oldDelegate.background;
}
