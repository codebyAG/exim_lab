import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/localization/app_localization.dart';

class ForexConverterScreen extends StatefulWidget {
  const ForexConverterScreen({super.key});

  @override
  State<ForexConverterScreen> createState() => _ForexConverterScreenState();
}

class _ForexConverterScreenState extends State<ForexConverterScreen> {
  final _amountController = TextEditingController(text: '1');
  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  double _result = 83.50;

  final Map<String, double> _rates = {
    'USD_INR': 83.50,
    'EUR_INR': 90.20,
    'GBP_INR': 105.40,
    'AED_INR': 22.74,
    'CNY_INR': 11.55,
    'INR_USD': 0.012,
    'USD_EUR': 0.93,
  };

  void _convert() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final key = '${_fromCurrency}_$_toCurrency';
    final rate = _rates[key] ?? 1.0;
    setState(() {
      _result = amount * rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(t.translate('tool_forex')),
        backgroundColor: cs.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            _buildConverterCard(cs, theme),
            SizedBox(height: 4.h),
            _buildInfoCard(cs, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildConverterCard(ColorScheme cs, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: cs.shadow.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            onChanged: (_) => _convert(),
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: "Amount",
              border: InputBorder.none,
              prefixIcon: Icon(Icons.attach_money_rounded, color: cs.primary),
            ),
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCurrencyDropdown(_fromCurrency, (v) {
                setState(() => _fromCurrency = v!);
                _convert();
              }),
              Icon(Icons.sync_alt_rounded, color: cs.primary),
              _buildCurrencyDropdown(_toCurrency, (v) {
                setState(() => _toCurrency = v!);
                _convert();
              }),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            "Result",
            style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 1.h),
          Text(
            "${_result.toStringAsFixed(2)} $_toCurrency",
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w900, color: cs.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyDropdown(String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: ['USD', 'INR', 'EUR', 'GBP', 'AED', 'CNY']
            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontWeight: FontWeight.bold))))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildInfoCard(ColorScheme cs, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: cs.primary),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              "Rates are indicative and for reference purpose only. Actual rates may vary during bank settlement.",
              style: TextStyle(color: cs.primary, fontSize: 11.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
