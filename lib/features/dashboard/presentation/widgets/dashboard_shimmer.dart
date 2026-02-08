import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Subtle dark mode shimmer
    final baseColor = isDark ? Colors.grey[900]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER SHIMMER
          _HeaderShimmer(baseColor: baseColor, highlightColor: highlightColor),

          SizedBox(height: 2.h),

          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. CAROUSEL SHIMMER
                _CarouselShimmer(),
                SizedBox(height: 3.h),

                // 3. SHORTS SHIMMER
                _SectionTitleShimmer(),
                SizedBox(height: 1.5.h),
                _ShortsShimmer(),
                SizedBox(height: 4.h),

                // 4. QUICK ACTIONS SHIMMER
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    children: [
                      Expanded(child: _QuickCardShimmer()),
                      SizedBox(width: 3.w),
                      Expanded(child: _QuickCardShimmer()),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),

                // 5. CONTINUE LEARN / COURSES SHIMMER
                _SectionTitleShimmer(),
                SizedBox(height: 1.5.h),
                _HorizontalListShimmer(height: 260, width: 220),
                SizedBox(height: 4.h),

                // 6. TOOLS SHIMMER
                _SectionTitleShimmer(),
                SizedBox(height: 1.5.h),
                _ToolsGridShimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// INDIVIDUAL SHIMMER COMPONENTS
// -----------------------------------------------------------------------------

class _HeaderShimmer extends StatelessWidget {
  final Color baseColor;
  final Color highlightColor;

  const _HeaderShimmer({required this.baseColor, required this.highlightColor});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: 22.h,
        padding: EdgeInsets.fromLTRB(5.w, 7.h, 5.w, 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16, width: 100, color: Colors.white),
                    SizedBox(height: 8),
                    Container(height: 24, width: 180, color: Colors.white),
                    SizedBox(height: 8),
                    Container(height: 16, width: 140, color: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(radius: 24, backgroundColor: Colors.white),
                    SizedBox(width: 12),
                    CircleAvatar(radius: 24, backgroundColor: Colors.white),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CarouselShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _ShortsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        // Shorts Shimmer
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (_, __) => Container(
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _QuickCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _HorizontalListShimmer extends StatelessWidget {
  final double height;
  final double width;

  const _HorizontalListShimmer({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        // Horizontal List Shimmer
        separatorBuilder: (_, __) => SizedBox(width: 16),
        itemBuilder: (_, __) => Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class _ToolsGridShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: 4,
        // Tools Grid Shimmer
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _SectionTitleShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 20, width: 150, color: Colors.white),
          SizedBox(height: 6),
          Container(height: 14, width: 220, color: Colors.white),
        ],
      ),
    );
  }
}
