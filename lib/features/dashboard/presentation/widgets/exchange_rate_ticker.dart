import 'dart:async';
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
        final rates = provider.data?.getDisplayRates() ?? [];
        
        if (rates.isEmpty && !provider.isLoading) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF01081C).withValues(alpha: 0.95),
                const Color(0xFF021B4B),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            border: const Border(
              bottom: BorderSide(
                color: Color(0xFF1E5FFF),
                width: 1.0,
              ),
            ),
          ),
          child: provider.isLoading
              ? _buildLoadingState()
              : _buildScrollingList(rates),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
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
      physics: const NeverScrollableScrollPhysics(), // Handled by timer
      itemCount: displayList.length,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      itemBuilder: (context, index) {
        final rate = displayList[index];
        final color = rate.isUp ? Colors.greenAccent : Colors.redAccent;
        final icon = rate.isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rate.symbol,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                rate.value.toStringAsFixed(2),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Plus Jakarta Sans',
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 1.5.w),
              Icon(
                icon,
                color: color,
                size: 20.sp,
              ),
              Text(
                "${rate.diffPercent.abs().toStringAsFixed(2)}%",
                style: TextStyle(
                  color: color,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                "•",
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
