import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:exim_lab/localization/app_localization.dart';

class PremiumBottomBar extends StatelessWidget {
  final List<DashboardNavItem> items;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const PremiumBottomBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    
    return Container(
      width: 100.w,
      height: 12.h, // Increased further to prevent remaining 12px overflow
      decoration: BoxDecoration(
        color: const Color(0xFF020C28), // Deep Navy from HTML
        border: Border(
          top: BorderSide(
            color: const Color(0xFF1E5FFF).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = selectedIndex == index;
              
              return _BottomBarItem(
                item: item,
                isSelected: isSelected,
                label: t.translate(item.labelKey),
                onTap: () => onItemSelected(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final DashboardNavItem item;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  const _BottomBarItem({
    required this.item,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h), // Reduced from 0.8.h
        decoration: BoxDecoration(
          color: isSelected 
            ? const Color(0xFF1E5FFF).withValues(alpha: 0.18) 
            : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(item.identifier, isSelected),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF1E5FFF) : const Color(0xFF7A90C4),
                  fontSize: 9.5.sp,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  fontFamily: 'Plus Jakarta Sans',
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(String identifier, bool isSelected) {
    switch (identifier) {
      case 'home':
        return Text('🏠', style: TextStyle(fontSize: 18.sp));
      case 'shorts':
        return Text('⚡', style: TextStyle(fontSize: 18.sp));
      case 'courses':
        return Text('🎓', style: TextStyle(fontSize: 18.sp));
      case 'profile':
        return Text('👤', style: TextStyle(fontSize: 18.sp));
      case 'news':
        return Icon(
          isSelected ? Icons.newspaper : Icons.newspaper_rounded,
          color: isSelected ? const Color(0xFF1E5FFF) : const Color(0xFF7A90C4),
          size: 18.sp,
        );
      default:
        return Icon(
          isSelected ? Icons.circle : Icons.circle_outlined,
          color: isSelected ? const Color(0xFF1E5FFF) : const Color(0xFF7A90C4),
          size: 18.sp,
        );
    }
  }
}
