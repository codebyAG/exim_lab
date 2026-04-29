import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dots_iniidcator.dart';
import 'masterclass_card.dart';

class MasterclassCarousel extends StatefulWidget {
  const MasterclassCarousel({super.key});

  @override
  State<MasterclassCarousel> createState() => _MasterclassCarouselState();
}

class _MasterclassCarouselState extends State<MasterclassCarousel> {
  final PageController _controller = PageController(viewportFraction: 1.0);
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      _currentIndex = (_currentIndex + 1) % 2;
      if (_controller.hasClients) {
        _controller.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40.h, // Adjusted to fit card + padding
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: const [MasterclassCard(), HandholdingMasterclassCard()],
          ),
        ),
        DotsIndicator(count: 2, currentIndex: _currentIndex),
      ],
    );
  }
}

class HandholdingMasterclassCard extends StatelessWidget {
  const HandholdingMasterclassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: const Color(0xFF030E30), // Deep Navy
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: const Color(
              0xFFFFD000,
            ).withValues(alpha: 0.4), // Glowing Gold border
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD000).withValues(alpha: 0.1),
              blurRadius: 30,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 🟨 RIGHT GOLD STRIPE
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 6, color: const Color(0xFFFFD000)),
            ),

            // 🏮 WATERMARK
            Positioned(
              bottom: -2.h,
              right: -5.w,
              child: Opacity(
                opacity: 0.05,
                child: Icon(
                  Icons.handshake_rounded,
                  size: 25.h,
                  color: Colors.white,
                ),
              ),
            ),

            // 📝 CONTENT
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 0.6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD000),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "🤝 24/7 SUPPORT",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    "Handholding Masterclass",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  // FEATURE LIST
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFeatureRow("Personalized consultation."),
                        _buildFeatureRow("Guidance on documentation."),
                        _buildFeatureRow("Real-time shipment updates."),
                        _buildFeatureRow("Problem-solving support 24 x 7."),
                        _buildFeatureRow("Training on processes."),
                        _buildFeatureRow("Cultural or language support."),
                        _buildFeatureRow("Risk management assistance."),
                      ],
                    ),
                  ),

                  // BUTTON
                  SizedBox(height: 1.h),
                  InkWell(
                    onTap: () => WhatsAppUtils.launch(
                      message:
                          "Hi, I am interested in the Handholding Masterclass for expert guidance.",
                    ),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E5FFF), Color(0xFF153580)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF1E5FFF,
                            ).withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Get Expert Support →",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.8.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: const Color(0xFFFFD000),
            size: 12.sp,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
