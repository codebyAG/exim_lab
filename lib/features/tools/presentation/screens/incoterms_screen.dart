import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';

class IncotermsScreen extends StatelessWidget {
  const IncotermsScreen({super.key});

  final List<Map<String, String>> _terms = const [
    {
      'code': 'EXW',
      'title': 'Ex Works',
      'desc':
          'Seller makes goods available at their premises. Buyer bears all risks and costs from there.',
      'category': 'Any Mode',
    },
    {
      'code': 'FCA',
      'title': 'Free Carrier',
      'desc':
          'Seller delivers goods to a carrier or another person nominated by the buyer.',
      'category': 'Any Mode',
    },
    {
      'code': 'CPT',
      'title': 'Carriage Paid To',
      'desc':
          'Seller delivers goods to the carrier and pays for carriage to the named destination.',
      'category': 'Any Mode',
    },
    {
      'code': 'CIP',
      'title': 'Carriage and Insurance Paid To',
      'desc': 'Same as CPT, but seller also pays for insurance coverage.',
      'category': 'Any Mode',
    },
    {
      'code': 'DAP',
      'title': 'Delivered at Place',
      'desc':
          'Seller delivers when goods are placed at the disposal of the buyer at the named destination.',
      'category': 'Any Mode',
    },
    {
      'code': 'DPU',
      'title': 'Delivered at Place Unloaded',
      'desc':
          'Seller delivers when goods are unloaded at the named destination. Seller bears all risks.',
      'category': 'Any Mode',
    },
    {
      'code': 'DDP',
      'title': 'Delivered Duty Paid',
      'desc':
          'Seller bears all costs and risks involved in bringing the goods to the destination, including duties.',
      'category': 'Any Mode',
    },
    {
      'code': 'FAS',
      'title': 'Free Alongside Ship',
      'desc':
          'Seller delivers when goods are placed alongside the vessel nominated by the buyer (e.g. on quay).',
      'category': 'Sea/Inland',
    },
    {
      'code': 'FOB',
      'title': 'Free on Board',
      'desc':
          'Seller delivers goods on board the vessel nominated by the buyer.',
      'category': 'Sea/Inland',
    },
    {
      'code': 'CFR',
      'title': 'Cost and Freight',
      'desc':
          'Seller delivers goods on board the vessel. Seller pays for costs and freight to the port of destination.',
      'category': 'Sea/Inland',
    },
    {
      'code': 'CIF',
      'title': 'Cost, Insurance and Freight',
      'desc': 'Same as CFR, but seller also pays for insurance coverage.',
      'category': 'Sea/Inland',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsService>().logToolUse(toolName: 'Incoterms');
    });

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Incoterms 2020'),
        backgroundColor: cs.surfaceContainerLowest,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            margin: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 1.h),
            padding: EdgeInsets.all(2.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cs.primaryContainer,
                  cs.primaryContainer.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_shipping_rounded,
                    color: cs.onPrimary,
                    size: 28,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'International Trade Terms',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        '11 standard delivery terms',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onPrimaryContainer.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Terms List
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              itemCount: _terms.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.2.h),
              itemBuilder: (context, index) {
                final term = _terms[index];
                final isSeaMode = term['category'] == 'Sea/Inland';

                return FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  delay: Duration(milliseconds: (index < 8 ? index : 7) * 40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Theme(
                      data: theme.copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        childrenPadding: EdgeInsets.fromLTRB(
                          2.w,
                          0,
                          2.w,
                          1.5.h,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSeaMode
                                ? cs.secondaryContainer
                                : cs.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            term['code']!,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: isSeaMode
                                  ? cs.onSecondaryContainer
                                  : cs.onPrimaryContainer,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        title: Text(
                          term['title']!,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 0.3.h),
                          child: Text(
                            term['category']!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        iconColor: cs.primary,
                        collapsedIconColor: cs.onSurfaceVariant,
                        children: [
                          Container(
                            padding: EdgeInsets.all(1.5.h),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest.withValues(
                                alpha: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 18,
                                  color: cs.primary,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    term['desc']!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: cs.onSurfaceVariant,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
