import 'dart:async';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/tools/presentation/screens/forex_rates_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/exchange_rate_provider.dart';
import 'package:exim_lab/features/dashboard/data/models/exchange_rate_model.dart';
import 'package:sizer/sizer.dart';

class ExchangeRateTicker extends StatefulWidget {
  const ExchangeRateTicker({super.key});

  @override
  State<ExchangeRateTicker> createState() => _ExchangeRateTickerState();
}

class _ExchangeRateTickerState extends State<ExchangeRateTicker> {
  late ScrollController _scrollController;
  Timer? _timer;

  // 🌍 Top 10 Trade Partner Currencies
  static const List<String> _popularCurrencies = [
    'USD', // USA
    'CNY', // China
    'AED', // UAE
    'SAR', // Saudi Arabia
    'EUR', // Germany/EU
    'RUB', // Russia
    'SGD', // Singapore
    'JPY', // Japan
    'GBP', // UK
    'KRW', // S. Korea
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Start automatic scrolling after a small delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;

        // Loop back to start smoothly
        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(currentScroll + 1.2);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExchangeRateProvider>(
      builder: (context, provider, child) {
        // 🔍 Filter by popular currencies
        final allRates = provider.data?.getDisplayRates() ?? [];
        final rates = allRates
            .where((rate) => _popularCurrencies.contains(rate.currency))
            .toList();

        if (rates.isEmpty && !provider.isLoading) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            AppNavigator.push(context,  ForexRatesListScreen());
          },
          child: Container(
            height: 60, // Increased height for more prominence
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF01081C).withValues(alpha: 0.95),
                  const Color(0xFF021B4B),
                ],
                begin: Alignment.topCenter, // Vertical gradient for more depth
                end: Alignment.bottomCenter,
              ),
              border: const Border(
                bottom: BorderSide(
                  color: Color(0xFF1E5FFF),
                  width: 1.5, // Thicker border
                ),
              ),
            ),
            child: provider.isLoading
                ? _buildLoadingState()
                : _buildScrollingList(rates),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: Color(0xFFFFD000),
        ),
      ),
    );
  }

  Widget _buildScrollingList(List<DisplayRate> rates) {
    // Duplicate the list several times to create a seamless infinite feel
    final displayList = [...rates, ...rates, ...rates, ...rates];
    
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(), 
      itemCount: displayList.length,
      padding: EdgeInsets.zero, // Removed external padding
      itemBuilder: (context, index) {
        final rate = displayList[index];
        final color = rate.isUp ? Colors.greenAccent : Colors.redAccent;
        final icon = rate.isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 3.5.w), // Tightened horizontal spacing
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                rate.symbol,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              SizedBox(width: 2.w), // Reduced gap
              Text(
                rate.value.toStringAsFixed(2),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Plus Jakarta Sans',
                  letterSpacing: 0.5,
                ),
              ),
              Icon(
                icon,
                color: color,
                size: 24.sp, // Slightly smaller icon to save space
              ),
              Text(
                "${rate.diffPercent.abs().toStringAsFixed(2)}%",
                style: TextStyle(
                  color: color,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              SizedBox(width: 3.5.w), // Reduced gap before separator
              Text(
                "|",
                style: TextStyle(
                  color: Colors.white10,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
