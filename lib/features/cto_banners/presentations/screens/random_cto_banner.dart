// features/cto_banner/presentation/widgets/random_cto_banner.dart
import 'dart:math';
import 'package:exim_lab/features/cto_banners/data/datasources/banner_remote_data_sources.dart';
import 'package:exim_lab/features/cto_banners/presentations/widgets/cto_banner_card.dart';
import 'package:flutter/material.dart';

class RandomCtoBanner extends StatefulWidget {
  const RandomCtoBanner({super.key});

  @override
  State<RandomCtoBanner> createState() => _RandomCtoBannerState();
}

class _RandomCtoBannerState extends State<RandomCtoBanner> {
  static final Set<String> _shownBannerIds = {};
  final _remote = CtoBannerRemote();
  bool _loading = true;
  late dynamic _banner;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await _remote.fetchBanners();
    if (list.isNotEmpty) {
      // Filter out already shown banners
      var candidates = list
          .where((b) => !_shownBannerIds.contains(b.id))
          .toList();

      // If all shown, reset and reuse all
      if (candidates.isEmpty) {
        _shownBannerIds.clear();
        candidates = list;
      }

      final randomBanner = candidates[Random().nextInt(candidates.length)];
      _shownBannerIds.add(randomBanner.id);

      if (mounted) {
        setState(() {
          _banner = randomBanner;
          _loading = false;
        });
      }
    } else {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _banner == null) return const SizedBox.shrink();

    return CtoBannerCard(
      title: _banner.title,
      description: _banner.description,
      ctaText: _banner.ctaText,
      imageUrl: _banner.imageUrl,
      ctaUrl: _banner.ctaUrl,
    );
  }
}
