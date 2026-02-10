import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/localization/app_localization.dart';

class GstCalculatorScreen extends StatefulWidget {
  const GstCalculatorScreen({super.key});

  @override
  State<GstCalculatorScreen> createState() => _GstCalculatorScreenState();
}

class _GstCalculatorScreenState extends State<GstCalculatorScreen> {
  final _amountCtrl = TextEditingController();
  double _gstRate = 18;
  double? _gstAmount;
  double? _totalAmount;
  bool _showResults = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    if (amount > 0) {
      final gst = amount * (_gstRate / 100);
      final total = amount + gst;

      setState(() {
        _gstAmount = gst;
        _totalAmount = total;
        _showResults = true;
      });

      context.read<AnalyticsService>().logToolUse(
        toolName: 'GST Calculator',
        action: 'Calculate',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(loc.translate('gst_calc_title')),
        backgroundColor: cs.surfaceContainerLowest,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
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
                      Icons.receipt_long_rounded,
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
                          loc.translate('gst_calc_title'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onPrimaryContainer,
                          ),
                        ),
                        SizedBox(height: 0.3.h),
                        Text(
                          loc.translate('gst_calc_subtitle'),
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

            SizedBox(height: 3.h),

            // Input Section
            Text(
              loc.translate('gst_base_amount'),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.5.h),

            TextField(
              controller: _amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                labelText: loc.translate('gst_amount_label'),
                prefixIcon: const Icon(Icons.currency_rupee_rounded, size: 20),
                suffixText: '₹',
                filled: true,
                fillColor: cs.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: cs.primary, width: 2),
                ),
              ),
              onChanged: (_) => _calculate(),
            ),

            SizedBox(height: 3.h),

            // GST Rate Selector
            Text(
              loc.translate('gst_select_rate'),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.5.h),

            Row(
              children: [5, 12, 18, 28].map((rate) {
                final isSelected = _gstRate == rate;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: InkWell(
                      onTap: () {
                        setState(() => _gstRate = rate.toDouble());
                        if (_amountCtrl.text.isNotEmpty) _calculate();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: isSelected ? cs.primary : cs.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? cs.primary
                                : cs.outlineVariant.withValues(alpha: 0.5),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$rate%',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isSelected ? cs.onPrimary : cs.onSurface,
                              ),
                            ),
                            if (isSelected) ...[
                              SizedBox(height: 0.2.h),
                              Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: cs.onPrimary,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Results Section
            if (_showResults && _totalAmount != null) ...[
              SizedBox(height: 3.h),
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: cs.primary,
                          size: 20,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          loc.translate('gst_tax_breakdown'),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.5.h),
                    _resultCard(
                      icon: Icons.percent_rounded,
                      title: '${loc.translate('gst_amount')} ($_gstRate%)',
                      value: '₹${_gstAmount!.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: 1.2.h),
                    _resultCard(
                      icon: Icons.account_balance_wallet_outlined,
                      title: loc.translate('gst_total_amount'),
                      value: '₹${_totalAmount!.toStringAsFixed(2)}',
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _resultCard({
    required IconData icon,
    required String title,
    required String value,
    bool isHighlight = false,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: isHighlight ? cs.primaryContainer : cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlight
              ? cs.primary.withValues(alpha: 0.3)
              : cs.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isHighlight
                  ? cs.primary.withValues(alpha: 0.15)
                  : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isHighlight ? cs.primary : cs.onSurfaceVariant,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isHighlight ? cs.primary : cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
