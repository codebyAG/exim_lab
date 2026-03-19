import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';
import '../../data/models/journey_model.dart';

class JourneyHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const JourneyHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
          border: Border.all(color: Colors.orange.withValues(alpha: 0.1), width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background accents
            Positioned(
              top: -40,
              right: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.orange.withValues(alpha: 0.15),
                      Colors.orange.withValues(alpha: 0),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -10,
              child: Icon(
                Icons.auto_awesome_motion_rounded,
                size: 80,
                color: Colors.orange.withValues(alpha: 0.05),
              ),
            ),
            // Main content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
              child: Row(
                children: [
                  // Icon Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF97316), Color(0xFFFB923C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      title.toLowerCase().contains('export')
                          ? Icons.flight_takeoff_rounded
                          : Icons.flight_land_rounded,
                      size: 8.w,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  // Text Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.orange,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1D1F33),
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        // Visual indicator of completeness (Status pill)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Step-by-Step Training',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.orange.shade800,
                            ),
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
    );
  }
}

class JourneyStepCard extends StatelessWidget {
  final JourneyStep step;
  final bool isLast;
  final bool isPremiumLocked;
  final VoidCallback onTap;

  const JourneyStepCard({
    super.key,
    required this.step,
    required this.isLast,
    this.isPremiumLocked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bool isActive = step.status == JourneyStepStatus.active;
    final bool isCompleted = step.status == JourneyStepStatus.completed;
    final bool isLocked = step.status == JourneyStepStatus.locked;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimeline(cs, isActive, isCompleted, isLocked),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 3.h, left: 4.w),
              child: _buildCardContent(cs, isActive, isCompleted, isLocked),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(ColorScheme cs, bool isActive, bool isCompleted, bool isLocked) {
    Widget dot = Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green : (isActive ? Colors.orange : Colors.grey.shade300),
        shape: BoxShape.circle,
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
            : isLocked
                ? const Icon(Icons.lock_rounded, color: Colors.white, size: 16)
                : Text(
                    '${step.id}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
      ),
    );

    return Column(
      children: [
        isActive ? Flash(infinite: true, duration: const Duration(seconds: 3), child: dot) : dot,
        if (!isLast)
          Expanded(
            child: CustomPaint(
              size: const Size(2, double.infinity),
              painter: DashedLinePainter(
                color: isCompleted ? Colors.green : Colors.grey.shade300,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCardContent(ColorScheme cs, bool isActive, bool isCompleted, bool isLocked) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isActive ? Colors.orange.withValues(alpha: 0.5) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Opacity(
        opacity: isLocked ? 0.6 : 1.0,
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
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1D1F33),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    step.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF6B7280),
                      height: 1.3,
                    ),
                  ),
                  if (isActive) _buildStartButton(),
                  if (isLocked || isPremiumLocked) _buildLockedBadge(),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            _buildIllustration(isActive, isCompleted),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF97316), Color(0xFFFB923C)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF97316).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
          label: Text(
            'Start',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.2.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }

  Widget _buildLockedBadge() {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
        decoration: BoxDecoration(
          color: isPremiumLocked ? Colors.orange.withValues(alpha: 0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: isPremiumLocked ? Border.all(color: Colors.orange.withValues(alpha: 0.2)) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPremiumLocked ? Icons.stars_rounded : Icons.lock_rounded,
              size: 14,
              color: isPremiumLocked ? Colors.orange : Colors.grey.shade500,
            ),
            SizedBox(width: 1.5.w),
            Text(
              isPremiumLocked ? 'PREMIUM' : 'Locked',
              style: TextStyle(
                fontSize: 10.sp,
                color: isPremiumLocked ? Colors.orange.shade800 : Colors.grey.shade500,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(bool isActive, bool isCompleted) {
    Widget illustration = Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: (isCompleted ? Colors.green : (isActive ? Colors.orange : Colors.grey)).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        step.icon,
        color: isCompleted ? Colors.green : (isActive ? Colors.orange : Colors.grey),
        size: 10.w,
      ),
    );

    return isActive 
      ? Pulse(infinite: true, duration: const Duration(seconds: 2), child: illustration) 
      : illustration;
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width / 2, startY), Offset(size.width / 2, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class JourneyQuestionDialog extends StatefulWidget {
  final String title;
  final List<JourneyQuestion> questions;
  final Function(Map<String, String>) onComplete;

  const JourneyQuestionDialog({
    super.key,
    required this.title,
    required this.questions,
    required this.onComplete,
  });

  @override
  State<JourneyQuestionDialog> createState() => _JourneyQuestionDialogState();
}

class _JourneyQuestionDialogState extends State<JourneyQuestionDialog> {
  final Map<String, String> _answers = {};
  int _currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestionIndex];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      child: Container(
        padding: EdgeInsets.all(6.w),
        constraints: BoxConstraints(maxHeight: 80.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: Colors.orange),
                ),
                Text(
                  '${_currentQuestionIndex + 1}/${widget.questions.length}',
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.questions.length,
              backgroundColor: Colors.orange.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              borderRadius: BorderRadius.circular(10),
              minHeight: 6,
            ),
            SizedBox(height: 4.h),
            
            // Question Text
            Text(
              question.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1D1F33),
                height: 1.2,
              ),
            ),
            SizedBox(height: 4.h),
            
            // Options List
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: question.options.length,
                separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  final isSelected = _answers[question.id] == option;
                  return GestureDetector(
                    onTap: () => setState(() => _answers[question.id] = option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.orange : Colors.grey.withValues(alpha: 0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : const Color(0xFF374151),
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded, color: Colors.white)
                          else
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 2),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 4.h),
            
            // Action Button
            ElevatedButton(
              onPressed: _answers[question.id] == null
                  ? null
                  : () {
                      if (_currentQuestionIndex < widget.questions.length - 1) {
                        setState(() => _currentQuestionIndex++);
                      } else {
                        widget.onComplete(_answers);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 7.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 8,
                shadowColor: Colors.orange.withValues(alpha: 0.4),
              ),
              child: Text(
                _currentQuestionIndex < widget.questions.length - 1 ? 'Next Step' : 'Confirm Choice',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
