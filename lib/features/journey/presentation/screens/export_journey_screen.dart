import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';
import '../../data/models/journey_model.dart';
import '../../data/dummy_journey_data.dart';
import '../widgets/journey_widgets.dart';

class ExportJourneyScreen extends StatefulWidget {
  const ExportJourneyScreen({super.key});

  @override
  State<ExportJourneyScreen> createState() => _ExportJourneyScreenState();
}

class _ExportJourneyScreenState extends State<ExportJourneyScreen> {
  late List<JourneyStep> _steps;

  @override
  void initState() {
    super.initState();
    _steps = DummyJourneyData.getExportSteps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Start Your Export Journey'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/ashok_sir_image.png'),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(5.w),
        physics: const BouncingScrollPhysics(),
        children: [
          const JourneyHeader(
            title: 'Export Journey',
            subtitle: '11 Steps to master exporting',
          ),
          SizedBox(height: 3.h),
          ..._steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return FadeInUp(
              duration: const Duration(milliseconds: 500),
              delay: Duration(milliseconds: 100 * index),
              child: JourneyStepCard(
                step: step,
                isLast: index == _steps.length - 1,
                onTap: () => _onStepTap(step, index),
              ),
            );
          }),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  void _onStepTap(JourneyStep step, int index) {
    if (step.status == JourneyStepStatus.locked) return;

    if (step.questions != null && step.questions!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => JourneyQuestionDialog(
          title: step.title,
          questions: step.questions!,
          onComplete: (answers) {
            Navigator.pop(context);
            _advanceStep(index);
          },
        ),
      );
    } else {
      _advanceStep(index);
    }
  }

  void _advanceStep(int currentIndex) {
    setState(() {
      // Complete current step
      _steps[currentIndex] = _steps[currentIndex].copyWith(status: JourneyStepStatus.completed);
      
      // Unlock next step if exists
      if (currentIndex + 1 < _steps.length) {
        _steps[currentIndex + 1] = _steps[currentIndex + 1].copyWith(status: JourneyStepStatus.active);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Step ${currentIndex + 1} completed!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
