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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Your Guide"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text("Import Export Guide Vol 1"),
              onTap: () {
                Navigator.pop(context);
                PdfUtils.openAssetPdf('assets/pdf/Import_Export_Guide.pdf');
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text("Import Export Guide Vol 2"),
              onTap: () {
                Navigator.pop(context);
                PdfUtils.openAssetPdf('assets/pdf/Import_Export_Guide2.pdf');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
