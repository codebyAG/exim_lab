import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../data/models/journey_model.dart';
import '../widgets/journey_widgets.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_unlock_dialog.dart';
import 'package:exim_lab/features/journey/presentation/providers/journey_provider.dart';

class ImportJourneyScreen extends StatefulWidget {
  const ImportJourneyScreen({super.key});

  @override
  State<ImportJourneyScreen> createState() => _ImportJourneyScreenState();
}

class _ImportJourneyScreenState extends State<ImportJourneyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JourneyProvider>().fetchJourney('import');
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isPremium = context.watch<AuthProvider>().user?.isPremium ?? false;
    final journeyProvider = context.watch<JourneyProvider>();
    final steps = journeyProvider.importSteps;

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: journeyProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : journeyProvider.error != null
              ? Center(child: Text('Error: ${journeyProvider.error}'))
              : ListView(
                  padding: EdgeInsets.all(5.w),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const JourneyHeader(
                      title: 'Import Journey',
                      subtitle: 'Master your import business step-by-step',
                    ),
                    SizedBox(height: 3.h),
                    ...steps.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;
                      return FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: Duration(milliseconds: 100 * index),
                        child: JourneyStepCard(
                          step: step,
                          isLast: index == steps.length - 1,
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

    // Gate premium steps
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
            _advanceStep(step.id);
          },
        ),
      );
    } else {
      _advanceStep(step.id);
    }
  }

  void _advanceStep(int stepId) {
    context.read<JourneyProvider>().markStepCompleted('import', stepId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Step completed and synced!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
