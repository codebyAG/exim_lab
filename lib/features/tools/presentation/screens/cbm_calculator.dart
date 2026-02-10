import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';

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
  bool _showResults = false;

  @override
  void dispose() {
    _lengthCtrl.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

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
        _showResults = true;
      });

      context.read<AnalyticsService>().logToolUse(
        toolName: 'CBM Calculator',
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
        title: const Text('CBM Calculator'),
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
                      Icons.calculate_outlined,
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
                          'Calculate Volume',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onPrimaryContainer,
                          ),
                        ),
                        SizedBox(height: 0.3.h),
                        Text(
                          'Cubic Meters & Volumetric Weight',
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
              'Dimensions (in cm)',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.5.h),

            Row(
              children: [
                Expanded(
                  child: _inputField(
                    'Length',
                    _lengthCtrl,
                    Icons.straighten_outlined,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _inputField(
                    'Width',
                    _widthCtrl,
                    Icons.width_normal_outlined,
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.5.h),

            Row(
              children: [
                Expanded(
                  child: _inputField(
                    'Height',
                    _heightCtrl,
                    Icons.height_outlined,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _inputField(
                    'Quantity',
                    _qtyCtrl,
                    Icons.inventory_2_outlined,
                  ),
                ),
              ],
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
                  'Calculate CBM',
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
            if (_showResults && _totalCbm != null) ...[
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
                          'Results',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.5.h),
                    _resultCard(
                      icon: Icons.view_in_ar_rounded,
                      title: 'Total CBM',
                      value: '${_totalCbm!.toStringAsFixed(3)} m³',
                      isHighlight: true,
                    ),
                    SizedBox(height: 1.2.h),
                    _resultCard(
                      icon: Icons.scale_outlined,
                      title: 'Volumetric Weight',
                      value: '${_volumetricWeight!.toStringAsFixed(2)} Kg',
                      subtitle: 'Approx. for air freight',
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
    String? subtitle,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 0.2.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ],
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
