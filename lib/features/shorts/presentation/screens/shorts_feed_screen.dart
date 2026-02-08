import 'package:exim_lab/features/shorts/presentation/providers/shorts_provider.dart';
import 'package:exim_lab/features/shorts/presentation/widgets/shorts_player_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: const Text('Shorts', style: TextStyle(color: Colors.white)),
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

          return PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: provider.shorts.length,
            onPageChanged: (index) {
              provider.setCurrentIndex(index);
            },
            itemBuilder: (context, index) {
              // Only load/play if it's the current page or very close?
              // Actually PageView keeps state.
              // We pass 'isVisible' based on index matching provider.currentIndex
              // But PageView does lazy building.
              // Let's rely on VisibilityDetector inside the Item,
              // BUT PageView pre-renders adjacent pages.
              return ShortsPlayerItem(
                short: provider.shorts[index],
                isVisible: true, // VisibilityDetector handles actual playing
              );
            },
          );
        },
      ),
    );
  }
}
