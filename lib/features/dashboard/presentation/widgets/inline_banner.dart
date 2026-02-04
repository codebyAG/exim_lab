import 'dart:math';
import 'package:exim_lab/features/cto_banners/presentations/widgets/cto_banner_card.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:flutter/material.dart';

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
      // Pick random logic or just pick one?
      // User script used logic to not repeat. For now simple random.
      _banner = widget.banners[Random().nextInt(widget.banners.length)];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_banner == null) return const SizedBox.shrink();

    return CtoBannerCard(
      title: _banner!.title,
      description: _banner!.description,
      ctaText: _banner!.ctaText,
      imageUrl: _banner!.imageUrl,
      ctaUrl: _banner!.ctaUrl,
    );
  }
}
