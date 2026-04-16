import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 📸 GALLERY ICON PAINTER
class GalleryIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = size.width / 100;

    // Camera Body
    final bodyPaint = Paint()
      ..color = const Color(0xFF1040C1)
      ..style = PaintingStyle.fill;
    final bodyStroke = Paint()
      ..color = const Color(0xFF5599FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;

    final bodyRect = Rect.fromCenter(
      center: Offset(centerX, centerY + 1 * scale),
      width: 50 * scale,
      height: 36 * scale,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(bodyRect, Radius.circular(6 * scale)), bodyPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(bodyRect, Radius.circular(6 * scale)), bodyStroke);

    // Lens Outer
    final lensOuterPaint = Paint()
      ..color = const Color(0xFF0A2066)
      ..style = PaintingStyle.fill;
    final lensOuterStroke = Paint()
      ..color = const Color(0xFF88AAFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;
    canvas.drawCircle(Offset(centerX, centerY + 1 * scale), 12 * scale, lensOuterPaint);
    canvas.drawCircle(Offset(centerX, centerY + 1 * scale), 12 * scale, lensOuterStroke);

    // Lens Middle
    final lensMidPaint = Paint()
      ..color = const Color(0xFF1E5FFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY + 1 * scale), 7 * scale, lensMidPaint);

    // Lens Inner Glint
    final lensInnerPaint = Paint()
      ..color = const Color(0xFF66AAFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY + 1 * scale), 3 * scale, lensInnerPaint);

    // Top Flash/Button
    final flashRect = Rect.fromCenter(
      center: Offset(centerX - 8 * scale, centerY - 23 * scale + 1 * scale),
      width: 12 * scale,
      height: 7 * scale,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(flashRect, Radius.circular(3 * scale)), bodyPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(flashRect, Radius.circular(3 * scale)), 
      bodyStroke..strokeWidth = 1 * scale);

    // Floating Photos
    final photoPaint = Paint()
      ..color = const Color(0xFF0D2880)
      ..style = PaintingStyle.fill;
    final photoStroke = Paint()
      ..color = const Color(0xFF3366CC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * scale;

    // Left Photo
    canvas.save();
    canvas.translate(19 * scale, 23 * scale);
    canvas.rotate(-12 * math.pi / 180);
    final photo1 = Rect.fromCenter(center: Offset.zero, width: 22 * scale, height: 16 * scale);
    canvas.drawRRect(RRect.fromRectAndRadius(photo1, Radius.circular(2 * scale)), photoPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(photo1, Radius.circular(2 * scale)), photoStroke);
    canvas.restore();

    // Right Photo
    canvas.save();
    canvas.translate(80 * scale, 25 * scale);
    canvas.rotate(10 * math.pi / 180);
    final photo2 = Rect.fromCenter(center: Offset.zero, width: 20 * scale, height: 14 * scale);
    canvas.drawRRect(RRect.fromRectAndRadius(photo2, Radius.circular(2 * scale)), photoPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(photo2, Radius.circular(2 * scale)), photoStroke);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 📈 MARKET UPDATES ICON PAINTER
class MarketUpdatesIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 110;

    // Bars
    final barColors = [
      const Color(0xFFFF4444).withValues(alpha: 0.8),
      const Color(0xFFFF6666).withValues(alpha: 0.9),
      const Color(0xFFFF8888),
      const Color(0xFFFFAAAA),
      const Color(0xFFFF6666).withValues(alpha: 0.9),
    ];
    final barHeights = [22.0, 37.0, 49.0, 59.0, 47.0];
    final barX = [15.0, 32.0, 49.0, 66.0, 83.0];

    for (int i = 0; i < 5; i++) {
      final rect = Rect.fromLTWH(
        barX[i] * scale,
        (77 - barHeights[i]) * scale,
        12 * scale,
        barHeights[i] * scale,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(2 * scale)), 
        Paint()..color = barColors[i]);
    }

    // Grid Bottom Line
    canvas.drawLine(
      Offset(10 * scale, 77 * scale),
      Offset(100 * scale, 77 * scale),
      Paint()..color = Colors.white.withValues(alpha: 0.2)..strokeWidth = 1 * scale,
    );

    // Trend Line
    final trendPaint = Paint()
      ..color = const Color(0xFFFFD000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * scale
      ..strokeCap = StrokeCap.round;
    
    final path = Path();
    path.moveTo(12 * scale, 70 * scale);
    path.lineTo(32 * scale, 55 * scale);
    path.lineTo(52 * scale, 40 * scale);
    path.lineTo(72 * scale, 22 * scale);
    path.lineTo(95 * scale, 15 * scale);
    canvas.drawPath(path, trendPaint);

    // Arrow Head
    final arrowPath = Path();
    arrowPath.moveTo(95 * scale, 8 * scale);
    arrowPath.lineTo(102 * scale, 20 * scale);
    arrowPath.lineTo(88 * scale, 20 * scale);
    arrowPath.close();
    canvas.drawPath(arrowPath, Paint()..color = const Color(0xFFFFD000));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// ✈️ IMPORT JOURNEY ICON PAINTER (Airplane)
class ImportJourneyIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 110;

    // Trail lines
    final trailPaint1 = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;
    
    final path1 = Path();
    path1.moveTo(2 * scale, 55 * scale);
    path1.quadraticBezierTo(30 * scale, 50 * scale, 60 * scale, 46 * scale);
    canvas.drawPath(path1, trailPaint1);

    // Clouds
    final cloudPaint = Paint()..color = Colors.white.withValues(alpha: 0.12);
    canvas.drawOval(Rect.fromCenter(center: Offset(75 * scale, 18 * scale), width: 32 * scale, height: 18 * scale), cloudPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(86 * scale, 20 * scale), width: 20 * scale, height: 14 * scale), 
      cloudPaint..color = Colors.white.withValues(alpha: 0.1));

    // Airplane Body Group
    canvas.save();
    canvas.translate(8 * scale, 15 * scale);
    canvas.rotate(-15 * math.pi / 180);

    final fuselagePaint = Paint()..color = const Color(0xFFC8D8FF);
    canvas.drawOval(Rect.fromCenter(center: Offset(45 * scale, 25 * scale), width: 72 * scale, height: 16 * scale), fuselagePaint);

    final nosePath = Path();
    nosePath.moveTo(81 * scale, 25 * scale);
    nosePath.quadraticBezierTo(92 * scale, 25 * scale, 88 * scale, 27 * scale);
    nosePath.quadraticBezierTo(84 * scale, 28 * scale, 76 * scale, 27 * scale);
    nosePath.close();
    canvas.drawPath(nosePath, Paint()..color = const Color(0xFFE8F0FF));

    final wingPaint = Paint()..color = const Color(0xFF88AAFF);
    final topWing = Path();
    topWing.moveTo(34 * scale, 25 * scale);
    topWing.lineTo(48 * scale, 8 * scale);
    topWing.lineTo(54 * scale, 8 * scale);
    topWing.lineTo(46 * scale, 25 * scale);
    topWing.close();
    canvas.drawPath(topWing, wingPaint);

    final botWing = Path();
    botWing.moveTo(34 * scale, 25 * scale);
    botWing.lineTo(48 * scale, 42 * scale);
    botWing.lineTo(54 * scale, 42 * scale);
    botWing.lineTo(46 * scale, 25 * scale);
    botWing.close();
    canvas.drawPath(botWing, wingPaint);

    // Tail
    final tail1 = Path();
    tail1.moveTo(9 * scale, 25 * scale);
    tail1.lineTo(4 * scale, 17 * scale);
    tail1.lineTo(11 * scale, 19 * scale);
    tail1.close();
    canvas.drawPath(tail1, wingPaint);
    
    final tail2 = Path();
    tail2.moveTo(9 * scale, 25 * scale);
    tail2.lineTo(4 * scale, 33 * scale);
    tail2.lineTo(11 * scale, 31 * scale);
    tail2.close();
    canvas.drawPath(tail2, wingPaint);

    // Windows
    final windowPaint = Paint()..color = const Color(0xFF1E5FFF);
    canvas.drawCircle(Offset(58 * scale, 23 * scale), 2.5 * scale, windowPaint);
    canvas.drawCircle(Offset(50 * scale, 23 * scale), 2.5 * scale, windowPaint);
    canvas.drawCircle(Offset(42 * scale, 23 * scale), 2.5 * scale, windowPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🚢 EXPORT JOURNEY ICON PAINTER (Ship)
class ExportJourneyIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 110;

    // Water
    final waterPath = Path();
    waterPath.moveTo(0, 68 * scale);
    waterPath.quadraticBezierTo(18 * scale, 62 * scale, 36 * scale, 68 * scale);
    waterPath.quadraticBezierTo(54 * scale, 74 * scale, 72 * scale, 68 * scale);
    waterPath.quadraticBezierTo(90 * scale, 62 * scale, 110 * scale, 68 * scale);
    waterPath.lineTo(110 * scale, 80 * scale);
    waterPath.lineTo(0, 80 * scale);
    waterPath.close();
    canvas.drawPath(waterPath, Paint()..color = const Color(0xFF1040C1).withValues(alpha: 0.5));

    // Hull
    final hullPath = Path();
    hullPath.moveTo(10 * scale, 58 * scale);
    hullPath.lineTo(100 * scale, 58 * scale);
    hullPath.lineTo(96 * scale, 68 * scale);
    hullPath.lineTo(14 * scale, 68 * scale);
    hullPath.close();
    canvas.drawPath(hullPath, Paint()..color = const Color(0xFFDDE8FF));

    // Deck Structure
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(22 * scale, 42 * scale, 66 * scale, 16 * scale), Radius.circular(2 * scale)), 
      Paint()..color = const Color(0xFFC8D8FF));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(35 * scale, 32 * scale, 40 * scale, 12 * scale), Radius.circular(2 * scale)), 
      Paint()..color = const Color(0xFFB0C8FF));

    // Containers
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(24 * scale, 44 * scale, 14 * scale, 10 * scale), Radius.circular(1 * scale)), 
      Paint()..color = const Color(0xFFFF2D35));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(40 * scale, 44 * scale, 14 * scale, 10 * scale), Radius.circular(1 * scale)), 
      Paint()..color = const Color(0xFFFFD000));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(56 * scale, 44 * scale, 14 * scale, 10 * scale), Radius.circular(1 * scale)), 
      Paint()..color = const Color(0xFF44BBFF));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(72 * scale, 44 * scale, 12 * scale, 10 * scale), Radius.circular(1 * scale)), 
      Paint()..color = const Color(0xFF44DD66));

    // Chimney & Smoke
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(52 * scale, 18 * scale, 6 * scale, 16 * scale), Radius.circular(2 * scale)), 
      Paint()..color = const Color(0xFF888888));
    canvas.drawOval(Rect.fromCenter(center: Offset(58 * scale, 12 * scale), width: 12 * scale, height: 8 * scale), 
      Paint()..color = const Color(0xFF969696).withValues(alpha: 0.3));
    canvas.drawOval(Rect.fromCenter(center: Offset(62 * scale, 7 * scale), width: 8 * scale, height: 6 * scale), 
      Paint()..color = const Color(0xFF969696).withValues(alpha: 0.2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🧮 EXPORT PRICE CALCULATOR ICON
class ExportPriceIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 32;
    final paint = Paint()
      ..color = const Color(0xFF1040C1)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = const Color(0xFF5599FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(4 * scale, 4 * scale, 24 * scale, 24 * scale), Radius.circular(4 * scale)),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(4 * scale, 4 * scale, 24 * scale, 24 * scale), Radius.circular(4 * scale)),
      stroke,
    );

    final itemPaint = Paint()..color = const Color(0xFF88BBFF);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(8 * scale, 8 * scale, 7 * scale, 5 * scale), Radius.circular(1 * scale)), itemPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(17 * scale, 8 * scale, 7 * scale, 5 * scale), Radius.circular(1 * scale)), itemPaint);
    
    itemPaint.color = const Color(0xFF5599FF);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(8 * scale, 15 * scale, 7 * scale, 4 * scale), Radius.circular(1 * scale)), itemPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(17 * scale, 15 * scale, 7 * scale, 4 * scale), Radius.circular(1 * scale)), itemPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(17 * scale, 21 * scale, 7 * scale, 4 * scale), Radius.circular(1 * scale)), itemPaint);

    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(8 * scale, 21 * scale, 7 * scale, 4 * scale), Radius.circular(1 * scale)), 
      Paint()..color = const Color(0xFFFFD000));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 📦 IMPORT CALCULATOR ICON
class ImportCalcIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 32;
    final paint = Paint()
      ..color = const Color(0xFFC8151B)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = const Color(0xFFFF8888)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;

    final path = Path();
    path.moveTo(16 * scale, 4 * scale);
    path.lineTo(28 * scale, 10 * scale);
    path.lineTo(28 * scale, 22 * scale);
    path.lineTo(16 * scale, 28 * scale);
    path.lineTo(4 * scale, 22 * scale);
    path.lineTo(4 * scale, 10 * scale);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, stroke);

    canvas.drawLine(Offset(16 * scale, 4 * scale), Offset(16 * scale, 28 * scale), stroke..strokeWidth = 1 * scale..color = stroke.color.withValues(alpha: 0.5));
    
    final crossLine = Path();
    crossLine.moveTo(4 * scale, 10 * scale);
    crossLine.lineTo(16 * scale, 16 * scale);
    crossLine.lineTo(28 * scale, 10 * scale);
    canvas.drawPath(crossLine, stroke..strokeWidth = 1.5 * scale..color = const Color(0xFFFF8888));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🚚 LOGISTICS ICON
class LogisticsIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 32;
    final paint = Paint()
      ..color = const Color(0xFF1040C1)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = const Color(0xFF88AAFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(2 * scale, 12 * scale, 18 * scale, 12 * scale), Radius.circular(2 * scale)),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(2 * scale, 12 * scale, 18 * scale, 12 * scale), Radius.circular(2 * scale)),
      stroke,
    );

    final cabPath = Path();
    cabPath.moveTo(20 * scale, 16 * scale);
    cabPath.lineTo(28 * scale, 16 * scale);
    cabPath.lineTo(30 * scale, 22 * scale);
    cabPath.lineTo(20 * scale, 22 * scale);
    cabPath.close();
    canvas.drawPath(cabPath, Paint()..color = const Color(0xFF0A2066));
    canvas.drawPath(cabPath, stroke);

    final wheelPaint = Paint()..color = const Color(0xFF333333);
    canvas.drawCircle(Offset(7 * scale, 26 * scale), 3.5 * scale, wheelPaint);
    canvas.drawCircle(Offset(7 * scale, 26 * scale), 3.5 * scale, stroke);
    canvas.drawCircle(Offset(25 * scale, 26 * scale), 3.5 * scale, wheelPaint);
    canvas.drawCircle(Offset(25 * scale, 26 * scale), 3.5 * scale, stroke);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🌐 BUYER ACQUISITION ICON
class BuyerIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 32;
    final stroke = Paint()
      ..color = const Color(0xFFFFD000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;

    canvas.drawCircle(Offset(16 * scale, 16 * scale), 12 * scale, Paint()..color = const Color(0xFF7A4400));
    canvas.drawCircle(Offset(16 * scale, 16 * scale), 12 * scale, stroke);

    final ellipsePaint = Paint()..color = const Color(0xFFFFD000).withValues(alpha: 0.6)..style = PaintingStyle.stroke..strokeWidth = 1 * scale;
    canvas.drawOval(Rect.fromCenter(center: Offset(16 * scale, 16 * scale), width: 10 * scale, height: 24 * scale), ellipsePaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(16 * scale, 16 * scale), width: 24 * scale, height: 10 * scale), ellipsePaint);
    canvas.drawLine(Offset(4 * scale, 16 * scale), Offset(28 * scale, 16 * scale), ellipsePaint);

    canvas.drawCircle(Offset(8 * scale, 10 * scale), 2.5 * scale, Paint()..color = const Color(0xFFFFD000));
    canvas.drawCircle(Offset(24 * scale, 10 * scale), 2.5 * scale, Paint()..color = const Color(0xFFFFD000));
    canvas.drawCircle(Offset(16 * scale, 6 * scale), 2.5 * scale, Paint()..color = const Color(0xFFFFD000));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// ⭐ CERT STAR ICON
class CertStarIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 22;
    final paint = Paint()..color = const Color(0xFF1E5FFF)..style = PaintingStyle.fill;
    final stroke = Paint()..color = const Color(0xFF88AAFF)..style = PaintingStyle.stroke..strokeWidth = 1 * scale;

    final path = Path();
    path.moveTo(11 * scale, 2 * scale);
    path.lineTo(13 * scale, 8 * scale);
    path.lineTo(20 * scale, 8 * scale);
    path.lineTo(14 * scale, 12 * scale);
    path.lineTo(16 * scale, 18 * scale);
    path.lineTo(11 * scale, 14 * scale);
    path.lineTo(6 * scale, 18 * scale);
    path.lineTo(8 * scale, 12 * scale);
    path.lineTo(2 * scale, 8 * scale);
    path.lineTo(9 * scale, 8 * scale);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🚢 MASTERCLASS SHIP WATERMARK
class MasterclassShipWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 160;
    final paint = Paint()..color = Colors.white..style = PaintingStyle.fill;

    // Hull
    final hull = Path();
    hull.moveTo(10 * scale, 70 * scale);
    hull.lineTo(150 * scale, 70 * scale);
    hull.lineTo(144 * scale, 85 * scale);
    hull.lineTo(16 * scale, 85 * scale);
    hull.close();
    canvas.drawPath(hull, paint);

    // Bridge levels
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(30 * scale, 48 * scale, 100 * scale, 22 * scale), Radius.circular(3 * scale)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(50 * scale, 32 * scale, 60 * scale, 18 * scale), Radius.circular(3 * scale)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(65 * scale, 18 * scale, 30 * scale, 16 * scale), Radius.circular(2 * scale)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(74 * scale, 6 * scale, 10 * scale, 18 * scale), Radius.circular(2 * scale)), paint);

    // Waves
    final waves = Path();
    waves.moveTo(0, 70 * scale);
    waves.quadraticBezierTo(20 * scale, 60 * scale, 40 * scale, 70 * scale);
    waves.quadraticBezierTo(60 * scale, 80 * scale, 80 * scale, 70 * scale);
    waves.quadraticBezierTo(100 * scale, 60 * scale, 120 * scale, 70 * scale);
    waves.quadraticBezierTo(140 * scale, 80 * scale, 160 * scale, 70 * scale);
    waves.lineTo(160 * scale, 100 * scale);
    waves.lineTo(0, 100 * scale);
    waves.close();
    canvas.drawPath(waves, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// ✈️ MASTERCLASS PLANE WATERMARK
class MasterclassPlaneWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    
    canvas.save();
    canvas.rotate(-25 * 3.14159 / 180);

    final paint = Paint()..color = Colors.white..style = PaintingStyle.fill;

    // Body
    canvas.drawOval(Rect.fromCenter(center: Offset(30 * scale, 15 * scale), width: 48 * scale, height: 10 * scale), paint);

    // Tail
    final tail = Path();
    tail.moveTo(54 * scale, 15 * scale);
    tail.quadraticBezierTo(62 * scale, 15 * scale, 60 * scale, 17 * scale);
    tail.quadraticBezierTo(57 * scale, 18 * scale, 52 * scale, 17 * scale);
    tail.close();
    canvas.drawPath(tail, paint);

    // Wings
    final topWing = Path();
    topWing.moveTo(22 * scale, 15 * scale);
    topWing.lineTo(32 * scale, 4 * scale);
    topWing.lineTo(36 * scale, 4 * scale);
    topWing.lineTo(30 * scale, 15 * scale);
    topWing.close();
    canvas.drawPath(topWing, paint);

    final botWing = Path();
    botWing.moveTo(22 * scale, 15 * scale);
    botWing.lineTo(32 * scale, 26 * scale);
    botWing.lineTo(36 * scale, 26 * scale);
    botWing.lineTo(30 * scale, 15 * scale);
    botWing.close();
    canvas.drawPath(botWing, paint);

    canvas.restore();

    // Dash trail
    final trailPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * scale;
    
    final trailPath = Path();
    trailPath.moveTo(0 * scale, 24 * scale);
    trailPath.quadraticBezierTo(20 * scale, 22 * scale, 40 * scale, 18 * scale);
    
    canvas.drawPath(trailPath, trailPaint); 
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 📋 COURSE THUMBNAIL: CHECKLIST (Blue Card)
class CourseChecklistPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 160;
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Background already handled by Container gradient in Widget

    // Document icon
    paint.color = const Color(0xFF1040C1);
    final docRect = RRect.fromRectAndRadius(Rect.fromLTWH(52 * scale, 18 * scale, 40 * scale, 50 * scale), Radius.circular(4 * scale));
    canvas.drawRRect(docRect, paint);
    
    final strokePaint = Paint()
      ..color = const Color(0xFF88AAFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;
    canvas.drawRRect(docRect, strokePaint);

    // Lines
    final linePaint = Paint()..color = const Color(0xFF88AAFF);
    void drawLine(double x, double y, double w, double alpha) {
      linePaint.color = const Color(0xFF88AAFF).withValues(alpha: alpha);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x * scale, y * scale, w * scale, 3 * scale), Radius.circular(1.5 * scale)), linePaint);
    }

    drawLine(58, 28, 28, 0.8);
    drawLine(58, 34, 22, 0.6);
    drawLine(58, 40, 26, 0.6);
    drawLine(58, 46, 18, 0.4);
    drawLine(58, 52, 24, 0.4);

    // Yellow check
    final checkPaint = Paint()
      ..color = const Color(0xFFFFD000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round;
    final checkPath = Path();
    checkPath.moveTo(72 * scale, 58 * scale);
    checkPath.lineTo(80 * scale, 68 * scale);
    checkPath.lineTo(88 * scale, 58 * scale);
    canvas.drawPath(checkPath, checkPaint);

    // Globe behind
    final globePaint = Paint()
      ..color = const Color(0xFF1E5FFF).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * scale;
    canvas.drawCircle(Offset(120 * scale, 25 * scale), 18 * scale, globePaint);
    
    globePaint.color = const Color(0xFF1E5FFF).withValues(alpha: 0.2);
    canvas.drawOval(Rect.fromCenter(center: Offset(120 * scale, 25 * scale), width: 16 * scale, height: 36 * scale), globePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 💹 COURSE THUMBNAIL: FOREX (Red Card)
class CourseForexPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 160;
    
    // Money/Forex circle
    final circlePaint = Paint()..color = const Color(0xFF8B000C)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(72 * scale, 44 * scale), 26 * scale, circlePaint);
    
    final borderPaint = Paint()
      ..color = const Color(0xFFFF8888)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;
    canvas.drawCircle(Offset(72 * scale, 44 * scale), 26 * scale, borderPaint);

    // Symbols (₹$)
    final textPainter = TextPainter(
      text: TextSpan(
        text: "₹\$",
        style: TextStyle(
          color: const Color(0xFFFFD000),
          fontSize: 18 * scale,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(64 * scale, 34 * scale));

    // Dashed Arrow
    final arrowPaint = Paint()
      ..color = const Color(0xFFFFD000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round;
    
    final arrowPath = Path();
    arrowPath.moveTo(100 * scale, 20 * scale);
    arrowPath.quadraticBezierTo(120 * scale, 30 * scale, 115 * scale, 50 * scale);
    arrowPath.quadraticBezierTo(110 * scale, 70 * scale, 95 * scale, 72 * scale);
    canvas.drawPath(arrowPath, arrowPaint);

    final tipPath = Path();
    tipPath.moveTo(92 * scale, 68 * scale);
    tipPath.lineTo(100 * scale, 78 * scale);
    tipPath.lineTo(104 * scale, 66 * scale);
    tipPath.close();
    canvas.drawPath(tipPath, Paint()..color = const Color(0xFFFFD000));

    // Floating dots
    canvas.drawCircle(Offset(130 * scale, 22 * scale), 8 * scale, Paint()..color = const Color(0xFFFF8888).withValues(alpha: 0.3));
    canvas.drawCircle(Offset(140 * scale, 70 * scale), 6 * scale, Paint()..color = const Color(0xFFFF8888).withValues(alpha: 0.2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🤝 COURSE THUMBNAIL: BUYERS (Gold Card)
class CourseBuyersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 160;
    
    final paint = Paint()..color = const Color(0xFF7A4400)..style = PaintingStyle.fill;
    final stroke = Paint()..color = const Color(0xFFFFD000)..style = PaintingStyle.stroke..strokeWidth = 1.5 * scale;

    // Handshake dots
    canvas.drawCircle(Offset(55 * scale, 38 * scale), 14 * scale, paint);
    canvas.drawCircle(Offset(55 * scale, 38 * scale), 14 * scale, stroke);
    
    canvas.drawCircle(Offset(105 * scale, 38 * scale), 14 * scale, paint);
    canvas.drawCircle(Offset(105 * scale, 38 * scale), 14 * scale, stroke);

    // Smile connector
    final smile = Path();
    smile.moveTo(70 * scale, 46 * scale);
    smile.quadraticBezierTo(80 * scale, 58 * scale, 90 * scale, 46 * scale);
    
    final smilePaint = Paint()
      ..color = const Color(0xFFFFD000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(smile, smilePaint);

    canvas.drawCircle(Offset(80 * scale, 62 * scale), 6 * scale, Paint()..color = const Color(0xFFFFD000).withValues(alpha: 0.8));

    // Network lines
    final netPaint = Paint()..color = const Color(0xFFFFD000).withValues(alpha: 0.3)..strokeWidth = 1 * scale;
    canvas.drawCircle(Offset(30 * scale, 75 * scale), 4 * scale, netPaint);
    canvas.drawCircle(Offset(130 * scale, 75 * scale), 4 * scale, netPaint);
    canvas.drawLine(Offset(30 * scale, 75 * scale), Offset(80 * scale, 62 * scale), netPaint);
    canvas.drawLine(Offset(130 * scale, 75 * scale), Offset(80 * scale, 62 * scale), netPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 📜 POPULAR COURSE ICON: CERTIFICATION (Blue)
class PopularCertPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 64;
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Document
    paint.color = const Color(0xFF1040C1);
    final docRect = RRect.fromRectAndRadius(Rect.fromLTWH(16 * scale, 12 * scale, 32 * scale, 40 * scale), Radius.circular(3 * scale));
    canvas.drawRRect(docRect, paint);
    canvas.drawRRect(docRect, Paint()..color = const Color(0xFF5599FF)..style = PaintingStyle.stroke..strokeWidth = 1 * scale);

    // Lines
    final linePaint = Paint()..color = const Color(0xFF88AAFF);
    void drawLine(double y, double w, double alpha) {
      linePaint.color = const Color(0xFF88AAFF).withValues(alpha: alpha);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20 * scale, y * scale, w * scale, 3 * scale), Radius.circular(1.5 * scale)), linePaint);
    }
    drawLine(18, 24, 0.9);
    drawLine(24, 18, 0.6);
    drawLine(29, 21, 0.6);
    drawLine(34, 16, 0.4);

    // Seal
    canvas.drawCircle(Offset(32 * scale, 44 * scale), 5 * scale, Paint()..color = const Color(0xFFFFD000));
    final textPainter = TextPainter(
      text: TextSpan(text: "IE", style: TextStyle(color: Colors.black, fontSize: 6 * scale, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(29.5 * scale, 41 * scale));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 💰 POPULAR COURSE ICON: FINANCE (Red)
class PopularFinancePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 64;
    
    canvas.drawCircle(Offset(32 * scale, 30 * scale), 16 * scale, Paint()..color = const Color(0xFF8B000C));
    canvas.drawCircle(Offset(32 * scale, 30 * scale), 16 * scale, Paint()..color = const Color(0xFFFF8888)..style = PaintingStyle.stroke..strokeWidth = 1.5 * scale);

    final textPainter = TextPainter(
      text: TextSpan(text: "\$₹", style: TextStyle(color: const Color(0xFFFFD000), fontSize: 13 * scale, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(23 * scale, 22 * scale));

    canvas.drawLine(Offset(20 * scale, 50 * scale), Offset(44 * scale, 50 * scale), Paint()..color = const Color(0xFFFF8888).withValues(alpha: 0.5)..strokeWidth = 2 * scale..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🚢 POPULAR COURSE ICON: LOGISTICS (Teal)
class PopularLogisticsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 64;
    
    // Hull
    canvas.drawPath(Path()
      ..moveTo(12 * scale, 40 * scale)..lineTo(52 * scale, 40 * scale)..lineTo(50 * scale, 48 * scale)..lineTo(14 * scale, 48 * scale)..close(),
      Paint()..color = const Color(0xFFC8D8FF));

    // Containers
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(18 * scale, 30 * scale, 28 * scale, 12 * scale), Radius.circular(2 * scale)), Paint()..color = const Color(0xFFE8F0FF));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(24 * scale, 22 * scale, 16 * scale, 10 * scale), Radius.circular(1 * scale)), Paint()..color = const Color(0xFFC8D8FF));

    // Colored boxes
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20 * scale, 32 * scale, 8 * scale, 6 * scale), Radius.circular(1 * scale)), Paint()..color = const Color(0xFFFF2D35));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(30 * scale, 32 * scale, 8 * scale, 6 * scale), Radius.circular(1 * scale)), Paint()..color = const Color(0xFFFFD000));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(40 * scale, 32 * scale, 8 * scale, 6 * scale), Radius.circular(1 * scale)), Paint()..color = const Color(0xFF44AAFF));

    // Smoke stack
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(30 * scale, 14 * scale, 4 * scale, 10 * scale), Radius.circular(1 * scale)), Paint()..color = Colors.grey);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🌐 POPULAR COURSE ICON: MARKET (Green)
class PopularMarketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 64;
    final strokePaint = Paint()
      ..color = const Color(0xFFFFD000).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;
    
    // Globe outline
    canvas.drawCircle(Offset(32 * scale, 32 * scale), 20 * scale, strokePaint);
    
    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFFFD000).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;
    canvas.drawOval(Rect.fromCenter(center: Offset(32 * scale, 32 * scale), width: 12 * scale, height: 40 * scale), gridPaint);
    canvas.drawLine(Offset(12 * scale, 32 * scale), Offset(52 * scale, 32 * scale), gridPaint);
    
    // Nodes
    final nodePaint = Paint()..color = const Color(0xFFFFD000);
    canvas.drawCircle(Offset(32 * scale, 12 * scale), 3 * scale, nodePaint);
    canvas.drawCircle(Offset(18 * scale, 22 * scale), 3 * scale, nodePaint);
    canvas.drawCircle(Offset(46 * scale, 22 * scale), 3 * scale, nodePaint);
    canvas.drawCircle(Offset(32 * scale, 52 * scale), 3 * scale, nodePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// ▶️ VIDEO PLAY ICON: Standard Play Button with Sound Waves
class VideoPlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Reference SVG ViewBox is 160x90
    final scale = size.width / 160;
    
    // Circle base
    final circlePaint = Paint()
      ..color = const Color(0xFF0D2880)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(80 * scale, 45 * scale), 22 * scale, circlePaint);
    
    final strokePaint = Paint()
      ..color = const Color(0xFF1E5FFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;
    canvas.drawCircle(Offset(80 * scale, 45 * scale), 22 * scale, strokePaint);

    // Play triangle
    final playPaint = Paint()..color = const Color(0xFFFFD000)..style = PaintingStyle.fill;
    final playPath = Path();
    playPath.moveTo(74 * scale, 35 * scale);
    playPath.lineTo(74 * scale, 55 * scale);
    playPath.lineTo(94 * scale, 45 * scale);
    playPath.close();
    canvas.drawPath(playPath, playPaint);

    // Sound waves
    
    // Inner wave
    final wave1 = Path();
    wave1.moveTo(106 * scale, 37 * scale);
    wave1.quadraticBezierTo(114 * scale, 45 * scale, 106 * scale, 53 * scale);
    
    final wave1Paint = Paint()
      ..color = const Color(0xFF1E5FFF).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(wave1, wave1Paint);

    // Outer wave
    final wave2 = Path();
    wave2.moveTo(110 * scale, 31 * scale);
    wave2.quadraticBezierTo(122 * scale, 45 * scale, 110 * scale, 59 * scale);
    
    final wave2Paint = Paint()
      ..color = const Color(0xFF1E5FFF).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(wave2, wave2Paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// ⚡ SHORTS PLAY ICON: Centered Play Circle with Triangle
class ShortsPlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Reference SVG ViewBox is 90x130
    final scale = size.width / 90;
    
    // Circle base
    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(45 * scale, 55 * scale), 20 * scale, circlePaint);
    
    final strokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;
    canvas.drawCircle(Offset(45 * scale, 55 * scale), 20 * scale, strokePaint);

    // Play triangle
    final playPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    final playPath = Path();
    playPath.moveTo(38 * scale, 46 * scale);
    playPath.lineTo(38 * scale, 64 * scale);
    playPath.lineTo(56 * scale, 55 * scale);
    playPath.close();
    canvas.drawPath(playPath, playPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🎞️ SHORTS PATTERN: Abstract Horizontal Stripes
class ShortsPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 90;
    
    // Pattern rectangles (centered horizontally)
    void drawStripe(double y, double width, double height, double opacity) {
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      final x = (90 - width) / 2 * scale;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y * scale, width * scale, height * scale),
          Radius.circular(height / 2 * scale),
        ),
        paint,
      );
    }

    drawStripe(88, 50, 4, 0.3);
    drawStripe(95, 40, 3, 0.2);
    drawStripe(101, 30, 3, 0.15);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🌍 SIIEA BRAND LOGO: Detailed Globe with Continents
class SIIEALogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Reference SVG ViewBox is 36x36
    final scale = size.width / 36;
    
    // Circle base
    final circlePaint = Paint()
      ..color = const Color(0xFF1040C1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(18 * scale, 18 * scale), 16 * scale, circlePaint);
    
    final borderPaint = Paint()
      ..color = const Color(0xFF5599FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;
    canvas.drawCircle(Offset(18 * scale, 18 * scale), 16 * scale, borderPaint);

    // Meridian/Latitude Ellipses
    final linePaint = Paint()
      ..color = const Color(0xFF88AAFF).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * scale;
    
    canvas.drawOval(Rect.fromCenter(center: Offset(18 * scale, 18 * scale), width: 14 * scale, height: 32 * scale), linePaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(18 * scale, 18 * scale), width: 32 * scale, height: 12 * scale), linePaint);

    // Equator Line
    final equatorPaint = Paint()..color = const Color(0xFF88AAFF).withValues(alpha: 0.5)..strokeWidth = 1 * scale;
    canvas.drawLine(Offset(2 * scale, 18 * scale), Offset(34 * scale, 18 * scale), equatorPaint);

    // Continents (Abstract green shapes)
    final continentPaint = Paint()..style = PaintingStyle.fill;
    
    canvas.drawOval(
      Rect.fromCenter(center: Offset(12 * scale, 13 * scale), width: 8 * scale, height: 6 * scale),
      continentPaint..color = const Color(0xFF3A8C3A).withValues(alpha: 0.7)
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(22 * scale, 12 * scale), width: 10 * scale, height: 6 * scale),
      continentPaint..color = const Color(0xFF3A8C3A).withValues(alpha: 0.7)
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(23 * scale, 20 * scale), width: 7 * scale, height: 8 * scale),
      continentPaint..color = const Color(0xFF3A8C3A).withValues(alpha: 0.6)
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// ❓ QUIZ TOPIC ICON PAINTER
class QuizTopicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = size.width / 100;

    // Glowing Background
    final glowPaint = Paint()
      ..color = const Color(0xFFFFD000).withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(Offset(centerX, centerY), 35 * scale, glowPaint);

    // Question Mark Silhouette
    final qPaint = Paint()
      ..color = const Color(0xFFFFD000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * scale
      ..strokeCap = StrokeCap.round;

    final qPath = Path();
    qPath.moveTo(centerX - 12 * scale, centerY - 15 * scale);
    qPath.quadraticBezierTo(centerX - 10 * scale, centerY - 28 * scale, centerX, centerY - 28 * scale);
    qPath.quadraticBezierTo(centerX + 15 * scale, centerY - 28 * scale, centerX + 15 * scale, centerY - 15 * scale);
    qPath.quadraticBezierTo(centerX + 15 * scale, centerY - 5 * scale, centerX, centerY);
    qPath.lineTo(centerX, centerY + 8 * scale);
    canvas.drawPath(qPath, qPaint);

    // Question Mark Dot
    canvas.drawCircle(Offset(centerX, centerY + 18 * scale), 3 * scale, Paint()..color = const Color(0xFFFFD000));

    // Floating Sparkles
    final sparklePaint = Paint()..color = const Color(0xFFFFD000).withValues(alpha: 0.6);
    canvas.drawCircle(Offset(centerX - 22 * scale, centerY - 20 * scale), 2.5 * scale, sparklePaint);
    canvas.drawCircle(Offset(centerX + 25 * scale, centerY + 10 * scale), 2 * scale, sparklePaint);
    canvas.drawCircle(Offset(centerX + 5 * scale, centerY - 35 * scale), 1.5 * scale, sparklePaint);

    // Connecting Nodes
    final nodePaint = Paint()
      ..color = const Color(0xFF1E5FFF).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * scale;
    canvas.drawLine(Offset(centerX - 25 * scale, centerY + 20 * scale), Offset(centerX - 10 * scale, centerY + 10 * scale), nodePaint);
    canvas.drawLine(Offset(centerX + 25 * scale, centerY - 20 * scale), Offset(centerX + 10 * scale, centerY - 10 * scale), nodePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🤖 AI EXPERT ICON PAINTER
class AiExpertPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = size.width / 100;

    // Cerebral Glow
    final brainGlow = Paint()
      ..color = const Color(0xFF1E5FFF).withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(Offset(centerX, centerY), 30 * scale, brainGlow);

    // Robot Head Silhouette
    final headPaint = Paint()
      ..color = const Color(0xFF0A2066)
      ..style = PaintingStyle.fill;
    final headStroke = Paint()
      ..color = const Color(0xFF1E5FFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;

    final headRect = Rect.fromCenter(center: Offset(centerX, centerY + 5 * scale), width: 44 * scale, height: 36 * scale);
    canvas.drawRRect(RRect.fromRectAndRadius(headRect, Radius.circular(8 * scale)), headPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(headRect, Radius.circular(8 * scale)), headStroke);

    // Eyes (Digital Look)
    final eyePaint = Paint()..color = const Color(0xFF44FFBB);
    canvas.drawRect(Rect.fromLTWH(centerX - 12 * scale, centerY + 2 * scale, 8 * scale, 3 * scale), eyePaint);
    canvas.drawRect(Rect.fromLTWH(centerX + 4 * scale, centerY + 2 * scale, 8 * scale, 3 * scale), eyePaint);

    // Neural Grid Lines
    final gridPaint = Paint()
      ..color = const Color(0xFF1E5FFF).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8 * scale;
    
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(centerX - 15 * scale + (i * 15 * scale), centerY - 13 * scale),
        Offset(centerX - 15 * scale + (i * 15 * scale), centerY - 25 * scale),
        gridPaint,
      );
      canvas.drawCircle(Offset(centerX - 15 * scale + (i * 15 * scale), centerY - 28 * scale), 2 * scale, Paint()..color = const Color(0xFF1E5FFF).withValues(alpha: 0.3));
    }

    // Mouth / Sound Pattern
    final soundPaint = Paint()..color = const Color(0xFF1E5FFF).withValues(alpha: 0.6);
    canvas.drawRect(Rect.fromCenter(center: Offset(centerX, centerY + 13 * scale), width: 14 * scale, height: 1.5 * scale), soundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 📚 GUIDE BOOK ICON PAINTER (For PDF Guide)
class GuideBookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = size.width / 100;

    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.2);

    // Book Shadow
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(centerX - 18 * scale, centerY - 22 * scale, 40 * scale, 50 * scale), Radius.circular(4 * scale)), shadowPaint);

    // Book Cover
    final coverPaint = Paint()..color = const Color(0xFF1040C1);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(centerX - 20 * scale, centerY - 25 * scale, 40 * scale, 50 * scale), Radius.circular(4 * scale)), coverPaint);

    // Binding
    final bindPaint = Paint()..color = const Color(0xFF0A2066);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(centerX - 20 * scale, centerY - 25 * scale, 8 * scale, 50 * scale), Radius.circular(4 * scale)), bindPaint);

    // Ornament (Gold)
    final goldPaint = Paint()..color = const Color(0xFFFFD000);
    canvas.drawCircle(Offset(centerX + 5 * scale, centerY - 5 * scale), 8 * scale, goldPaint);
    
    // Ribbon
    final ribbonPaint = Paint()..color = const Color(0xFFFF2D35);
    final rPath = Path();
    rPath.moveTo(centerX - 5 * scale, centerY - 25 * scale);
    rPath.lineTo(centerX - 5 * scale, centerY);
    rPath.lineTo(centerX, centerY - 5 * scale);
    rPath.lineTo(centerX + 5 * scale, centerY);
    rPath.lineTo(centerX + 5 * scale, centerY - 25 * scale);
    rPath.close();
    canvas.drawPath(rPath, ribbonPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🔍 HSN FINDER ICON PAINTER
class HsnFinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    final paint = Paint()..color = const Color(0xFF00C853)..style = PaintingStyle.fill;
    final stroke = Paint()..color = Colors.white.withValues(alpha: 0.8)..style = PaintingStyle.stroke..strokeWidth = 2 * scale;

    // Search Circle
    canvas.drawCircle(Offset(40 * scale, 40 * scale), 25 * scale, paint);
    canvas.drawCircle(Offset(40 * scale, 40 * scale), 25 * scale, stroke);

    // Handle
    canvas.save();
    canvas.translate(40 * scale, 40 * scale);
    canvas.rotate(45 * 3.14159 / 180);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20 * scale, -4 * scale, 30 * scale, 8 * scale), Radius.circular(4 * scale)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20 * scale, -4 * scale, 30 * scale, 8 * scale), Radius.circular(4 * scale)), stroke);
    canvas.restore();

    // Code lines (Simulating HSN code)
    final textPaint = Paint()..color = Colors.white.withValues(alpha: 0.6);
    canvas.drawRect(Rect.fromLTWH(25 * scale, 35 * scale, 12 * scale, 2 * scale), textPaint);
    canvas.drawRect(Rect.fromLTWH(42 * scale, 35 * scale, 12 * scale, 2 * scale), textPaint);
    canvas.drawRect(Rect.fromLTWH(30 * scale, 45 * scale, 20 * scale, 2 * scale), textPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 📐 CBM CALCULATOR ICON PAINTER
class CbmCalculatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    final paint = Paint()..color = const Color(0xFF00B0FF)..style = PaintingStyle.fill;
    
    // Isometric Box
    final path = Path();
    path.moveTo(50 * scale, 20 * scale); // Top
    path.lineTo(80 * scale, 35 * scale);
    path.lineTo(50 * scale, 50 * scale);
    path.lineTo(20 * scale, 35 * scale);
    path.close();
    canvas.drawPath(path, paint);

    path.reset();
    path.moveTo(20 * scale, 35 * scale);
    path.lineTo(50 * scale, 50 * scale);
    path.lineTo(50 * scale, 85 * scale);
    path.lineTo(20 * scale, 70 * scale);
    path.close();
    canvas.drawPath(path, paint..color = const Color(0xFF0091EA));

    path.reset();
    path.moveTo(50 * scale, 50 * scale);
    path.lineTo(80 * scale, 35 * scale);
    path.lineTo(80 * scale, 70 * scale);
    path.lineTo(50 * scale, 85 * scale);
    path.close();
    canvas.drawPath(path, paint..color = const Color(0xFF01579B));

    // Dimension lines
    final linePaint = Paint()..color = Colors.white.withValues(alpha: 0.8)..style = PaintingStyle.stroke..strokeWidth = 1 * scale;
    canvas.drawLine(Offset(10 * scale, 35 * scale), Offset(10 * scale, 70 * scale), linePaint);
    canvas.drawLine(Offset(5 * scale, 35 * scale), Offset(15 * scale, 35 * scale), linePaint);
    canvas.drawLine(Offset(5 * scale, 70 * scale), Offset(15 * scale, 70 * scale), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🧾 GST CALCULATOR ICON PAINTER
class GstCalculatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    final paint = Paint()..color = const Color(0xFFFF6D00)..style = PaintingStyle.fill;
    
    // Calculator Base
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20 * scale, 15 * scale, 60 * scale, 70 * scale), Radius.circular(6 * scale)), paint);
    
    // Display
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(28 * scale, 25 * scale, 44 * scale, 15 * scale), Radius.circular(2 * scale)), Paint()..color = Colors.black.withValues(alpha: 0.3));
    
    // Buttons (%)
    final btnPaint = Paint()..color = Colors.white.withValues(alpha: 0.4);
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        canvas.drawCircle(Offset(32 * scale + (c * 18 * scale), 50 * scale + (r * 12 * scale)), 4 * scale, btnPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// ✅ PRODUCT CERTIFICATION PAINTER
class ProductCertPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    final paint = Paint()..color = const Color(0xFF283593)..style = PaintingStyle.fill;
    
    // Shield
    final path = Path();
    path.moveTo(50 * scale, 15 * scale);
    path.quadraticBezierTo(85 * scale, 15 * scale, 85 * scale, 45 * scale);
    path.quadraticBezierTo(85 * scale, 75 * scale, 50 * scale, 90 * scale);
    path.quadraticBezierTo(15 * scale, 75 * scale, 15 * scale, 45 * scale);
    path.quadraticBezierTo(15 * scale, 15 * scale, 50 * scale, 15 * scale);
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, Paint()..color = const Color(0xFF5C6BC0)..style = PaintingStyle.stroke..strokeWidth = 2 * scale);

    // Check mark
    final checkPaint = Paint()..color = const Color(0xFF44FFBB)..style = PaintingStyle.stroke..strokeWidth = 5 * scale..strokeCap = StrokeCap.round;
    final check = Path();
    check.moveTo(35 * scale, 50 * scale);
    check.lineTo(45 * scale, 60 * scale);
    check.lineTo(65 * scale, 35 * scale);
    canvas.drawPath(check, checkPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 💹 FOREX CONVERTER PAINTER
class ForexConverterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    
    // Two circles
    canvas.drawCircle(Offset(35 * scale, 40 * scale), 20 * scale, Paint()..color = const Color(0xFF2E7D32));
    canvas.drawCircle(Offset(65 * scale, 60 * scale), 20 * scale, Paint()..color = const Color(0xFF1B5E20));

    // Exchange Arrows
    final arrowPaint = Paint()..color = const Color(0xFFFFD000)..style = PaintingStyle.stroke..strokeWidth = 2.5 * scale..strokeCap = StrokeCap.round;
    final arrowPath = Path();
    arrowPath.moveTo(45 * scale, 30 * scale);
    arrowPath.quadraticBezierTo(60 * scale, 35 * scale, 70 * scale, 50 * scale);
    canvas.drawPath(arrowPath, arrowPaint);
    
    arrowPath.reset();
    arrowPath.moveTo(55 * scale, 70 * scale);
    arrowPath.quadraticBezierTo(40 * scale, 65 * scale, 30 * scale, 50 * scale);
    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🏛️ GOV BENEFITS PAINTER
class GovBenefitsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    final paint = Paint()..color = const Color(0xFF7B1FA2)..style = PaintingStyle.fill;
    
    // Building
    canvas.drawRect(Rect.fromLTWH(20 * scale, 45 * scale, 60 * scale, 35 * scale), paint);
    
    // Pillars
    final pillarPaint = Paint()..color = const Color(0xFFCE93D8);
    for (int i = 0; i < 4; i++) {
        canvas.drawRect(Rect.fromLTWH(25 * scale + (i * 14 * scale), 50 * scale, 6 * scale, 30 * scale), pillarPaint);
    }
    
    // Roof
    final path = Path();
    path.moveTo(15 * scale, 45 * scale);
    path.lineTo(50 * scale, 25 * scale);
    path.lineTo(85 * scale, 45 * scale);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 📖 INCOTERMS PAINTER
class IncotermsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;
    final paint = Paint()..color = const Color(0xFF455A64)..style = PaintingStyle.fill;
    
    // Opened Book
    final left = Path();
    left.moveTo(50 * scale, 30 * scale);
    left.quadraticBezierTo(30 * scale, 25 * scale, 15 * scale, 35 * scale);
    left.lineTo(15 * scale, 75 * scale);
    left.quadraticBezierTo(30 * scale, 65 * scale, 50 * scale, 70 * scale);
    left.close();
    canvas.drawPath(left, paint);

    final right = Path();
    right.moveTo(50 * scale, 30 * scale);
    right.quadraticBezierTo(70 * scale, 25 * scale, 85 * scale, 35 * scale);
    right.lineTo(85 * scale, 75 * scale);
    right.quadraticBezierTo(70 * scale, 65 * scale, 50 * scale, 70 * scale);
    right.close();
    canvas.drawPath(right, paint..color = const Color(0xFF263238));

    // Lines
    final linePaint = Paint()..color = Colors.white.withValues(alpha: 0.3)..strokeWidth = 1.5 * scale;
    canvas.drawLine(Offset(25 * scale, 45 * scale), Offset(40 * scale, 40 * scale), linePaint);
    canvas.drawLine(Offset(25 * scale, 55 * scale), Offset(40 * scale, 50 * scale), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
