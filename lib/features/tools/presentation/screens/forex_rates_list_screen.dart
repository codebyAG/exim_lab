import 'package:exim_lab/features/dashboard/data/models/exchange_rate_model.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/exchange_rate_provider.dart';
import 'package:exim_lab/features/tools/presentation/screens/forex_converter_screen.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ForexRatesListScreen extends StatefulWidget {
  const ForexRatesListScreen({super.key});

  @override
  State<ForexRatesListScreen> createState() => _ForexRatesListScreenState();
}

class _ForexRatesListScreenState extends State<ForexRatesListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExchangeRateProvider>().fetchRates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExchangeRateProvider>(
      builder: (context, provider, child) {
        final allRates = provider.data?.getDisplayRates() ?? [];
        final filteredRates = allRates.where((rate) {
          return rate.currency.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFF),
          appBar: AppBar(
            title: const Text(
              "Global Exchange Rates",
              style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF030E30)),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF030E30)),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.calculate_rounded, color: Color(0xFF1E5FFF)),
                onPressed: () => AppNavigator.push(context, const ForexConverterScreen()),
              ),
            ],
          ),
          body: Column(
            children: [
              // 🔍 SEARCH BAR
              _buildSearchBar(),

              // 📋 THE LIST
              Expanded(
                child: provider.isLoading && allRates.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _buildList(filteredRates, provider.isLoading),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => AppNavigator.push(context, const ForexConverterScreen()),
            label: const Text("Converter", style: TextStyle(fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.currency_exchange_rounded),
            backgroundColor: const Color(0xFF1E5FFF),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: "Search Currencies (e.g. USD, AED)...",
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF1E5FFF)),
          filled: true,
          fillColor: const Color(0xFFF8FAFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
      ),
    );
  }

  Widget _buildList(List<DisplayRate> rates, bool isLoading) {
    if (rates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 50.sp, color: Colors.grey.withValues(alpha: 0.3)),
            SizedBox(height: 2.h),
            const Text("No Currencies Found", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ExchangeRateProvider>().fetchRates(),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 10.h),
        itemCount: rates.length,
        separatorBuilder: (_, _) => SizedBox(height: 1.5.h),
        itemBuilder: (context, index) {
          final rate = rates[index];
          final isUp = rate.isUp;
          final color = isUp ? Colors.green : Colors.red;

          return _buildRateCard(rate, color, isUp);
        },
      ),
    );
  }

  Widget _buildRateCard(DisplayRate rate, Color color, bool isUp) {
    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5FFF).withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: const Color(0xFF1E5FFF).withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          // FLAG/ICON
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                _getCurrencyEmoji(rate.currency),
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          
          // NAMES
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rate.currency,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF030E30),
                  ),
                ),
                Text(
                  "1 Unit to INR",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // VALUES
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${rate.value.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF030E30),
                ),
              ),
              Row(
                children: [
                  Icon(
                    isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: color,
                    size: 18.sp,
                  ),
                  Text(
                    "${rate.diffPercent.abs().toStringAsFixed(2)}%",
                    style: TextStyle(
                      color: color,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCurrencyEmoji(String code) {
    final Map<String, String> emojis = {
      'USD': '🇺🇸', 'EUR': '🇪🇺', 'GBP': '🇬🇧', 'JPY': '🇯🇵', 'AED': '🇦🇪',
      'CNY': '🇨🇳', 'SAR': '🇸🇦', 'CAD': '🇨🇦', 'AUD': '🇦🇺', 'SGD': '🇸🇬',
      'INR': '🇮🇳', 'RUB': '🇷🇺', 'KRW': '🇰🇷', 'CHF': '🇨🇭', 'NZD': '🇳🇿',
      'HKD': '🇭🇰', 'IDR': '🇮🇩', 'MYR': '🇲🇾', 'THB': '🇹🇭', 'VND': '🇻🇳',
    };
    return emojis[code] ?? '💰';
  }
}
