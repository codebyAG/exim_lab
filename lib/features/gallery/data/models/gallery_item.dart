class GalleryItem {
  final String id;
  final String imageUrl;
  final String? title;

  const GalleryItem({
    required this.id,
    required this.imageUrl,
    this.title,
  });
}
