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
    final cs = Theme.of(context).colorScheme;
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Opacity(
                opacity: 0.1,
                child: Icon(Icons.public_rounded, size: 180, color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Row(
                children: [
                  _buildPortrait(),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.4.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            'FOUNDER & GLOBAL MENTOR',
                            style: TextStyle(
                              fontSize: 7.5.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 0.6.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        _buildKnowMoreButton(cs),
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

  Widget _buildPortrait() {
    return Container(
      width: 26.w,
      height: 26.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/ashok_sir_image.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildKnowMoreButton(ColorScheme cs) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: cs.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Know More',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w900,
              color: cs.onSecondary,
            ),
          ),
          SizedBox(width: 1.5.w),
          Icon(Icons.arrow_forward_ios_rounded, color: cs.onSecondary, size: 10),
        ],
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
        color: isCompleted
            ? Colors.green
            : (isActive ? cs.primary : cs.outlineVariant),
        shape: BoxShape.circle,
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.3),
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
                color: isCompleted ? Colors.green : cs.outlineVariant,
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
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isActive ? cs.primary.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
          width: 1.5,
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
                      color: cs.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    step.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: cs.onSurface.withValues(alpha: 0.6),
                      height: 1.3,
                    ),
                  ),
                  if (isActive) _buildStartButton(cs),
                  if (isLocked || isPremiumLocked) _buildLockedBadge(cs),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            _buildIllustration(cs, isActive, isCompleted),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.3),
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

  Widget _buildLockedBadge(ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
        decoration: BoxDecoration(
          color: isPremiumLocked
              ? cs.primary.withValues(alpha: 0.1)
              : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: isPremiumLocked
              ? Border.all(color: cs.primary.withValues(alpha: 0.2))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPremiumLocked ? Icons.stars_rounded : Icons.lock_rounded,
              size: 14,
              color: isPremiumLocked ? cs.primary : cs.onSurfaceVariant,
            ),
            SizedBox(width: 1.5.w),
            Text(
              isPremiumLocked ? 'PREMIUM' : 'Locked',
              style: TextStyle(
                fontSize: 10.sp,
                color: isPremiumLocked ? cs.primary : cs.onSurfaceVariant,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(ColorScheme cs, bool isActive, bool isCompleted) {
    Widget illustration = Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: (isCompleted
                ? Colors.green
                : (isActive ? cs.primary : cs.outline))
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        step.icon,
        color: isCompleted
            ? Colors.green
            : (isActive ? cs.primary : cs.outline),
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
  final Function(Map<int, String>) onComplete;

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
  final Map<int, String> _answers = {};
  int _currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: cs.primary,
                  ),
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
              backgroundColor: cs.primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
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
                color: cs.onSurface,
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
                        color: isSelected ? cs.primary : cs.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? cs.primary : cs.outline,
                          width: 2,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.2),
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
                                color: isSelected
                                    ? cs.onPrimary
                                    : cs.onSurface,
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
                                border: Border.all(
                                  color: cs.outline,
                                  width: 2,
                                ),
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
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                minimumSize: Size(double.infinity, 7.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                shadowColor: cs.primary.withValues(alpha: 0.4),
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
