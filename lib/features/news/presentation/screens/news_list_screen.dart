import 'package:exim_lab/features/news/presentation/screens/news_details_screen.dart';
import 'package:flutter/material.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Trade Updates',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _newsList.length,
        itemBuilder: (context, index) {
          final news = _newsList[index];
          return _NewsCard(news: news);
        },
      ),
    );
  }
}

// 🔹 NEWS CARD
class _NewsCard extends StatelessWidget {
  final NewsModel news;

  const _NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewsDetailScreen(news: news)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Image.asset(
                news.image,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🗓 DATE
                  Text(
                    news.date,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // 📰 TITLE
                  Text(
                    news.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // 📄 SHORT DESCRIPTION
                  Text(
                    news.shortDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.75),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 👉 READ MORE
                  Text(
                    'Read more →',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
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

// 🔹 MODEL
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

// 🔹 DUMMY DATA
final List<NewsModel> _newsList = [
  NewsModel(
    title: 'Government revises Export Policy for MSMEs',
    shortDescription:
        'New incentives announced for MSME exporters to boost global trade.',
    fullDescription:
        'The Government of India has revised the export policy for MSMEs. '
        'Under the new framework, exporters will receive enhanced incentives, '
        'simplified documentation, and faster clearance procedures. '
        'This move aims to increase India’s global export share and support small businesses.',
    image: 'assets/news_1.jpg',
    date: '12 Jan 2026',
  ),
  NewsModel(
    title: 'HS Code updates effective from April 2026',
    shortDescription:
        'Major changes introduced in HS Code classification system.',
    fullDescription:
        'The Directorate General of Foreign Trade (DGFT) has notified changes '
        'to HS Codes effective from April 2026. Traders are advised to review '
        'the updated classification to avoid compliance issues and penalties.',
    image: 'assets/news_2.jpg',
    date: '08 Jan 2026',
  ),
];
