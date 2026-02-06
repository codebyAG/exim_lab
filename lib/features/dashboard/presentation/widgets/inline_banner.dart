import 'dart:math';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class InlineBanner extends StatefulWidget {
  final List<BannerModel> banners;
  const InlineBanner({super.key, required this.banners});

  @override
  State<InlineBanner> createState() => _InlineBannerState();
}

class _InlineBannerState extends State<InlineBanner> {
  BannerModel? _banner;

  @override
  void initState() {
    super.initState();
    if (widget.banners.isNotEmpty) {
      _banner = widget.banners[Random().nextInt(widget.banners.length)];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_banner == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Sanitize URL
    String imgUrl = _banner!.imageUrl.trim();
    if (imgUrl.isNotEmpty &&
        (imgUrl.startsWith("'") || imgUrl.startsWith('"'))) {
      imgUrl = imgUrl.substring(1, imgUrl.length - 1);
    }

    return Container(
      width: 100.w,
      margin: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          if (imgUrl.isNotEmpty)
            Positioned.fill(
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: cs.surfaceContainerHighest);
                },
              ),
            ),

          // 2. DARK OVERLAY
          if (imgUrl.isNotEmpty)
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.4)),
            ),

          // 3. CONTENT
          Padding(
            padding: EdgeInsets.all(2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _banner!.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_banner!.description.isNotEmpty) ...[
                  SizedBox(height: 1.h),
                  Text(
                    _banner!.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 2.h),
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: cs.primary,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.2.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      if (_banner!.ctaUrl.isNotEmpty) {
                        final uri = Uri.parse(_banner!.ctaUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      }
                    },
                    child: Text(
                      _banner!.ctaText.isEmpty
                          ? 'Learn More'
                          : _banner!.ctaText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
