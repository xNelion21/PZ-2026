import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthBackground extends StatefulWidget {
  const AuthBackground({super.key, required this.isRegistration});

  final bool isRegistration;

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground> {
  static final _cache = <String, Future<_ContourData>>{};
  late final Future<_ContourData> _data;

  @override
  void initState() {
    super.initState();
    final page = widget.isRegistration ? 'register' : 'login';
    final asset = 'assets/auth/${page}_background.json';
    _data = _cache.putIfAbsent(asset, () async {
      final json = jsonDecode(await rootBundle.loadString(asset));
      return _ContourData.fromJson(json as Map<String, dynamic>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: FutureBuilder<_ContourData>(
          future: _data,
          builder: (context, snapshot) => snapshot.hasData
              ? RepaintBoundary(
                  child: CustomPaint(painter: _ContourPainter(snapshot.data!)),
                )
              : const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _ContourData {
  const _ContourData(this.size, this.color, this.strokeWidth, this.paths);

  factory _ContourData.fromJson(Map<String, dynamic> json) {
    return _ContourData(
      Size(
        (json['width'] as num).toDouble(),
        (json['height'] as num).toDouble(),
      ),
      Color(
        int.parse(
          (json['stroke'] as String).replaceFirst('#', 'FF'),
          radix: 16,
        ),
      ).withValues(alpha: (json['opacity'] as num).toDouble()),
      (json['strokeWidth'] as num).toDouble(),
      (json['paths'] as List).cast<String>().map(_parseContour).toList(),
    );
  }

  final Size size;
  final Color color;
  final double strokeWidth;
  final List<Path> paths;

  // These exported contours contain only absolute M, L and Q commands.
  static Path _parseContour(String data) {
    final path = Path();
    for (final command in RegExp(r'([MLQ])([^MLQ]+)').allMatches(data)) {
      final points = command[2]!
          .trim()
          .split(RegExp(r'\s+'))
          .map(double.parse)
          .toList();
      switch (command[1]) {
        case 'M':
          path.moveTo(points[0], points[1]);
        case 'L':
          path.lineTo(points[0], points[1]);
        case 'Q':
          path.quadraticBezierTo(points[0], points[1], points[2], points[3]);
      }
    }
    return path;
  }
}

class _ContourPainter extends CustomPainter {
  const _ContourPainter(this.data);

  final _ContourData data;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.max(
      size.width / data.size.width,
      size.height / data.size.height,
    );
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.translate((size.width - data.size.width * scale) / 2, 0);
    canvas.scale(scale);
    final paint = Paint()
      ..color = data.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = data.strokeWidth
      ..strokeCap = StrokeCap.round;
    for (final path in data.paths) {
      canvas.drawPath(path, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ContourPainter oldDelegate) => data != oldDelegate.data;
}
