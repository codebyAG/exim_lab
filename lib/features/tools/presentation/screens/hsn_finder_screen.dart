import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/localization/app_localization.dart';

class HsnFinderScreen extends StatefulWidget {
  const HsnFinderScreen({super.key});

  @override
  State<HsnFinderScreen> createState() => _HsnFinderScreenState();
}

class _HsnFinderScreenState extends State<HsnFinderScreen> {
  final _searchController = TextEditingController();
  List<Map<String, String>> _filteredChapters = _allChapters;

  static const List<Map<String, String>> _allChapters = [
    {'code': '01-05', 'title': 'Live Animals & Animal Products'},
    {'code': '06-14', 'title': 'Vegetable Products'},
    {'code': '15', 'title': 'Animal or Vegetable Fats & Oils'},
    {'code': '16-24', 'title': 'Prepared Foodstuffs, Beverages, Spirits, Tobacco'},
    {'code': '25-27', 'title': 'Mineral Products'},
    {'code': '28-38', 'title': 'Products of Chemical & Allied Industries'},
    {'code': '39-40', 'title': 'Plastics & Rubber Articles'},
    {'code': '41-43', 'title': 'Raw Hides, Skins, Leather, Furs'},
    {'code': '44-46', 'title': 'Wood, Cork, Straw Articles'},
    {'code': '47-49', 'title': 'Paper, Pulp & Paperboard Articles'},
    {'code': '50-63', 'title': 'Textiles & Textile Articles'},
    {'code': '64-67', 'title': 'Footwear, Headgear, Umbrellas'},
    {'code': '68-70', 'title': 'Stone, Plaster, Cement, Glass Articles'},
    {'code': '71', 'title': 'Pearls, Precious Stones, Metals, Jewelry'},
    {'code': '72-83', 'base': 'Base Metals & Articles of Base Metal'},
    {'code': '84-85', 'title': 'Machinery & Mechanical Appliances, Electrical Eq.'},
    {'code': '86-89', 'title': 'Vehicles, Aircraft, Vessels & Transport Eq.'},
    {'code': '90-92', 'title': 'Optical, Photographic, Musical Instruments'},
    {'code': '93', 'title': 'Arms & Ammunition'},
    {'code': '94-96', 'title': 'Miscellaneous Manufactured Articles'},
    {'code': '97-98', 'title': 'Works of Art, Collectors\' Pieces & Antiques'},
  ];

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChapters = _allChapters;
      } else {
        _filteredChapters = _allChapters.where((chapter) {
          final title = (chapter['title'] ?? chapter['base'] ?? '').toLowerCase();
          final code = chapter['code']?.toLowerCase() ?? '';
          return title.contains(query.toLowerCase()) || code.contains(query.toLowerCase());
        }).toList();
      }
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
        title: Text(t.translate('tool_hsn_finder')),
        backgroundColor: cs.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(5.w),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search Chapter or Description...",
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.05),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              itemCount: _filteredChapters.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
              itemBuilder: (context, index) {
                final item = _filteredChapters[index];
                return _buildChapterCard(item, cs, theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(Map<String, String> item, ColorScheme cs, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: cs.shadow.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item['code'] ?? '',
              style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold, fontSize: 13.sp),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              item['title'] ?? item['base'] ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: cs.onSurface),
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }
}
