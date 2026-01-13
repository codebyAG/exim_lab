import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/tools/presentation/screens/export_price_calculator.dart';
import 'package:flutter/material.dart';
import 'tool_card.dart';

class ToolsSection extends StatelessWidget {
  const ToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          ToolCard(
            icon: Icons.calculate,
            title: 'Export Price Calculator',
            subtitle: 'Calculate selling price & profit',
            onTap: () {
              AppNavigator.push(context, const ExportPriceCalculatorScreen());
            },
          ),

          ToolCard(
            icon: Icons.search,
            title: 'HS Code Finder',
            subtitle: 'Find correct HS codes',
            onTap: () {},
          ),
          const SizedBox(width: 14),
          ToolCard(
            icon: Icons.receipt_long,
            title: 'Duty Calculator',
            subtitle: 'Estimate customs duty',
            onTap: () {},
          ),
          const SizedBox(width: 14),
          ToolCard(
            icon: Icons.description,
            title: 'Document Checklist',
            subtitle: 'Required export docs',
            onTap: () {},
          ),
          const SizedBox(width: 14),
          ToolCard(
            icon: Icons.badge,
            title: 'IEC Validator',
            subtitle: 'Verify IEC instantly',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
