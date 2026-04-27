import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';

class PromoBannerDialog extends StatefulWidget {
  final String imageUrl;
  final String? link;

  const PromoBannerDialog({super.key, required this.imageUrl, this.link});

  @override
  State<PromoBannerDialog> createState() => _PromoBannerDialogState();
}

class _PromoBannerDialogState extends State<PromoBannerDialog> {
  int _secondsRemaining = 15;
  Timer? _timer;
  bool _canDismiss = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canDismiss = true;
        });
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canDismiss,
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🔹 MAIN BANNER CONTENT
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (!_canDismiss) return;
                    Navigator.pop(context); // close dialog
                    if (widget.link != null && widget.link!.isNotEmpty) {
                      final uri = Uri.parse(widget.link!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 250,
                          width: double.infinity,
                          color: Colors.black12,
                          child: const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white70),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        });
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),

                // 🟢 WHATSAPP BUTTON (REVEALED AFTER 15 SECONDS)
                if (_canDismiss)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      child: ElevatedButton.icon(
                        onPressed: () => WhatsAppUtils.launch(
                          message: "Hi, I saw your special offer and want to connect!",
                        ),
                        icon: const Icon(Icons.chat_bubble_outline_rounded,
                            color: Colors.white),
                        label: Text(
                          "Connect on WhatsApp →",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 1.5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: const Color(0xFF25D366).withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // ❌ CLOSE BUTTON (ONLY SHOWS AFTER 15 SECONDS)
            if (_canDismiss)
              Positioned(
                top: 0,
                right: 0,
                child: ZoomIn(
                  duration: const Duration(milliseconds: 400),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child:
                          const Icon(Icons.close, size: 22, color: Colors.white),
                    ),
                  ),
                ),
              ),

            // ⏳ COUNTDOWN OVERLAY
            if (!_canDismiss)
              Positioned(
                bottom: 2.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Dismiss in ${_secondsRemaining}s",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
