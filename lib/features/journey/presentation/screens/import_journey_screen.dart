import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../data/models/journey_model.dart';
import '../../data/dummy_journey_data.dart';
import '../widgets/journey_widgets.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_unlock_dialog.dart';

class ImportJourneyScreen extends StatefulWidget {
  const ImportJourneyScreen({super.key});

  @override
  State<ImportJourneyScreen> createState() => _ImportJourneyScreenState();
}

class _ImportJourneyScreenState extends State<ImportJourneyScreen> {
  late List<JourneyStep> _steps;

  @override
  void initState() {
    super.initState();
    _steps = DummyJourneyData.getImportSteps();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPremium = context.watch<AuthProvider>().user?.isPremium ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Start Your Import Journey'),
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
            title: 'Import Journey',
            subtitle: '11 Steps to master importing',
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
                isPremiumLocked: step.isPremium && !isPremium,
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
    final bool isPremium = context.read<AuthProvider>().user?.isPremium ?? false;

    // Gate premium steps (Step 5 onwards / Index 4+)
    if (step.isPremium && !isPremium) {
      showDialog(
        context: context,
        builder: (context) => const PremiumUnlockDialog(),
      );
      return;
    }

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
    final bool isPremium = context.read<AuthProvider>().user?.isPremium ?? false;

    setState(() {
      // Complete current step
      _steps[currentIndex] = _steps[currentIndex].copyWith(status: JourneyStepStatus.completed);
      
      // Unlock next step if it's NOT premium locked for this user
      if (currentIndex + 1 < _steps.length) {
        final nextStep = _steps[currentIndex + 1];
        if (!nextStep.isPremium || isPremium) {
          _steps[currentIndex + 1] = nextStep.copyWith(status: JourneyStepStatus.active);
        } else {
          // It remains locked, but user will get the premium prompt on click
          _steps[currentIndex + 1] = nextStep.copyWith(status: JourneyStepStatus.locked);
        }
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
