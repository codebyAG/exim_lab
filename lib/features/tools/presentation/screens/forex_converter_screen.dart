import 'package:exim_lab/features/tools/presentation/screens/forex_rates_list_screen.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/dashboard/data/models/exchange_rate_model.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/exchange_rate_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/localization/app_localization.dart';

class ForexConverterScreen extends StatefulWidget {
  const ForexConverterScreen({super.key});

  @override
  State<ForexConverterScreen> createState() => _ForexConverterScreenState();
}

class _ForexConverterScreenState extends State<ForexConverterScreen> {
  final _amountController = TextEditingController(text: '1.00');
  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  double? _customResult;

  @override
  void initState() {
    super.initState();
    // Refresh rates on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExchangeRateProvider>().fetchRates();
    });
  }

  void _calculateResult(ExchangeRateResponse? data) {
    if (data == null) return;
    final amount = double.tryParse(_amountController.text) ?? 1.0;

    // Logic: Convert From -> Base (INR) -> To
    // Our API base is INR.
    // Rate for USD is roughly 0.012 (1/83.5).
    // To get 1 USD in INR: 1 / USD_RATE

    final fromRate = data.data.conversionRates[_fromCurrency] ?? 1.0;
    final toRate = data.data.conversionRates[_toCurrency] ?? 1.0;

    // Convert fromCurrency to Base (INR)
    final valueInBase = amount / fromRate;
    // Convert Base (INR) to toCurrency
    _customResult = valueInBase * toRate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context);

    return Consumer<ExchangeRateProvider>(
      builder: (context, provider, child) {
        final data = provider.data;
        _calculateResult(data);

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFF),
          appBar: AppBar(
            title: Text(
              t.translate('tool_forex'),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          body: provider.isLoading && data == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildConverterCard(cs, theme, data),
                      SizedBox(height: 3.h),
                      _buildInfoCard(cs, theme),
                      SizedBox(height: 4.h),

                      // 📊 VIEW ALL BUTTON
                      _buildViewAllButton(context),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    return InkWell(
      onTap: () => AppNavigator.push(context, const ForexRatesListScreen()),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF1E5FFF).withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.list_alt_rounded, color: Color(0xFF1E5FFF)),
            SizedBox(width: 3.w),
            Text(
              "View Global Exchange Rates",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1E5FFF),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF1E5FFF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConverterCard(
    ColorScheme cs,
    ThemeData theme,
    ExchangeRateResponse? data,
  ) {
    final availableCurrencies =
        data?.data.conversionRates.keys.toList() ??
        ['USD', 'INR', 'EUR', 'GBP', 'AED', 'CNY'];

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5FFF).withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF030E30),
            ),
            decoration: InputDecoration(
              labelText: "Amount to Convert",
              labelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              prefixIcon: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Color(0xFF1E5FFF),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 1, color: Color(0xFFF0F4FF)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCurrencyDropdown(_fromCurrency, availableCurrencies, (v) {
                setState(() => _fromCurrency = v!);
              }),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F4FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sync_alt_rounded,
                  color: Color(0xFF1E5FFF),
                ),
              ),
              _buildCurrencyDropdown(_toCurrency, availableCurrencies, (v) {
                setState(() => _toCurrency = v!);
              }),
            ],
          ),
          SizedBox(height: 4.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E5FFF).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  "Converted Amount",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "${_customResult?.toStringAsFixed(2) ?? '0.00'} $_toCurrency",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1E5FFF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyDropdown(
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E7FF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          menuMaxHeight: 40.h,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.sp,
                      color: const Color(0xFF030E30),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildInfoCard(ColorScheme cs, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E7FF).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF1E5FFF).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF1E5FFF)),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              "Rates are indicative live market prices for reference. Settlement rates may vary.",
              style: TextStyle(
                color: const Color(0xFF1E5FFF),
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
