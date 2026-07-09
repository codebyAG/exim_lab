import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_unlock_dialog.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/tools/presentation/screens/cbm_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/export_price_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/forex_converter_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/gov_benefits_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/gst_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/hsn_finder_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/import_calculator_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/incoterms_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/product_cert_screen.dart';
import 'package:exim_lab/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/tool_card.dart';

class AllToolsScreen extends StatelessWidget {
  const AllToolsScreen({super.key});

  void _onToolTap(BuildContext context, Widget screen, bool isPremium, String toolName) {
    if (isPremium) {
      AppNavigator.push(context, screen);
    } else {
      showDialog(context: context, builder: (_) => const PremiumUnlockDialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // final theme = Theme.of(context);
    // final cs = theme.colorScheme;
    final isPremium = context.watch<AuthProvider>().user?.isPremium ?? false;

    final List<Map<String, dynamic>> tools = [
      {
        'title': t.translate('tool_export_calc'),
        'subtitle': t.translate('tool_export_calc_sub'),
        'icon': Icons.calculate_outlined,
        'screen': const ExportPriceCalculatorScreen(),
        'color': const Color(0xFF0D47A1),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_import_calc'),
        'subtitle': t.translate('tool_import_calc_sub'),
        'icon': Icons.request_quote_outlined,
        'screen': const ImportCalculatorScreen(),
        'color': const Color(0xFFD32F2F),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_hsn_finder'),
        'subtitle': t.translate('tool_hsn_finder_sub'),
        'icon': Icons.manage_search_rounded,
        'screen': const HsnFinderScreen(),
        'color': const Color(0xFF00C853),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_cbm_calc'),
        'subtitle': t.translate('tool_cbm_calc_sub'),
        'icon': Icons.view_in_ar_outlined,
        'screen': const CbmCalculatorScreen(),
        'color': const Color(0xFF00B0FF),
        'isLocked': !isPremium, // Now Paid Only
      },
      {
        'title': t.translate('tool_gst_calc'),
        'subtitle': t.translate('tool_gst_calc_sub'),
        'icon': Icons.receipt_long_outlined,
        'screen': const GstCalculatorScreen(),
        'color': const Color(0xFFFF6D00),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_prod_cert'),
        'subtitle': t.translate('tool_prod_cert_sub'),
        'icon': Icons.verified_outlined,
        'screen': const ProductCertScreen(),
        'color': const Color(0xFF283593),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_forex'),
        'subtitle': t.translate('tool_forex_sub'),
        'icon': Icons.currency_exchange_rounded,
        'screen': const ForexConverterScreen(),
        'color': const Color(0xFF2E7D32),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_gov_benefits'),
        'subtitle': t.translate('tool_gov_benefits_sub'),
        'icon': Icons.account_balance_outlined,
        'screen': const GovBenefitsScreen(),
        'color': const Color(0xFF7B1FA2),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_incoterms_2026'),
        'subtitle': t.translate('tool_incoterms_sub'),
        'icon': Icons.hexagon_outlined,
        'screen': const IncotermsScreen(),
        'color': const Color(0xFF455A64),
        'isLocked': !isPremium,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEF2F8),
        elevation: 0,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t.translate('tools_section_title'),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.navy,
                fontSize: 20,
              ),
            ),
            Text(
              t.translate('tools_smart_subtitle'),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.navy,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4.w,
          crossAxisSpacing: 4.w,
          childAspectRatio: 0.85,
        ),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          return ToolCard(
            icon: tool['icon'],
            title: tool['title'],
            subtitle: tool['subtitle'],
            buttonLabel: "Open >",
            themeColor: tool['color'],
            isLocked: tool['isLocked'],
            isLight: true,
            onTap: () => _onToolTap(
              context,
              tool['screen'],
              !tool['isLocked'],
              tool['title'],
            ),
          );
        },
      ),
    );
  }
}
