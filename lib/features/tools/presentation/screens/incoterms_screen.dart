import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/localization/app_localization.dart';

class IncotermsScreen extends StatelessWidget {
  const IncotermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final loc = AppLocalizations.of(context);

    // Localized incoterms data
    final terms = [
      {
        'code': 'EXW',
        'title': loc.translate('incoterms_exw'),
        'desc': loc.translate('incoterms_exw_desc'),
        'category': loc.translate('incoterms_any_mode'),
      },
      {
        'code': 'FCA',
        'title': loc.translate('incoterms_fca'),
        'desc': loc.translate('incoterms_fca_desc'),
        'category': loc.translate('incoterms_any_mode'),
      },
      {
        'code': 'CPT',
        'title': loc.translate('incoterms_cpt'),
        'desc': loc.translate('incoterms_cpt_desc'),
        'category': loc.translate('incoterms_any_mode'),
      },
      {
        'code': 'CIP',
        'title': loc.translate('incoterms_cip'),
        'desc': loc.translate('incoterms_cip_desc'),
        'category': loc.translate('incoterms_any_mode'),
      },
      {
        'code': 'DAP',
        'title': loc.translate('incoterms_dap'),
        'desc': loc.translate('incoterms_dap_desc'),
        'category': loc.translate('incoterms_any_mode'),
      },
      {
        'code': 'DPU',
        'title': loc.translate('incoterms_dpu'),
        'desc': loc.translate('incoterms_dpu_desc'),
        'category': loc.translate('incoterms_any_mode'),
      },
      {
        'code': 'DDP',
        'title': loc.translate('incoterms_ddp'),
        'desc': loc.translate('incoterms_ddp_desc'),
        'category': loc.translate('incoterms_any_mode'),
      },
      {
        'code': 'FAS',
        'title': loc.translate('incoterms_fas'),
        'desc': loc.translate('incoterms_fas_desc'),
        'category': loc.translate('incoterms_sea_inland'),
      },
      {
        'code': 'FOB',
        'title': loc.translate('incoterms_fob'),
        'desc': loc.translate('incoterms_fob_desc'),
        'category': loc.translate('incoterms_sea_inland'),
      },
      {
        'code': 'CFR',
        'title': loc.translate('incoterms_cfr'),
        'desc': loc.translate('incoterms_cfr_desc'),
        'category': loc.translate('incoterms_sea_inland'),
      },
      {
        'code': 'CIF',
        'title': loc.translate('incoterms_cif'),
        'desc': loc.translate('incoterms_cif_desc'),
        'category': loc.translate('incoterms_sea_inland'),
      },
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsService>().logToolUse(toolName: 'Incoterms');
    });

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(loc.translate('incoterms_title')),
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
                        loc.translate('incoterms_trade_terms'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        loc.translate('incoterms_subtitle'),
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
              itemCount: terms.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.2.h),
              itemBuilder: (context, index) {
                final term = terms[index];
                final isSeaMode =
                    term['category'] == loc.translate('incoterms_sea_inland');

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
