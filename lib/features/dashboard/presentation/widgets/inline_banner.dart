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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          image: _banner!.imageUrl.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(_banner!.imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
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
              height: 4.5.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: cs.primary,
                  elevation: 0,
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
                  _banner!.ctaText.isEmpty ? 'Learn More' : _banner!.ctaText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
