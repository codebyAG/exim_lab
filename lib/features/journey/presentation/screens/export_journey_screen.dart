import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../data/models/journey_model.dart';
import '../widgets/journey_widgets.dart';

class ExportJourneyScreen extends StatefulWidget {
  const ExportJourneyScreen({super.key});

  @override
  State<ExportJourneyScreen> createState() => _ExportJourneyScreenState();
}

class _ExportJourneyScreenState extends State<ExportJourneyScreen> {
  final List<JourneyStep> _steps = [
    const JourneyStep(
      id: 1,
      title: 'Market Analysis',
      description: 'Identify high-demand countries for your product. Analyze export statistics.',
      icon: Icons.public_rounded,
      status: JourneyStepStatus.active,
    ),
    const JourneyStep(
      id: 2,
      title: 'Product Selection',
      description: 'Select products with high export potential and incentives.',
      icon: Icons.checklist_rtl_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 3,
      title: 'Business Registration',
      description: 'Register your firm (Proprietorship/LLP/Pvt Ltd). Open a current account.',
      icon: Icons.business_center_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 4,
      title: 'IEC Registration',
      description: 'Obtain Import Export Code from DGFT.',
      icon: Icons.assignment_turned_in_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 5,
      title: 'Find Buyers',
      description: 'Engage in B2B portals, trade fairs, and embassies to find global buyers.',
      icon: Icons.language_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 6,
      title: 'Pricing & Quotation',
      description: 'Prepare Performa Invoice with FOB/CIF pricing.',
      icon: Icons.request_quote_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 7,
      title: 'Export Documentation',
      description: 'Prepare Commercial Invoice, Packing List, and Shipping Bill.',
      icon: Icons.description_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 8,
      title: 'Quality Inspection',
      description: 'Ensure products meet international standards. Get pre-shipment inspection.',
      icon: Icons.rule_folder_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 9,
      title: 'Shipping & Freight',
      description: 'Book containers. Choose Air or Sea freight.',
      icon: Icons.directions_boat_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 10,
      title: 'Duty Drawbacks',
      description: 'Claim export incentives like RoDTEP/DBK from the government.',
      icon: Icons.monetization_on_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 11,
      title: 'Payment Receipt',
      description: 'Secure payments via LC (Letter of Credit) or Advance TT.',
      icon: Icons.payments_rounded,
      status: JourneyStepStatus.locked,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Start Your Export Journey'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
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
        children: [
          const JourneyHeader(
            title: 'How to Become an Exporter',
            subtitle: 'Step-by-Step Guide for Exporters',
          ),
          SizedBox(height: 3.h),
          ..._steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return JourneyStepCard(
              step: step,
              isLast: index == _steps.length - 1,
              onTap: () => _onStepTap(step),
            );
          }),
        ],
      ),
    );
  }

  void _onStepTap(JourneyStep step) {
    if (step.status == JourneyStepStatus.locked) return;

    if (step.id == 1) {
      showDialog(
        context: context,
        builder: (context) => CategorySelectionDialog(
          title: 'Which product category are you interested in exporting?',
          onContinue: (category) {
            Navigator.pop(context);
            debugPrint('Selected for Export: $category');
            // Advance to next step (Simulation)
            _advanceStep();
          },
        ),
      );
    }
  }

  void _advanceStep() {
    setState(() {
      _steps[0] = _steps[0].copyWith(status: JourneyStepStatus.completed);
      _steps[1] = _steps[1].copyWith(status: JourneyStepStatus.active);
    });
  }
}
