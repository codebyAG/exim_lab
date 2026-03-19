import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/localization/app_localization.dart';

class ProductCertScreen extends StatelessWidget {
  const ProductCertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context);

    final List<Map<String, String>> certs = [
      {
        'title': 'BIS Certification',
        'subtitle': 'Bureau of Indian Standards',
        'desc': 'Mandatory for electronics, white goods, and specific chemicals to ensure quality standards.',
        'icon': 'verified_rounded'
      },
      {
        'title': 'FSSAI License',
        'subtitle': 'Food Safety & Standards Authority of India',
        'desc': 'Required for all food-related imports and exports to ensure safety and hygiene.',
        'icon': 'restaurant_rounded'
      },
      {
        'title': 'EPR Registration',
        'subtitle': 'Extended Producer Responsibility',
        'desc': 'Mandatory for importers of electronic waste, plastic, and batteries for environmental compliance.',
        'icon': 'recycling_rounded'
      },
      {
        'title': 'LMPC Certificate',
        'subtitle': 'Legal Metrology (Packaged Commodities)',
        'desc': 'Required for any importer who imports pre-packed commodities into India.',
        'icon': 'inventory_rounded'
      },
      {
        'title': 'WPC Approval',
        'subtitle': 'Wireless Planning and Coordination',
        'desc': 'Mandatory for importing wireless and radio equipment into India.',
        'icon': 'wifi_rounded'
      },
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(t.translate('tool_prod_cert')),
        backgroundColor: cs.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(5.w),
        itemCount: certs.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final cert = certs[index];
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
                      child: Icon(_getIcon(cert['icon']!), color: cs.primary, size: 24),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cert['title']!, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                          Text(cert['subtitle']!, style: theme.textTheme.labelSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  cert['desc']!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant, height: 1.4),
                ),
                SizedBox(height: 1.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Learn More →", style: TextStyle(fontWeight: FontWeight.w800, color: cs.primary)),
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
      case 'verified_rounded': return Icons.verified_rounded;
      case 'restaurant_rounded': return Icons.restaurant_rounded;
      case 'recycling_rounded': return Icons.recycling_rounded;
      case 'inventory_rounded': return Icons.inventory_rounded;
      case 'wifi_rounded': return Icons.wifi_rounded;
      default: return Icons.info_rounded;
    }
  }
}
