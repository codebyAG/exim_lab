import 'package:exim_lab/features/shorts/presentation/providers/shorts_provider.dart';
import 'package:exim_lab/features/shorts/presentation/widgets/shorts_player_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/core/services/analytics_service.dart';

class ShortsFeedScreen extends StatefulWidget {
  final int initialIndex;
  const ShortsFeedScreen({super.key, this.initialIndex = 0});

  @override
  State<ShortsFeedScreen> createState() => _ShortsFeedScreenState();
}

class _ShortsFeedScreenState extends State<ShortsFeedScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _hasLoggedInitial = false;

  void _logShortView(ShortsProvider provider, int index) {
    if (index >= 0 && index < provider.shorts.length) {
      final short = provider.shorts[index];
      context.read<AnalyticsService>().logShortsView(
        shortId: short.id,
        title: short.title,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: Text(
          AppLocalizations.of(context).translate('shorts'),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<ShortsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (provider.shorts.isEmpty) {
            return const Center(
              child: Text(
                'No shorts available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // Log initial view once data is available
          if (!_hasLoggedInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _logShortView(provider, widget.initialIndex);
                _hasLoggedInitial = true;
              }
            });
          }

          return GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! < -800) {
                // Swipe Up -> Next
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
              } else if (details.primaryVelocity! > 800) {
                // Swipe Down -> Previous
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: provider.shorts.length,
              physics:
                  const ClampingScrollPhysics(), // Better for "snapping" feel
              onPageChanged: (index) {
                provider.setCurrentIndex(index);
                _logShortView(provider, index);
              },
              itemBuilder: (context, index) {
                return ShortsPlayerItem(
                  short: provider.shorts[index],
                  isVisible: true,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
