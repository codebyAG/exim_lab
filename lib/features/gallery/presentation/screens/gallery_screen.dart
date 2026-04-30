import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:exim_lab/core/constants/gallery_constants.dart';
import 'package:exim_lab/features/gallery/data/models/gallery_item.dart';
import 'package:exim_lab/features/gallery/presentation/screens/photo_view_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const List<String> _galleryUrls = GalleryConstants.galleryUrls;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context);

    final items = _galleryUrls
        .asMap()
        .entries
        .map((e) => GalleryItem(id: e.key.toString(), imageUrl: e.value))
        .toList();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(
          t.translate('gallery_title'),
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16.sp,
            color: cs.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: cs.onSurface),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(4.w),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 4.w,
          childAspectRatio: 1.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return FadeInUp(
            delay: Duration(milliseconds: 50 * (index % 10)),
            duration: const Duration(milliseconds: 500),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PhotoViewScreen(items: items, initialIndex: index),
                  ),
                );
              },
              child: Hero(
                tag: 'gallery_${item.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: cs.surfaceContainerHighest,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.primary.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: cs.errorContainer,
                        child: Icon(Icons.error, color: cs.error),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
