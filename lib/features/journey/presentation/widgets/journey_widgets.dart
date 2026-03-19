import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFEF3C7),
            const Color(0xFFFDE68A).withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Blobs
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(5.w),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(Icons.public_rounded, size: 10.w, color: Colors.orange),
                ),
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
                          height: 1.1,
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
          ),
        ],
      ),
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
    return Column(
      children: [
        Container(
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
        ),
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
                  if (isLocked) _buildLockedBadge(),
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
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_rounded, size: 14, color: Colors.grey.shade500),
            SizedBox(width: 1.5.w),
            Text(
              'Locked',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(bool isActive, bool isCompleted) {
    return Container(
      width: 18.w,
      height: 18.w,
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
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 3.h),
            Text(
              question.text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 2.5.h),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.0,
                  mainAxisSpacing: 1.5.h,
                  crossAxisSpacing: 3.w,
                ),
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  final isSelected = _answers[question.id] == option;
                  return GestureDetector(
                    onTap: () => setState(() => _answers[question.id] = option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Colors.orange.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.orange : Colors.orange.withValues(alpha: 0.1),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        option,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 3.h),
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
                minimumSize: Size(double.infinity, 6.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                _currentQuestionIndex < widget.questions.length - 1 ? 'Next' : 'Continue',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
