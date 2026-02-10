import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';

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

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('GST Calculator'),
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
                    cs.tertiaryContainer,
                    cs.tertiaryContainer.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.tertiary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: cs.onTertiary,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GST Calculator',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onTertiaryContainer,
                          ),
                        ),
                        SizedBox(height: 0.3.h),
                        Text(
                          'Calculate tax with multiple rates',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onTertiaryContainer.withValues(
                              alpha: 0.8,
                            ),
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
              'Base Amount',
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
                labelText: 'Amount',
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
              'Select GST Rate',
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
                          color: isSelected ? cs.tertiary : cs.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? cs.tertiary
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
                                color: isSelected
                                    ? cs.onTertiary
                                    : cs.onSurface,
                              ),
                            ),
                            if (isSelected) ...[
                              SizedBox(height: 0.2.h),
                              Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: cs.onTertiary,
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
                          color: cs.tertiary,
                          size: 20,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Tax Breakdown',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.tertiary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.5.h),
                    _resultCard(
                      icon: Icons.percent_rounded,
                      title: 'GST Amount ($_gstRate%)',
                      value: '₹${_gstAmount!.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: 1.2.h),
                    _resultCard(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Total Amount',
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
        color: isHighlight ? cs.tertiaryContainer : cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlight
              ? cs.tertiary.withValues(alpha: 0.3)
              : cs.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isHighlight
                  ? cs.tertiary.withValues(alpha: 0.15)
                  : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isHighlight ? cs.tertiary : cs.onSurfaceVariant,
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
              color: isHighlight ? cs.tertiary : cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
