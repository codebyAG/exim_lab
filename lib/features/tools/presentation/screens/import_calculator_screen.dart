import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/localization/app_localization.dart';

class ImportCalculatorScreen extends StatefulWidget {
  const ImportCalculatorScreen({super.key});

  @override
  State<ImportCalculatorScreen> createState() => _ImportCalculatorScreenState();
}

class _ImportCalculatorScreenState extends State<ImportCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _costController = TextEditingController();
  final _freightController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _bcdRateController = TextEditingController(text: '10');
  final _igstRateController = TextEditingController(text: '18');

  double _cifValue = 0;
  double _bcdAmount = 0;
  double _swsAmount = 0;
  double _igstAmount = 0;
  double _totalLandedCost = 0;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final cost = double.tryParse(_costController.text) ?? 0;
      final freight = double.tryParse(_freightController.text) ?? 0;
      final insurance = double.tryParse(_insuranceController.text) ?? 0;
      final bcdRate = double.tryParse(_bcdRateController.text) ?? 0;
      final igstRate = double.tryParse(_igstRateController.text) ?? 0;

      setState(() {
        _cifValue = cost + freight + insurance;
        _bcdAmount = _cifValue * (bcdRate / 100);
        _swsAmount = _bcdAmount * 0.10;
        final igstBase = _cifValue + _bcdAmount + _swsAmount;
        _igstAmount = igstBase * (igstRate / 100);
        _totalLandedCost = igstBase + _igstAmount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(t.translate('tool_import_calc')),
        backgroundColor: cs.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputCard(cs, theme),
              SizedBox(height: 3.h),
              if (_totalLandedCost > 0) _buildResultCard(cs, theme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(5.w),
        child: ElevatedButton(
          onPressed: _calculate,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            minimumSize: Size(double.infinity, 7.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            "Calculate Landed Cost",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(ColorScheme cs, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField("Product Value (FOB)", _costController, Icons.inventory_2_rounded),
          SizedBox(height: 2.h),
          _buildField("Freight Charges", _freightController, Icons.local_shipping_rounded),
          SizedBox(height: 2.h),
          _buildField("Insurance", _insuranceController, Icons.security_rounded),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(child: _buildField("BCD Rate (%)", _bcdRateController, Icons.percent_rounded)),
              SizedBox(width: 4.w),
              Expanded(child: _buildField("IGST Rate (%)", _igstRateController, Icons.percent_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.05),
      ),
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }

  Widget _buildResultCard(ColorScheme cs, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _resultRow("CIF Value", _cifValue),
          _resultRow("Custom Duty (BCD)", _bcdAmount),
          _resultRow("Surcharge (SWS)", _swsAmount),
          _resultRow("IGST", _igstAmount),
          const Divider(color: Colors.white24, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Landed Cost",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                "₹${_totalLandedCost.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resultRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
          Text("₹${value.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
