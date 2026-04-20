import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/exchange_rate_provider.dart';
import 'package:sizer/sizer.dart';

class ExchangeRateTicker extends StatelessWidget {
  const ExchangeRateTicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExchangeRateProvider>(
      builder: (context, provider, child) {
        final rates = provider.rates?.getDisplayRates() ?? [];
        
        if (rates.isEmpty && !provider.isLoading) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 44,
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
                width: 0.8,
              ),
            ),
          ),
          child: provider.isLoading
              ? _buildLoadingState()
              : _buildMarquee(rates),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFFFFD000), // Matching premium yellow
        ),
      ),
    );
  }

  Widget _buildMarquee(List<dynamic> rates) {
    // 🌍 Stylish item construction
    final String content = rates.map((r) {
      return "🔹 ${r.symbol}  ${r.value.toStringAsFixed(2)}";
    }).join("    •    ");

    return Marquee(
      text: "    $content    •    ",
      style: TextStyle(
        color: Colors.white,
        fontSize: 13.sp, // Even bigger
        fontWeight: FontWeight.w900, // Extra Bold
        fontFamily: 'Plus Jakarta Sans',
        letterSpacing: 0.8,
        shadows: [
          Shadow(
            color: const Color(0xFF1E5FFF).withValues(alpha: 0.5),
            blurRadius: 8,
          ),
        ],
      ),
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      blankSpace: 60.0,
      velocity: 40.0, // Slightly faster for style
      pauseAfterRound: const Duration(seconds: 1),
      startPadding: 10.0,
      accelerationDuration: const Duration(milliseconds: 500),
      accelerationCurve: Curves.linear,
      decelerationDuration: const Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
    );
  }
}
