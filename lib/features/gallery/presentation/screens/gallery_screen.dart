import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:exim_lab/features/gallery/data/models/gallery_item.dart';
import 'package:exim_lab/features/gallery/presentation/screens/photo_view_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const List<String> _galleryUrls = [
    'https://www.siiea.in/wp-content/uploads/2023/08/20131126_063230.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/20131107_133738.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/01-duty-free.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/Photo-1-scaled.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/me-and-scrap-IMAGE_0892.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMGA0570.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMGA0487.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMGA0322.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMGA0247.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMGA0234.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMGA0208.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMGA0212.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMGA0144.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_4459.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_4439.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_4431.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_4367.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_4298.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_4324.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_1395.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_1437.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_1543.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_1545.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_1548.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_1353.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_1331.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_1284.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_1277.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_1233.jpg',
    'https://www.siiea.in/wp-content/uploads/2023/08/IMG_0037.jpg',
  ];

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
                    builder: (_) => PhotoViewScreen(
                      items: items,
                      initialIndex: index,
                    ),
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
