import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/localization/app_localization.dart';

class GovBenefitsScreen extends StatelessWidget {
  const GovBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context);

    final List<Map<String, String>> benefits = [
      {
        'title': 'RoDTEP Scheme',
        'subtitle': 'Remission of Duties on Export Products',
        'desc': 'Refund of central, state, and local duties/taxes that are not otherwise refunded or credited.',
        'icon': 'payments_rounded'
      },
      {
        'title': 'Duty Drawback (DBK)',
        'subtitle': 'Customs & Excise Refund',
        'desc': 'Refund of customs duties paid on imported inputs used in the manufacture of export products.',
        'icon': 'savings_rounded'
      },
      {
        'title': 'EPCG Scheme',
        'subtitle': 'Export Promotion Capital Goods',
        'desc': 'Allows import of capital goods (machinery) at zero customs duty subject to an export obligation.',
        'icon': 'precision_manufacturing_rounded'
      },
      {
        'title': 'Advance Authorization',
        'subtitle': 'Duty-Free Import',
        'desc': 'Allows duty-free import of inputs, which are physically incorporated in an export product.',
        'icon': 'local_atm_rounded'
      },
      {
        'title': 'Interest Equalization',
        'subtitle': 'Interest Subvention on Credit',
        'desc': 'Provides 2-3% interest subvention on pre and post-shipment export credit for SMEs.',
        'icon': 'percent_rounded'
      },
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(t.translate('tool_gov_benefits')),
        backgroundColor: cs.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(5.w),
        itemCount: benefits.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final benefit = benefits[index];
          return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(color: cs.shadow.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getIcon(benefit['icon']!), color: cs.primary, size: 24),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(benefit['title']!, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                          Text(benefit['subtitle']!, style: theme.textTheme.labelSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  benefit['desc']!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant, height: 1.4),
                ),
                SizedBox(height: 1.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Check Eligibility →", style: TextStyle(fontWeight: FontWeight.w800, color: cs.primary)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'payments_rounded': return Icons.payments_rounded;
      case 'savings_rounded': return Icons.savings_rounded;
      case 'precision_manufacturing_rounded': return Icons.precision_manufacturing_rounded;
      case 'local_atm_rounded': return Icons.local_atm_rounded;
      case 'percent_rounded': return Icons.percent_rounded;
      default: return Icons.account_balance_rounded;
    }
  }
}
