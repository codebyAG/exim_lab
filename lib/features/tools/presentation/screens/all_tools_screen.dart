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
import 'package:exim_lab/features/dashboard/presentation/painters/dashboard_icons_painter.dart';
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
        'painter': ExportPriceIconPainter(),
        'screen': const ExportPriceCalculatorScreen(),
        'color': const Color(0xFF0D47A1),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_import_calc'),
        'subtitle': t.translate('tool_import_calc_sub'),
        'painter': ImportCalcIconPainter(),
        'screen': const ImportCalculatorScreen(),
        'color': const Color(0xFFD32F2F),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_hsn_finder'),
        'subtitle': t.translate('tool_hsn_finder_sub'),
        'painter': HsnFinderPainter(),
        'screen': const HsnFinderScreen(),
        'color': const Color(0xFF00C853),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_cbm_calc'),
        'subtitle': t.translate('tool_cbm_calc_sub'),
        'painter': CbmCalculatorPainter(),
        'screen': const CbmCalculatorScreen(),
        'color': const Color(0xFF00B0FF),
        'isLocked': !isPremium, // Now Paid Only
      },
      {
        'title': t.translate('tool_gst_calc'),
        'subtitle': t.translate('tool_gst_calc_sub'),
        'painter': GstCalculatorPainter(),
        'screen': const GstCalculatorScreen(),
        'color': const Color(0xFFFF6D00),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_prod_cert'),
        'subtitle': t.translate('tool_prod_cert_sub'),
        'painter': ProductCertPainter(),
        'screen': const ProductCertScreen(),
        'color': const Color(0xFF283593),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_forex'),
        'subtitle': t.translate('tool_forex_sub'),
        'painter': ForexConverterPainter(),
        'screen': const ForexConverterScreen(),
        'color': const Color(0xFF2E7D32),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_gov_benefits'),
        'subtitle': t.translate('tool_gov_benefits_sub'),
        'painter': GovBenefitsPainter(),
        'screen': const GovBenefitsScreen(),
        'color': const Color(0xFF7B1FA2),
        'isLocked': !isPremium,
      },
      {
        'title': t.translate('tool_incoterms_2026'),
        'subtitle': t.translate('tool_incoterms_sub'),
        'painter': IncotermsPainter(),
        'screen': const IncotermsScreen(),
        'color': const Color(0xFF455A64),
        'isLocked': !isPremium,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF020C28),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.translate('tools_section_title'),
          style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
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
            painter: tool['painter'],
            title: tool['title'],
            subtitle: tool['subtitle'],
            buttonLabel: "Open >",
            themeColor: tool['color'],
            isLocked: tool['isLocked'],
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
