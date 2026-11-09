import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'trail_painting.dart';

class RegistrationTrail extends StatefulWidget {
  const RegistrationTrail({super.key, required this.stage});

  final int stage;

  @override
  State<RegistrationTrail> createState() => _RegistrationTrailState();
}

class _RegistrationTrailState extends State<RegistrationTrail>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 780),
    value: 1,
  );
  int _previousStage = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _controller.value = 1;
  }

  @override
  void didUpdateWidget(RegistrationTrail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stage != widget.stage) {
      _previousStage = oldWidget.stage;
      if (MediaQuery.disableAnimationsOf(context)) {
        _controller.value = 1;
      } else {
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: '${widget.stage} z 3 etapów uzupełnionych.',
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => SizedBox(
            height: 44,
            child: CustomPaint(
              painter: _RegistrationTrailPainter(
                stage: widget.stage,
                previousStage: _previousStage,
                elapsed: _controller.value * 780,
                color: Theme.of(context).colorScheme.primary,
                background: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegistrationTrailPainter extends CustomPainter {
  const _RegistrationTrailPainter({
    required this.stage,
    required this.previousStage,
    required this.elapsed,
    required this.color,
    required this.background,
  });

  final int stage;
  final int previousStage;
  final double elapsed;
  final Color color;
  final Color background;

  static final _segments = [
    Path()
      ..moveTo(16, 31)
      ..cubicTo(59, 33, 82, 5, 171, 16),
    Path()
      ..moveTo(171, 16)
      ..cubicTo(210, 24, 250, 45, 326, 20),
  ];
  static const _points = [Offset(16, 31), Offset(171, 16), Offset(326, 20)];

  @override
  void paint(Canvas canvas, Size size) {
    // The SVG preserves its aspect ratio inside a fixed 44px-high viewport.
    final scale = math.min(size.width / 342, size.height / 44);
    canvas.save();
    canvas.translate(
      (size.width - 342 * scale) / 2,
      (size.height - 44 * scale) / 2,
    );
    canvas.scale(scale);
    final line = Paint()
      ..color = color.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    for (var index = 0; index < _segments.length; index++) {
      final segment = _segments[index];
      final checkpoint = index + 2;
      line.color = color.withValues(alpha: 0.22);
      drawDashedTrail(canvas, segment, line, dash: 3.4, gap: 5);
      if (stage >= checkpoint) {
        line.color = color;
        final progress = previousStage >= checkpoint
            ? 1.0
            : Curves.easeOut.transform((elapsed / 480).clamp(0.0, 1.0));
        drawDashedTrail(
          canvas,
          segment,
          line,
          dash: 3.4,
          gap: 5,
          progress: progress,
        );
      }
    }
    for (var index = 0; index < _points.length; index++) {
      final checkpoint = index + 1;
      final newlyComplete = stage >= checkpoint && previousStage < checkpoint;
      final delay = checkpoint == 1 ? 0 : 480;
      final pulse = newlyComplete
          ? ((elapsed - delay) / 300).clamp(0.0, 1.0)
          : 1.0;
      drawTrailCheckpoint(
        canvas,
        point: _points[index],
        radius: 4.3,
        color: color,
        background: background,
        filled: stage >= checkpoint,
        strokeWidth: 1.8,
        pulse: pulse,
        ringOpacity: 0.28,
        ringStartRadius: 6,
        outlineFilled: true,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_RegistrationTrailPainter oldDelegate) =>
      stage != oldDelegate.stage ||
      previousStage != oldDelegate.previousStage ||
      elapsed != oldDelegate.elapsed ||
      color != oldDelegate.color ||
      background != oldDelegate.background;
}
