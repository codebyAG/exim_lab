import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:exim_lab/features/news/data/models/news_model.dart';
import 'package:exim_lab/features/news/data/services/news_service.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

/// News details — always opened with a [newsId] (from the list or a
/// notification tap) and fetched fresh from GET /api/news/:id.
class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  NewsModel? _news;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchById();
  }

  Future<void> _fetchById() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final fetched = await NewsService().fetchNewsById(widget.newsId);

    if (!mounted) return;
    setState(() {
      _loading = false;
      if (fetched != null) {
        _news = fetched;
      } else {
        _error = "Couldn't load this news. Please try again.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // ── LOADING (opened via notification, fetching by id) ──
    if (_loading) {
      return Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(child: CircularProgressIndicator(color: cs.primary)),
      );
    }

    // ── ERROR ──
    if (_news == null) {
      return Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.newspaper_outlined,
                  size: 56,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                SizedBox(height: 2.h),
                Text(
                  _error ?? "News not found",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.5.h),
                FilledButton.icon(
                  onPressed: _fetchById,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text("Retry"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ── CONTENT ──
    final news = _news!;
    final dateStr =
        "${news.createdAt.day}/${news.createdAt.month}/${news.createdAt.year}";

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        top: false, // SliverAppBar image stays edge-to-edge at the top
        child: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 35.h,
            pinned: true,
            backgroundColor: cs.surface,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.surface.withValues(alpha: 0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: news.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: cs.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 64,
                          color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: cs.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 64,
                          color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                  // Gradient overlay for better text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          cs.surface.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: cs.onPrimaryContainer,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          dateStr,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Title
                  Text(
                    news.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.5,
                    ),
                  ),

                  SizedBox(height: 2.5.h),

                  // Divider
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cs.outlineVariant.withValues(alpha: 0.0),
                          cs.outlineVariant.withValues(alpha: 0.5),
                          cs.outlineVariant.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 2.5.h),

                  // Content
                  Text(
                    news.content,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.7,
                      fontSize: 14.sp,
                      color: cs.onSurface.withValues(alpha: 0.87),
                      letterSpacing: 0.1,
                    ),
                  ),

                  // Read source (optional external link)
                  if (news.linkUrl.trim().isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final uri = Uri.tryParse(news.linkUrl.trim());
                          if (uri != null && await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: const Text("Read source"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: cs.primary,
                          side: BorderSide(
                            color: cs.primary.withValues(alpha: 0.4),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
