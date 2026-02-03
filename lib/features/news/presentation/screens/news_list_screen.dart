import 'package:exim_lab/features/news/presentation/screens/news_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Trade Updates',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: _newsList.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final news = _newsList[index];
          return _NewsCard(news: news);
        },
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsModel news;
  const _NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewsDetailScreen(news: news)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  child: Image.asset(
                    news.image,
                    height: 22.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Date Badge
                Positioned(
                  top: 1.5.h,
                  right: 1.5.h,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surface.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      news.date,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                        fontSize: 11.sp, // Increased
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      fontSize: 17.sp, // Increased significantly
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Description
                  Text(
                    news.shortDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 13.sp, // Increased
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Read More
                  Row(
                    children: [
                      Text(
                        'Read more',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                          fontSize: 13.sp, // Increased
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: cs.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsModel {
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String image;
  final String date;

  const NewsModel({
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.image,
    required this.date,
  });
}

final List<NewsModel> _newsList = [
  NewsModel(
    title: 'Government revises Export Policy for MSMEs',
    shortDescription:
        'New incentives announced for MSME exporters to boost global trade.',
    fullDescription:
        'The Government of India has revised the export policy for MSMEs. Under the new framework, exporters will receive enhanced incentives, simplified documentation, and faster clearance procedures.',
    image: 'assets/news_1.jpg',
    date: '12 Jan',
  ),
  NewsModel(
    title: 'HS Code updates effective from April 2026',
    shortDescription:
        'Major changes introduced in HS Code classification system.',
    fullDescription:
        'The Directorate General of Foreign Trade (DGFT) has notified changes to HS Codes effective from April 2026.',
    image: 'assets/news_2.jpg',
    date: '08 Jan',
  ),
];
