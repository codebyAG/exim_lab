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
