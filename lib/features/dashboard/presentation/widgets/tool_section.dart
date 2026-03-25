import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/tools/presentation/screens/cbm_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/export_price_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/forex_converter_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/gov_benefits_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/gst_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/hsn_finder_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/import_calculator_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/incoterms_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/product_cert_screen.dart';
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
      showDialog(
        context: context,
        builder: (_) => const PremiumUnlockDialog(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return SizedBox(
      height: 28.h, // Adjusted to fit the new card height
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: Row(
          children: [
            ToolCard(
              icon: Icons.calculate,
              title: t.translate('tool_export_calc'),
              subtitle: t.translate('tool_export_calc_sub'),
              buttonLabel: "Calculate >",
              themeColor: const Color(0xFF0D47A1), // Navy
              isLocked: !isPremium,
              onTap: () => _onToolTap(context, const ExportPriceCalculatorScreen()),
            ),
            ToolCard(
              icon: Icons.receipt_long_rounded,
              title: t.translate('tool_import_calc'),
              subtitle: t.translate('tool_import_calc_sub'),
              buttonLabel: "Estimate >",
              themeColor: const Color(0xFFD32F2F), // Red
              isLocked: !isPremium,
              onTap: () => _onToolTap(context, const ImportCalculatorScreen()),
            ),
            ToolCard(
              icon: Icons.search_rounded,
              title: t.translate('tool_hsn_finder'),
              subtitle: t.translate('tool_hsn_finder_sub'),
              buttonLabel: "Find Now >",
              themeColor: const Color(0xFF00C853), // Green
              isLocked: !isPremium,
              onTap: () => _onToolTap(context, const HsnFinderScreen()),
            ),
            ToolCard(
              icon: Icons.aspect_ratio_rounded,
              title: t.translate('tool_cbm_calc'),
              subtitle: t.translate('tool_cbm_calc_sub'),
              buttonLabel: "Measure >",
              themeColor: const Color(0xFF00B0FF), // Light Blue
              isLocked: false, // Free
              onTap: () => AppNavigator.push(context, const CbmCalculatorScreen()),
            ),
            ToolCard(
              icon: Icons.percent_rounded,
              title: t.translate('tool_gst_calc'),
              subtitle: t.translate('tool_gst_calc_sub'),
              buttonLabel: "Compute >",
              themeColor: const Color(0xFFFF6D00), // Orange
              isLocked: !isPremium,
              onTap: () => _onToolTap(context, const GstCalculatorScreen()),
            ),
            ToolCard(
              icon: Icons.verified_user_rounded,
              title: t.translate('tool_prod_cert'),
              subtitle: t.translate('tool_prod_cert_sub'),
              buttonLabel: "Verify >",
              themeColor: const Color(0xFF283593), // Indigo
              isLocked: !isPremium,
              onTap: () => _onToolTap(context, const ProductCertScreen()),
            ),
            ToolCard(
              icon: Icons.currency_exchange_rounded,
              title: t.translate('tool_forex'),
              subtitle: t.translate('tool_forex_sub'),
              buttonLabel: "Convert >",
              themeColor: const Color(0xFF2E7D32), // Dark Green
              isLocked: !isPremium,
              onTap: () => _onToolTap(context, const ForexConverterScreen()),
            ),
            ToolCard(
              icon: Icons.account_balance_rounded,
              title: t.translate('tool_gov_benefits'),
              subtitle: t.translate('tool_gov_benefits_sub'),
              buttonLabel: "Explore >",
              themeColor: const Color(0xFF7B1FA2), // Purple
              isLocked: !isPremium,
              onTap: () => _onToolTap(context, const GovBenefitsScreen()),
            ),
            ToolCard(
              icon: Icons.menu_book_rounded,
              title: t.translate('tool_incoterms_2026'),
              subtitle: t.translate('tool_incoterms_sub'),
              buttonLabel: "Read More >",
              themeColor: const Color(0xFF455A64), // Blue Grey
              isLocked: !isPremium,
              onTap: () => _onToolTap(context, const IncotermsScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
