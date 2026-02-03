import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/tools/presentation/screens/cbm_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/export_price_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/gst_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/incoterms_screen.dart';
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
              AppNavigator.push(context, const ExportPriceCalculatorScreen());
            },
          ),

          SizedBox(width: 3.w),

          ToolCard(
            icon: Icons.aspect_ratio_rounded,
            title: 'CBM Calculator',
            subtitle: 'Calculate shipment volume',
            onTap: () {
              AppNavigator.push(context, const CbmCalculatorScreen());
            },
          ),

          SizedBox(width: 3.w),

          ToolCard(
            icon: Icons.percent_rounded,
            title: 'GST Calculator',
            subtitle: 'Tax & Total Amount',
            onTap: () {
              AppNavigator.push(context, const GstCalculatorScreen());
            },
          ),

          SizedBox(width: 3.w),

          ToolCard(
            icon: Icons.menu_book_rounded,
            title: 'Incoterms 2020',
            subtitle: 'Shipping Terms Guide',
            onTap: () {
              AppNavigator.push(context, const IncotermsScreen());
            },
          ),
        ],
      ),
    );
  }
}
