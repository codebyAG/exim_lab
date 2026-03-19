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
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1D1F33),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
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
        Icon(Icons.auto_awesome_motion_rounded, size: 10.w, color: Colors.orange),
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D1F33),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  step.description,
                  style: TextStyle(
                    fontSize: 10.sp,
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
