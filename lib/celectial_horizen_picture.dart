import 'dart:math';
import 'dart:ui';
import 'navigation_format_tool.dart';
import 'package:flutter/material.dart';

class CelectialMeridianBase extends CustomPainter {
  final Brightness systemBrightness;

  CelectialMeridianBase(this.systemBrightness);

  bool isDarkMode() {
    return systemBrightness == Brightness.dark;
  }

  final Paint _paint = Paint()
    ..color = Colors.black87
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      _paint..color = isDarkMode() ? Colors.white70 : Colors.black87,
    );
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(size.width, size.height / 2), _paint);
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CelectialMeridian extends CustomPainter {
  late double lat, t, dec, h, z;
  CelectialMeridian(
      {required this.lat,
      required this.dec,
      required this.t,
      required this.h,
      required this.z});
  final Paint _horizonPaint = Paint()
    ..color = const Color.fromARGB(255, 90, 179, 151)
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0;
  final Paint _equatorPaint = Paint()
    ..color = const Color.fromARGB(253, 11, 115, 180)
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0;
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2,
        centerY = size.height / 2,
        r = size.height / 2;
    canvas.drawLine(Offset(centerX - r * sin(lat), centerY + r * cos(lat)),
        Offset(centerX + r * sin(lat), centerY - r * cos(lat)), _equatorPaint);
    canvas.drawLine(
        Offset(size.width / 2 - size.height / 2 * cos(lat),
            size.height / 2 - size.height / 2 * sin(lat)),
        Offset(size.width / 2 + size.height / 2 * cos(lat),
            size.height / 2 + size.height / 2 * sin(lat)),
        _equatorPaint);
    Rect horizen = Rect.fromCircle(
        center: Offset(r, centerY - r * sin(h)), radius: r * cos(h));
    Rect equator = Rect.fromCircle(
        center: Offset(centerX - r * sin(dec) * cos(lat),
            centerY - (r * sin(dec)) * sin(lat)),
        radius: r * cos(dec));
    canvas.drawArc(
        equator, -pi / 2 + lat, -pi * signNonZero(dec), true, _equatorPaint);
    canvas.drawArc(horizen, 0, signNonZero(h) * -pi, true, _horizonPaint);

    Path horizonPerp = Path();
    horizonPerp.moveTo(centerX - r * cos(h) * cos(z), centerY - r * sin(h));
    horizonPerp.lineTo(centerX - r * cos(h) * cos(z),
        centerY - r * sin(h) - r * cos(h) * sin(z.abs()));
    const DashPainter(span: 10, step: 7)
        .paint(canvas, horizonPerp, _horizonPaint);
    double equatorX = centerX - r * sin(dec) * cos(lat),
        equatorY = centerY - r * sin(dec) * sin(lat),
        equatorR = r * cos(dec);
    Path equatorPerp = Path();
    equatorPerp.moveTo(centerX - r * cos(h) * cos(z), centerY - r * sin(h));
    equatorPerp.lineTo(
        equatorX -
            signNonZero(dec) * equatorR * sin(t.abs() - lat * signNonZero(dec)),
        equatorY - equatorR * cos(t.abs() - lat * signNonZero(dec)));
    const DashPainter(span: 10, step: 7)
        .paint(canvas, equatorPerp, _equatorPaint);
    canvas.drawLine(
        Offset(centerX, centerY - r * sin(h)),
        Offset(centerX - r * cos(h) * cos(z),
            centerY - r * sin(h) - r * cos(h) * sin(z.abs())),
        _horizonPaint);
    canvas.drawLine(
        Offset(centerX - r * sin(dec) * cos(lat),
            centerY - (r * sin(dec)) * sin(lat)),
        Offset(
            equatorX -
                signNonZero(dec) *
                    equatorR *
                    sin(t.abs() - lat * signNonZero(dec)),
            equatorY - equatorR * cos(t.abs() - lat * signNonZero(dec))),
        _equatorPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DashPainter {
  final double step;
  final double span;

  const DashPainter({
    this.step = 2,
    this.span = 2,
  });

  double get partLength => step + span;

  void paint(Canvas canvas, Path path, Paint paint) {
    final PathMetrics pms = path.computeMetrics();
    for (var pm in pms) {
      final int count = pm.length ~/ partLength;
      for (int i = 0; i < count; i++) {
        canvas.drawPath(
            pm.extractPath(partLength * i, partLength * i + step), paint);
      }
      final double tail = pm.length % partLength;
      canvas.drawPath(pm.extractPath(pm.length - tail, pm.length), paint);
    }
  }
}
