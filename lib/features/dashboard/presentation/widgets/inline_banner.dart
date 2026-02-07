import 'dart:math';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:exim_lab/localization/app_localization.dart';

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
    // t variable removed as unused

    // Sanitize URL
    String imgUrl = _banner!.imageUrl.trim();
    if (imgUrl.isNotEmpty &&
        (imgUrl.startsWith("'") || imgUrl.startsWith('"'))) {
      imgUrl = imgUrl.substring(1, imgUrl.length - 1);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w),
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          width: double.infinity,
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _banner!.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  13.sp, // Increased from default/implicit
                            ),
                          ),
                          if (_banner!.description.isNotEmpty) ...[
                            SizedBox(height: 0.5.h),
                            Text(
                              _banner!.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                                fontSize: 11.sp, // Increased from 10.sp
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (_banner!.ctaText.isNotEmpty) ...[
                      SizedBox(width: 2.w),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: cs.primary,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 0.5.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                          _banner!.ctaText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp, // Increased from 10.sp
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
