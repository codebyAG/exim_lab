import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';

class ExportPriceCalculatorScreen extends StatefulWidget {
  const ExportPriceCalculatorScreen({super.key});

  @override
  State<ExportPriceCalculatorScreen> createState() =>
      _ExportPriceCalculatorScreenState();
}

class _ExportPriceCalculatorScreenState
    extends State<ExportPriceCalculatorScreen> {
  final _productCtrl = TextEditingController();
  final _packagingCtrl = TextEditingController();
  final _freightCtrl = TextEditingController();
  final _profitCtrl = TextEditingController();

  double? sellingPrice;
  double? profitAmount;
  double? totalCost;
  bool _showResults = false;

  @override
  void dispose() {
    _productCtrl.dispose();
    _packagingCtrl.dispose();
    _freightCtrl.dispose();
    _profitCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    final product = double.tryParse(_productCtrl.text) ?? 0;
    final packaging = double.tryParse(_packagingCtrl.text) ?? 0;
    final freight = double.tryParse(_freightCtrl.text) ?? 0;
    final profitPercent = double.tryParse(_profitCtrl.text) ?? 0;

    totalCost = product + packaging + freight;
    profitAmount = totalCost! * (profitPercent / 100);
    sellingPrice = totalCost! + profitAmount!;

    setState(() {
      _showResults = true;
    });

    context.read<AnalyticsService>().logToolUse(
      toolName: 'Export Price Calculator',
      action: 'Calculate',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Export Price Calculator'),
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
                      Icons.attach_money_rounded,
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
                          'Export Pricing',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onPrimaryContainer,
                          ),
                        ),
                        SizedBox(height: 0.3.h),
                        Text(
                          'Calculate selling price with profit',
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
              'Cost Breakdown',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.5.h),

            _inputField(
              'Product Cost',
              _productCtrl,
              Icons.inventory_outlined,
              '₹',
            ),
            SizedBox(height: 1.5.h),
            _inputField(
              'Packaging Cost',
              _packagingCtrl,
              Icons.inventory_2_outlined,
              '₹',
            ),
            SizedBox(height: 1.5.h),
            _inputField(
              'Freight Cost',
              _freightCtrl,
              Icons.local_shipping_outlined,
              '₹',
            ),
            SizedBox(height: 1.5.h),
            _inputField(
              'Profit Margin',
              _profitCtrl,
              Icons.trending_up_rounded,
              '%',
            ),

            SizedBox(height: 3.h),

            // Calculate Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate_rounded),
                label: const Text(
                  'Calculate Price',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            // Results Section
            if (_showResults && sellingPrice != null) ...[
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
                          'Pricing Breakdown',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.5.h),
                    _resultCard(
                      icon: Icons.receipt_long_outlined,
                      title: 'Total Cost',
                      value: '₹${totalCost!.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: 1.2.h),
                    _resultCard(
                      icon: Icons.add_circle_outline_rounded,
                      title: 'Profit Amount',
                      value: '₹${profitAmount!.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: 1.2.h),
                    _resultCard(
                      icon: Icons.sell_outlined,
                      title: 'Selling Price',
                      value: '₹${sellingPrice!.toStringAsFixed(2)}',
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

  Widget _inputField(
    String label,
    TextEditingController controller,
    IconData icon,
    String suffix,
  ) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        suffixText: suffix,
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
