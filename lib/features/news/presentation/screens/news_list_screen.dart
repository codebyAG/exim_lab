import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/features/news/presentation/providers/news_provider.dart';
import 'package:exim_lab/features/news/presentation/screens/news_details_screen.dart';
import 'package:exim_lab/features/news/data/models/news_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:exim_lab/localization/app_localization.dart';

import 'package:exim_lab/core/services/analytics_service.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        title: Text(
          t.translate('news'),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          // LOADING STATE
          if (newsProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: cs.primary, strokeWidth: 3),
                  SizedBox(height: 2.h),
                  Text(
                    t.translate('loading'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          // ERROR STATE
          if (newsProvider.error != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.errorContainer,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: cs.onErrorContainer,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      t.translate('error'),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      newsProvider.error!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    FilledButton.icon(
                      onPressed: () => newsProvider.fetchNews(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(t.translate('retry')),
                    ),
                  ],
                ),
              ),
            );
          }

          // EMPTY STATE
          if (newsProvider.newsList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.primaryContainer,
                    ),
                    child: Icon(
                      Icons.newspaper_outlined,
                      size: 56,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    t.translate('no_news'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    t.translate('no_news_hint'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          // NEWS LIST
          return RefreshIndicator(
            color: cs.primary,
            onRefresh: () => newsProvider.fetchNews(),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              itemCount: newsProvider.newsList.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final news = newsProvider.newsList[index];
                return FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: Duration(milliseconds: (index < 6 ? index : 5) * 70),
                  child: _NewsCard(news: news),
                );
              },
            ),
          );
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
    final t = AppLocalizations.of(context);
    final dateStr =
        "${news.createdAt.day}/${news.createdAt.month}/${news.createdAt.year}";

    return GestureDetector(
      onTap: () {
        context.read<AnalyticsService>().logNewsView(
          newsId: news.id,
          title: news.title,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewsDetailScreen(news: news)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack with Gradient Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(19),
                  ),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: news.imageUrl,
                        height: 20.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 20.h,
                          color: cs.surfaceContainerHighest,
                          child: Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 20.h,
                          color: cs.surfaceContainerHighest,
                          child: Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                      // Subtle gradient overlay for better text readability
                      Container(
                        height: 20.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Date Badge
                Positioned(
                  top: 1.2.h,
                  right: 1.2.h,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: cs.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateStr,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
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
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      fontSize: 16.sp,
                      letterSpacing: -0.2,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Description
                  Text(
                    news.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 12.5.sp,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 1.8.h),

                  // Read More Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          t.translate('read_more'),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.onPrimaryContainer,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(width: 0.5.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: cs.onPrimaryContainer,
                        ),
                      ],
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
