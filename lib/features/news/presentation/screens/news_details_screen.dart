import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:exim_lab/features/news/data/models/news_model.dart';
import 'package:sizer/sizer.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        title: Text(
          'Trade Update',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 IMAGE
            // 🖼 IMAGE
            CachedNetworkImage(
              imageUrl: news.imageUrl,
              width: double.infinity,
              height: 30.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 30.h,
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Center(child: Icon(Icons.image)),
              ),
              errorWidget: (context, url, error) => Container(
                height: 30.h,
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Center(child: Icon(Icons.broken_image)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🗓 DATE
                  Text(
                    "${news.createdAt.day}/${news.createdAt.month}/${news.createdAt.year}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 📰 TITLE
                  Text(
                    news.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 📄 FULL DESCRIPTION
                  Text(
                    news.content,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: theme.colorScheme.onSurface.withOpacity(0.85),
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
