import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/tools/presentation/screens/cbm_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/export_price_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/gst_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/incoterms_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_unlock_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'tool_card.dart';

class ToolsSection extends StatelessWidget {
  final bool isPremium;

  const ToolsSection({super.key, this.isPremium = false});

  void _onToolTap(BuildContext context, Widget screen) {
    if (isPremium) {
      AppNavigator.push(context, screen);
    } else {
      showDialog(context: context, builder: (_) => const PremiumUnlockDialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return SizedBox(
      height: 22.h, // ✅ responsive height
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        children: [
          ToolCard(
            icon: Icons.calculate,
            title: t.translate('tool_export_calc'),
            subtitle: t.translate('tool_export_calc_sub'),
            isLocked: !isPremium,
            onTap:
                () => _onToolTap(context, const ExportPriceCalculatorScreen()),
          ),

          SizedBox(width: 3.w),

          ToolCard(
            icon: Icons.aspect_ratio_rounded,
            title: t.translate('tool_cbm_calc'),
            subtitle: t.translate('tool_cbm_calc_sub'),
            isLocked: false, // Always unlocked as per user request (one free tool)
            onTap: () => AppNavigator.push(context, const CbmCalculatorScreen()),
          ),

          SizedBox(width: 3.w),

          ToolCard(
            icon: Icons.percent_rounded,
            title: t.translate('tool_gst_calc'),
            subtitle: t.translate('tool_gst_calc_sub'),
            isLocked: !isPremium,
            onTap: () => _onToolTap(context, const GstCalculatorScreen()),
          ),

          SizedBox(width: 3.w),

          ToolCard(
            icon: Icons.menu_book_rounded,
            title: t.translate('tool_incoterms'),
            subtitle: t.translate('tool_incoterms_sub'),
            isLocked: !isPremium,
            onTap: () => _onToolTap(context, const IncotermsScreen()),
          ),
        ],
      ),
    );
  }
}
