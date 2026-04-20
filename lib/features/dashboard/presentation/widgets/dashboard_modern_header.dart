import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:exim_lab/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/profile/presentation/screens/profile_screen.dart';

class DashboardModernHeader extends StatelessWidget {
  const DashboardModernHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF020C28)),
      child: Stack(
        children: [
          // 1. DYNAMIC BACKGROUND PAINTER (World Map & Routes)
          Positioned.fill(
            child: CustomPaint(painter: HeaderBackgroundPainter()),
          ),

          // 2. MAIN CONTENT
          Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              14,
              18,
              14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- TOP LOGO & ACTIONS ROW ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // LOGO & TITLE
                    Row(
                      children: [
                        _buildGlobeBox(),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "START UP INDIA",
                              style: TextStyle(
                                fontSize: 7.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withValues(alpha: 0.6),
                                letterSpacing: 1.5,
                                height: 1,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                  height: 1.1,
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                                children: [
                                  const TextSpan(text: "IMPORT "),
                                  TextSpan(
                                    text: "EXPORT",
                                    style: TextStyle(color: Color(0xFFFFD000)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "ACADEMY",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.2,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // 45 YEARS TAG
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC8151B),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFC8151B,
                                    ).withValues(alpha: 0.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Text(
                                "45 YEARS OF EXPERIENCE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 6.sp,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),

                    // ACTION BUTTONS
                    const HeaderActionButtons(),
                  ],
                ),

                SizedBox(height: 1.h),

                // --- WELCOME & SHIP ROW ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          final name = (auth.user?.name ?? "Explorer")
                              .split(' ')
                              .first
                              .toUpperCase();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome back,",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.65),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),

                              SizedBox(
                                width: 50.w,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1.2,
                                      height: 1,
                                      shadows: [
                                        Shadow(
                                          color: const Color(
                                            0xFF1E5FFF,
                                          ).withValues(alpha: 0.8),
                                          blurRadius: 25,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    // 🚢 SHIP ILLUSTRATION (Custom Painter)
                    SizedBox(
                      width: 30.w,
                      height: 9.h,
                      child: CustomPaint(painter: ShipIllustrationPainter()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobeBox() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5FFF).withValues(alpha: 0.3),
            blurRadius: 24,
          ),
        ],
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(48, 48),
          painter: GlobeIconPainter(),
        ),
      ),
    );
  }
}

class HeaderActionButtons extends StatelessWidget {
  const HeaderActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Consumer<NotificationsProvider>(
          builder: (context, notif, _) => Stack(
            clipBehavior: Clip.none,
            children: [
              _buildActionBtn(Icons.notifications_none_rounded, () {
                AppNavigator.push(context, const NotificationsScreen());
              }),
              if (notif.unreadCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF2D35),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF020C28),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${notif.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildActionBtn(Icons.person_outline_rounded, () {
          AppNavigator.push(context, const ProfileScreen());
        }),
      ],
    );
  }

  Widget _buildActionBtn(IconData icon, [VoidCallback? onTap]) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class HeaderBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5599FF).withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    // North America
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.2, size.height * 0.35),
        width: 76,
        height: 56,
      ),
      paint,
    );
    // South America
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.27, size.height * 0.7),
        width: 36,
        height: 60,
      ),
      paint,
    );
    // Asia
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.7, size.height * 0.33),
        width: 100,
        height: 56,
      ),
      paint,
    );

    // Route lines
    final linePaint = Paint()
      ..color = const Color(0xFF1E5FFF).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.2,
        size.width * 0.7,
        size.height * 0.33,
      );
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()
      ..color = const Color(0xFFFFD000).withValues(alpha: 0.6);
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.33),
      3,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class GlobeIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final basePaint = Paint()
      ..color = const Color(0xFF1040C1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, basePaint);

    final linePaint = Paint()
      ..color = const Color(0xFF5599FF).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawOval(
      Rect.fromCenter(center: center, width: radius * 1.2, height: radius * 2),
      linePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: center, width: radius * 2, height: radius * 0.8),
      linePaint,
    );

    final landPaint = Paint()
      ..color = const Color(0xFF3A8C3A).withValues(alpha: 0.6);
    canvas.drawOval(
      Rect.fromLTWH(center.dx - 12, center.dy - 10, 12, 8),
      landPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ShipIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.width / 2;

    // --- Hull (Blocky white layers) ---
    final hullPaint = Paint()..color = Colors.white;
    canvas.drawRect(
      Rect.fromLTRB(10, 58, size.width - 10, 68),
      hullPaint,
    ); // Base
    canvas.drawRect(
      Rect.fromLTRB(25, 48, size.width - 25, 58),
      hullPaint,
    ); // Mid

    // --- Cargo (Colored Blocks) ---
    final blueCargo = Paint()..color = const Color(0xFF1E5FFF);
    final yellowCargo = Paint()..color = const Color(0xFFFFD000);
    final redCargo = Paint()..color = const Color(0xFFC8151B);

    canvas.drawRect(Rect.fromLTRB(30, 40, 45, 48), blueCargo);
    canvas.drawRect(Rect.fromLTRB(45, 40, 60, 48), yellowCargo);
    canvas.drawRect(Rect.fromLTRB(60, 40, 75, 48), redCargo);

    // --- Tower (Gray) ---
    final towerPaint = Paint()..color = const Color(0xFF424242);
    canvas.drawRect(Rect.fromLTRB(center - 6, 22, center + 6, 40), towerPaint);

    // --- Plane (Standing on Tower) ---
    final planePaint = Paint()..color = const Color(0xFF5599FF);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center, 12), width: 38, height: 10),
      planePaint,
    );
    // Vertical tail
    canvas.drawRect(Rect.fromLTRB(center - 12, 4, center - 8, 12), planePaint);

    // --- Flag ---
    final flagPaint = Paint()..color = const Color(0xFFFF2D35);
    final flagPath = Path()
      ..moveTo(center + 2, 18)
      ..lineTo(center + 10, 22)
      ..lineTo(center + 2, 26)
      ..close();
    canvas.drawPath(flagPath, flagPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
