import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';

class PromoBannerDialog extends StatelessWidget {
  final String imageUrl;
  final String? link;

  const PromoBannerDialog({super.key, required this.imageUrl, this.link});

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                  Navigator.pop(context); // close dialog
                  if (link != null && link!.isNotEmpty) {
                    final uri = Uri.parse(link!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.black12,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white70,
                          ),
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

              // 🟢 WHATSAPP BUTTON (SHOWN IMMEDIATELY)
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: ElevatedButton.icon(
                    onPressed: () => WhatsAppUtils.launch(
                      message:
                          "Hi, I saw your special offer and want to connect!",
                    ),
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Connect on WhatsApp →",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF25D366,
                      ), // WhatsApp Green
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 1.5.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: const Color(
                        0xFF25D366,
                      ).withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ❌ CLOSE BUTTON (SHOWN IMMEDIATELY)
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
                  child: const Icon(Icons.close, size: 22, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
