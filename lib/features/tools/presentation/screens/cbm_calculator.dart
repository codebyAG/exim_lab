import 'package:flutter/material.dart';

class CbmCalculatorScreen extends StatefulWidget {
  const CbmCalculatorScreen({super.key});

  @override
  State<CbmCalculatorScreen> createState() => _CbmCalculatorScreenState();
}

class _CbmCalculatorScreenState extends State<CbmCalculatorScreen> {
  final _lengthCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '1');

  double? _totalCbm;
  double? _volumetricWeight;

  void _calculate() {
    final l = double.tryParse(_lengthCtrl.text) ?? 0;
    final w = double.tryParse(_widthCtrl.text) ?? 0;
    final h = double.tryParse(_heightCtrl.text) ?? 0;
    final qty = int.tryParse(_qtyCtrl.text) ?? 1;

    if (l > 0 && w > 0 && h > 0) {
      // Assuming Input is in CM
      final cbmPerItem = (l * w * h) / 1000000;
      final total = cbmPerItem * qty;

      // Air Freight Volumetric Weight (Std conversion: 1 CBM = 167 Kg)
      final volWeight = total * 167.0;

      setState(() {
        _totalCbm = total;
        _volumetricWeight = volWeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('CBM Calculator'),
        backgroundColor: cs.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculate Volume (Cubic Meters)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _inputField('Length (cm)', _lengthCtrl)),
                const SizedBox(width: 12),
                Expanded(child: _inputField('Width (cm)', _widthCtrl)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _inputField('Height (cm)', _heightCtrl)),
                const SizedBox(width: 12),
                Expanded(child: _inputField('Quantity (Pcs)', _qtyCtrl)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Calculate',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: cs.onPrimary,
                  ),
                ),
              ),
            ),
            if (_totalCbm != null) ...[
              const SizedBox(height: 32),
              _resultTile(
                'Total CBM',
                '${_totalCbm!.toStringAsFixed(3)} m³',
                isHighlight: true,
              ),
              _resultTile(
                'Volumetric Weight',
                '${_volumetricWeight!.toStringAsFixed(2)} Kg (Approx)',
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
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _resultTile(String title, String value, {bool isHighlight = false}) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest,
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
              color: isHighlight ? theme.colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
