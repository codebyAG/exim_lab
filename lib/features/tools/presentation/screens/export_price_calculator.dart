import 'package:flutter/material.dart';

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

  void _calculate() {
    final product = double.tryParse(_productCtrl.text) ?? 0;
    final packaging = double.tryParse(_packagingCtrl.text) ?? 0;
    final freight = double.tryParse(_freightCtrl.text) ?? 0;
    final profitPercent = double.tryParse(_profitCtrl.text) ?? 0;

    final totalCost = product + packaging + freight;
    profitAmount = totalCost * (profitPercent / 100);
    sellingPrice = totalCost + profitAmount!;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(title: const Text('Export Price Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _inputField('Product Cost (₹)', _productCtrl),
            _inputField('Packaging Cost (₹)', _packagingCtrl),
            _inputField('Freight Cost (₹)', _freightCtrl),
            _inputField('Profit %', _profitCtrl),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _calculate,
                child: const Text(
                  'Calculate',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            if (sellingPrice != null) ...[
              const SizedBox(height: 32),

              _resultTile(
                'Profit Amount',
                '₹${profitAmount!.toStringAsFixed(2)}',
              ),
              _resultTile(
                'Selling Price',
                '₹${sellingPrice!.toStringAsFixed(2)}',
                isHighlight: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _resultTile(String title, String value, {bool isHighlight = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: isHighlight ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
