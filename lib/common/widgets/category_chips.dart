import 'package:flutter/material.dart';

/// Reusable horizontal category filter chips (mockup style).
/// Purely a selection control — the parent decides what selection means via
/// [onSelected]. The first chip is selected by default.
class CategoryChips extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<int>? onSelected;
  final EdgeInsetsGeometry padding;

  const CategoryChips({
    super.key,
    required this.categories,
    this.onSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int _selected = 0;

  static const Color _blue = Color(0xFF1E5FFF);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: widget.padding,
        itemCount: widget.categories.length,
        separatorBuilder: (context, i) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final bool isActive = _selected == index;
          return GestureDetector(
            onTap: () {
              setState(() => _selected = index);
              widget.onSelected?.call(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isActive ? _blue : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isActive
                      ? _blue
                      : const Color(0xFF94A3B8).withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isActive ? _blue : Colors.black).withValues(
                      alpha: 0.12,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                widget.categories[index],
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF334155),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
