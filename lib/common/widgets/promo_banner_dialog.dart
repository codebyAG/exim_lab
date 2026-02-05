import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PromoBannerDialog extends StatelessWidget {
  final String imageUrl;
  final String? link;

  const PromoBannerDialog({super.key, required this.imageUrl, this.link});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🔹 CLICKABLE BANNER
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
                fit: BoxFit.contain, // Contain ensures aspect ratio is kept
                width: double.infinity,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),

          // ❌ CLOSE BUTTON
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
