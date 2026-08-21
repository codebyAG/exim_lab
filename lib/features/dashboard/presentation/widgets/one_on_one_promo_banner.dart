import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/one_on_one/presentation/screens/one_on_one_screen.dart';

const _navy = Color(0xFF030E30); // Deep Premium Navy — matches the dashboard's own cards
const _gold = Color(0xFFFFD000);
const _goldDeep = Color(0xFFCC9E00);

/// Dashboard entry point for the One-on-One Classes page — sits just above
/// the Free Videos section. Same navy + gold "premium card" language as the
/// other dashboard banners (FreePdfPromoCard, ToolCard) rather than the
/// One-on-One page's own purple theme, so it reads as one dashboard.
class OneOnOnePromoBanner extends StatelessWidget {
  const OneOnOnePromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: Container(
        decoration: BoxDecoration(
          color: _navy,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _gold.withValues(alpha: 0.22),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: () => AppNavigator.push(context, const OneOnOneScreen()),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 📝 LEFT — CONTENT
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 4.w, 4.w, 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _gold.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "1-ON-1",
                                  style: TextStyle(
                                    color: _gold,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "LIVE MENTORSHIP",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Hook — leads with the reader's problem, not a
                          // feature description, so it earns the tap.
                          const Text(
                            "Stuck Scaling Your\nExport Business?",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                              color: Colors.white,
                              letterSpacing: -0.4,
                              height: 1.2,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Talk 1-on-1 with a real Import-Export expert",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12.5,
                              height: 1.3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 1.5.h),

                          // 🔘 GOLD CTA BUTTON
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [_gold, _goldDeep],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.handshake_rounded,
                                  color: _navy,
                                  size: 18,
                                ),
                                SizedBox(width: 2.w),
                                const Flexible(
                                  child: Text(
                                    "Talk to a Mentor >",
                                    style: TextStyle(
                                      color: _navy,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🎨 RIGHT — GOLD GRAPHIC PANEL
                  Container(
                    width: 26.w,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_gold, Color(0xFFB8860B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: -14,
                          right: -14,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -18,
                          left: -18,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _navy.withValues(alpha: 0.14),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.diversity_1_rounded,
                          color: _navy,
                          size: 42,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
