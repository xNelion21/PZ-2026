import 'dart:math' as math;

import 'package:flutter/material.dart';

void drawDashedTrail(
  Canvas canvas,
  Path path,
  Paint paint, {
  required double dash,
  required double gap,
  double progress = 1,
}) {
  for (final metric in path.computeMetrics()) {
    final end = metric.length * progress.clamp(0.0, 1.0);
    for (double start = 0; start < end; start += dash + gap) {
      canvas.drawPath(
        metric.extractPath(start, math.min(start + dash, end)),
        paint,
      );
    }
  }
}

void drawTrailCheckpoint(
  Canvas canvas, {
  required Offset point,
  required double radius,
  required Color color,
  required Color background,
  required bool filled,
  required double strokeWidth,
  double pulse = 1,
  double opacity = 1,
  double ringOpacity = 0.3,
  double? ringStartRadius,
  bool outlineFilled = false,
}) {
  final eased = Curves.easeOut.transform(pulse.clamp(0.0, 1.0));
  final expansion = eased < 0.4 ? eased / 0.4 : (1 - eased) / 0.6;
  final dotRadius = radius + 1.4 * expansion;
  if (pulse < 1 && pulse >= 0) {
    canvas.drawCircle(
      point,
      (ringStartRadius ?? radius + 1) + 7 * eased,
      Paint()
        ..color = color.withValues(alpha: ringOpacity * (1 - eased) * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1,
    );
  }
  canvas.drawCircle(
    point,
    dotRadius,
    Paint()..color = (filled ? color : background).withValues(alpha: opacity),
  );
  if (!filled || outlineFilled) {
    canvas.drawCircle(
      point,
      dotRadius,
      Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }
}
