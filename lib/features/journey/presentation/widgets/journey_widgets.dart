import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../data/models/journey_model.dart';

class JourneyHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const JourneyHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.imagePath = 'assets/journey_header_bg.png', // Fallback
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary.withValues(alpha: 0.15), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildIllustration(),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1D1F33),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
        ),
        Icon(
          Icons.auto_awesome_motion_rounded,
          size: 10.w,
          color: Colors.orange,
        ),
      ],
    );
  }
}

class JourneyStepCard extends StatelessWidget {
  final JourneyStep step;
  final bool isLast;
  final VoidCallback onTap;

  const JourneyStepCard({
    super.key,
    required this.step,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bool isLocked = step.status == JourneyStepStatus.locked;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimeline(cs),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 2.5.h, left: 4.w),
              child: _buildCardContent(cs, isLocked),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(ColorScheme cs) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _getStatusColor(cs),
            shape: BoxShape.circle,
            boxShadow: [
              if (step.status == JourneyStepStatus.active)
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Center(
            child: step.status == JourneyStepStatus.completed
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : step.status == JourneyStepStatus.locked
                ? const Icon(Icons.lock_rounded, color: Colors.white, size: 16)
                : Text(
                    '${step.id}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              color: _getStatusColor(cs).withValues(alpha: 0.3),
            ),
          ),
      ],
    );
  }

  Widget _buildCardContent(ColorScheme cs, bool isLocked) {
    Widget content = Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: step.status == JourneyStepStatus.active
              ? cs.primary.withValues(alpha: 0.5)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D1F33),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  step.description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                if (step.status == JourneyStepStatus.active)
                  _buildActionButton(cs),
              ],
            ),
          ),
          _buildStepIcon(cs),
        ],
      ),
    );

    if (isLocked) {
      return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: content,
      );
    }

    return InkWell(
      onTap: step.status == JourneyStepStatus.locked ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: content,
    );
  }

  Widget _buildActionButton(ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
        label: const Text('Start'),
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIcon(ColorScheme cs) {
    return Container(
      width: 15.w,
      height: 15.w,
      decoration: BoxDecoration(
        color: _getStatusColor(cs).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(step.icon, color: _getStatusColor(cs), size: 8.w),
    );
  }

  Color _getStatusColor(ColorScheme cs) {
    switch (step.status) {
      case JourneyStepStatus.completed:
        return Colors.green;
      case JourneyStepStatus.active:
        return cs.primary;
      case JourneyStepStatus.locked:
        return Colors.grey.shade400;
    }
  }
}

class CategorySelectionDialog extends StatefulWidget {
  final String title;
  final Function(String) onContinue;

  const CategorySelectionDialog({
    super.key,
    required this.title,
    required this.onContinue,
  });

  @override
  State<CategorySelectionDialog> createState() =>
      _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog> {
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Technology & Electronics', 'icon': Icons.devices_rounded},
    {'label': 'Fashion & Accessories', 'icon': Icons.checkroom_rounded},
    {'label': 'Agriculture & Food', 'icon': Icons.agriculture_rounded},
    {'label': 'Textiles & Garments', 'icon': Icons.dry_cleaning_rounded},
    {'label': 'Chemicals & Plastics', 'icon': Icons.science_rounded},
    {'label': 'Gems & Jewelry', 'icon': Icons.diamond_rounded},
    {'label': 'Metals & Engineering', 'icon': Icons.handyman_rounded},
    {'label': 'Pharmaceutical', 'icon': Icons.medical_services_rounded},
    {'label': 'Home & Furniture', 'icon': Icons.chair_rounded},
    {'label': 'Automotive & Parts', 'icon': Icons.directions_car_rounded},
    {'label': 'Handicrafts', 'icon': Icons.brush_rounded},
    {'label': 'Other', 'icon': Icons.more_horiz_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      elevation: 20,
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: Container(
        padding: EdgeInsets.fromLTRB(5.w, 4.w, 5.w, 5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [Colors.white, cs.primary.withValues(alpha: 0.02)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        constraints: BoxConstraints(maxHeight: 85.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.2,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.5.h),
            _buildSearchField(),
            SizedBox(height: 2.5.h),
            Flexible(child: _buildCategoryGrid(cs)),
            SizedBox(height: 2.5.h),
            _buildContinueButton(cs),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(ColorScheme cs) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        mainAxisSpacing: 2.h,
        crossAxisSpacing: 4.w,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final cat = _categories[index];
        final bool isSelected = _selectedCategory == cat['label'];

        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat['label'] as String),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFEA580C) : const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                if (isSelected)
                  BoxShadow(
                    color: const Color(0xFFEA580C).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    cat['icon'] as IconData,
                    color: isSelected ? Colors.white : const Color(0xFFEA580C),
                    size: 8.w,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  cat['label'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton(ColorScheme cs) {
    return ElevatedButton(
      onPressed: _selectedCategory == null
          ? null
          : () => widget.onContinue(_selectedCategory!),
      style: ElevatedButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade300,
        padding: EdgeInsets.symmetric(vertical: 1.8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: Text(
        'Continue',
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
