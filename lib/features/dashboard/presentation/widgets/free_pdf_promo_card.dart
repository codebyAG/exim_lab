import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/core/functions/pdf_utils.dart';
import 'package:exim_lab/features/dashboard/presentation/painters/dashboard_icons_painter.dart';

class FreePdfPromoCard extends StatelessWidget {
  const FreePdfPromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF030E30), // Deep Premium Navy
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // 🌊 DECORATIVE ELEMENTS
              Positioned(
                right: -10.w,
                bottom: -5.h,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(Icons.menu_book_rounded, size: 200, color: cs.primary),
                ),
              ),

              // 📦 CONTENT
              InkWell(
                onTap: () => _showPdfSelectionDialog(context),
                child: Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Row(
                    children: [
                      // 🎨 ARTISTIC ICON
                      Container(
                        width: 50.sp,
                        height: 50.sp,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 35.sp,
                            height: 35.sp,
                            child: CustomPaint(painter: GuideBookPainter()),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),

                      // 📝 TEXT INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Free Import Export Guide",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: Colors.white,
                                letterSpacing: -0.5,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Complete beginner guide to start your global business journey",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 13,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 1.5.h),

                            // 🔘 GLASS CTA BUTTON
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.file_download_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 2.w),
                                  Flexible(
                                    child: Text(
                                      "Download Guide >",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPdfSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF030E30),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            bool isLoading = false;
            String? loadingFile;

            Future<void> handleOpen(String path, String name) async {
              setModalState(() {
                isLoading = true;
                loadingFile = name;
              });

              try {
                await PdfUtils.openAssetPdf(path);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("✅ $name opened successfully!"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("❌ Error: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } finally {
                if (context.mounted) {
                  setModalState(() => isLoading = false);
                }
              }
            }

            return Container(
              padding: EdgeInsets.fromLTRB(6.w, 3.h, 6.w, 5.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏁 HANDLE
                  Center(
                    child: Container(
                      width: 12.w,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  const Text(
                    "Select Your Guide",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Download or open our expert demo guides",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // 📘 VOL 1
                  _buildPdfOption(
                    title: "Import Export Guide Vol 1",
                    subtitle: "Basics of global trade & setup",
                    icon: Icons.auto_stories_rounded,
                    color: const Color(0xFF1E5FFF),
                    isDownloading: isLoading && loadingFile == "Vol 1",
                    onTap: isLoading
                        ? null
                        : () => handleOpen('assets/pdf/Import_Export_Guide.pdf', "Vol 1"),
                  ),
                  SizedBox(height: 2.h),

                  // 📗 VOL 2
                  _buildPdfOption(
                    title: "Import Export Guide Vol 2",
                    subtitle: "Advanced logistics & buyer sourcing",
                    icon: Icons.menu_book_rounded,
                    color: const Color(0xFFFF8800),
                    isDownloading: isLoading && loadingFile == "Vol 2",
                    onTap: isLoading
                        ? null
                        : () => handleOpen('assets/pdf/Import_Export_Guide2.pdf', "Vol 2"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPdfOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDownloading,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDownloading ? color : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isDownloading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withValues(alpha: 0.3),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
