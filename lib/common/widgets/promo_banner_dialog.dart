import 'package:flutter/material.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';

class PromoBannerDialog extends StatelessWidget {
  const PromoBannerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        children: [
          // 🔹 CLICKABLE BANNER
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // close dialog
              AppNavigator.push(context, const CoursesListScreen());
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/discount_banner.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          // ❌ CLOSE BUTTON
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
