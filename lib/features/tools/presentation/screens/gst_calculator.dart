import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';

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

  void _calculate() {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final gst = amount * (_gstRate / 100);
    final total = amount + gst;

    setState(() {
      _gstAmount = gst;
      _totalAmount = total;
    });

    context.read<AnalyticsService>().logToolUse(
      toolName: 'GST Calculator',
      action: 'Calculate',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('GST Calculator'),
        backgroundColor: cs.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Base Amount (₹)',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [5, 12, 18, 28].map((rate) {
                final isSelected = _gstRate == rate;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _gstRate = rate.toDouble());
                        if (_amountCtrl.text.isNotEmpty) _calculate();
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cs.primary
                              : cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? cs.primary
                                : cs.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          '$rate%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? cs.onPrimary : cs.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            if (_totalAmount != null) ...[
              _resultTile(
                'GST Amount ($_gstRate%)',
                '₹${_gstAmount!.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 12),
              _resultTile(
                'Total Amount',
                '₹${_totalAmount!.toStringAsFixed(2)}',
                isHighlight: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _resultTile(String title, String value, {bool isHighlight = false}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighlight ? cs.primary.withValues(alpha: 0.1) : cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlight ? cs.primary : cs.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isHighlight ? cs.primary : cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
