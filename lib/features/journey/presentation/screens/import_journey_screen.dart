import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../data/models/journey_model.dart';
import '../widgets/journey_widgets.dart';

class ImportJourneyScreen extends StatefulWidget {
  const ImportJourneyScreen({super.key});

  @override
  State<ImportJourneyScreen> createState() => _ImportJourneyScreenState();
}

class _ImportJourneyScreenState extends State<ImportJourneyScreen> {
  final List<JourneyStep> _steps = [
    const JourneyStep(
      id: 1,
      title: 'Decide Product',
      description: 'Choose product with demand & margin. Avoid restricted/prohibited items.',
      icon: Icons.inventory_2_rounded,
      status: JourneyStepStatus.active,
    ),
    const JourneyStep(
      id: 2,
      title: 'Market Research',
      description: 'Check demand (India market). Analyze competition & pricing.',
      icon: Icons.bar_chart_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 3,
      title: 'Find Supplier',
      description: 'Platforms: Alibaba, IndiaMART, trade fairs. Verify supplier (reviews, samples).',
      icon: Icons.person_search_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 4,
      title: 'Get Import Export Code (IEC)',
      description: 'Apply via DGFT (mandatory for import/export in India).',
      icon: Icons.assignment_ind_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 5,
      title: 'Check Regulations',
      description: 'HS Code, Import duty, GST, restrictions.',
      icon: Icons.gavel_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 6,
      title: 'Place Order',
      description: 'Issue Purchase Order (PO). Make payment.',
      icon: Icons.shopping_cart_checkout_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 7,
      title: 'Negotiate Deal',
      description: 'Finalize: Price (FOB/CIF), MOQ (minimum order), Payment terms (Advance / LC).',
      icon: Icons.handshake_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 8,
      title: 'Shipping & Logistics',
      description: 'Choose shipping: Air (fast, costly), Sea (cheap, slow). Hire freight forwarder.',
      icon: Icons.local_shipping_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 9,
      title: 'Customs Clearance',
      description: 'Invoice, Packing list, Bill of lading.',
      icon: Icons.description_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 10,
      title: 'Receive Goods',
      description: 'Delivery to warehouse. Check quality & quantity.',
      icon: Icons.receipt_long_rounded,
      status: JourneyStepStatus.locked,
    ),
    const JourneyStep(
      id: 11,
      title: 'Sell in Market',
      description: 'Online / offline / wholesale. Price for profit.',
      icon: Icons.storefront_rounded,
      status: JourneyStepStatus.locked,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Start Your Import Journey'),
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
            title: 'How to Become an Importer',
            subtitle: 'Step-by-Step Guide for Importers',
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

    // TODO: Implement actual logic or navigation
    debugPrint('Tapped Step: ${step.title}');
  }
}
