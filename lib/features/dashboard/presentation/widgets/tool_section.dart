import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/tools/presentation/screens/export_price_calculator.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'tool_card.dart';

class ToolsSection extends StatelessWidget {
  const ToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22.h, // ✅ responsive height
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        children: [
          ToolCard(
            icon: Icons.calculate,
            title: 'Export Price Calculator',
            subtitle: 'Calculate selling price & profit',
            onTap: () {
              AppNavigator.push(
                context,
                const ExportPriceCalculatorScreen(),
              );
            },
          ),

          SizedBox(width: 3.w),

          ToolCard(
            icon: Icons.search,
            title: 'HS Code Finder',
            subtitle: 'Find correct HS codes',
            onTap: () {},
          ),

          SizedBox(width: 3.w),

          ToolCard(
            icon: Icons.receipt_long,
            title: 'Duty Calculator',
            subtitle: 'Estimate customs duty',
            onTap: () {},
          ),

          SizedBox(width: 3.w),

          ToolCard(
            icon: Icons.description,
            title: 'Document Checklist',
            subtitle: 'Required export docs',
            onTap: () {},
          ),

          SizedBox(width: 3.w),

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
