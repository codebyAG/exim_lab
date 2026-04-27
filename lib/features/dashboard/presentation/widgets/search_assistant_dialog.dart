import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/tools/presentation/screens/cbm_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/export_price_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/hsn_finder_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/import_calculator_screen.dart';
import 'package:exim_lab/features/quiz/presentation/screens/quiz_topics_screen.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchAssistantDialog extends StatefulWidget {
  const SearchAssistantDialog({super.key});

  @override
  State<SearchAssistantDialog> createState() => _SearchAssistantDialogState();
}

class _SearchAssistantDialogState extends State<SearchAssistantDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _results = [];

  final List<Map<String, dynamic>> _searchIndex = [
    {
      'title': 'Export Price Calculator',
      'keywords': ['export', 'pricing', 'calc', 'profit', 'price'],
      'screen': const ExportPriceCalculatorScreen(),
      'type': 'TOOL',
      'icon': Icons.calculate_rounded,
    },
    {
      'title': 'Import Calculator',
      'keywords': ['import', 'duty', 'calc', 'cost'],
      'screen': const ImportCalculatorScreen(),
      'type': 'TOOL',
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'title': 'HSN Code Finder',
      'keywords': ['hsn', 'code', 'harmonized', 'search'],
      'screen': const HsnFinderScreen(),
      'type': 'TOOL',
      'icon': Icons.search_rounded,
    },
    {
      'title': 'CBM Calculator',
      'keywords': ['cbm', 'volume', 'weight', 'shipping', 'box'],
      'screen': const CbmCalculatorScreen(),
      'type': 'TOOL',
      'icon': Icons.view_in_ar_rounded,
    },
    {
      'title': 'Quizzes & Testing',
      'keywords': ['quiz', 'test', 'exam', 'knowledge', 'practice'],
      'screen': const QuizTopicsScreen(),
      'type': 'LEARN',
      'icon': Icons.psychology_rounded,
    },
    {
       'title': 'All Courses',
      'keywords': ['course', 'learn', 'video', 'module', 'training'],
      'screen': const CoursesListScreen(),
      'type': 'LEARN',
      'icon': Icons.school_rounded,
    },
  ];

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() {
      _results = _searchIndex.where((item) {
        final title = item['title'].toString().toLowerCase();
        final keywords = (item['keywords'] as List).join(' ').toLowerCase();
        return title.contains(query.toLowerCase()) || 
               keywords.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF020C28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            // HEADER
            Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, color: Color(0xFFFFD000)),
                SizedBox(width: 2.w),
                Text(
                  "Smart Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16.sp,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // SEARCH BAR
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "What are you looking for?",
                hintStyle: const TextStyle(color: Colors.white30),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1E5FFF)),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // RESULTS
            Expanded(
              child: _results.isEmpty && _searchController.text.isNotEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final item = _results[index];
                        return _buildResultItem(item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
          AppNavigator.push(context, item['screen']);
        },
        tileColor: Colors.white.withValues(alpha: 0.03),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E5FFF).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item['icon'], color: const Color(0xFF1E5FFF)),
        ),
        title: Text(
          item['title'],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          item['type'],
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, color: Colors.white24, size: 48),
          SizedBox(height: 1.h),
          const Text(
            "Try searching 'HSN' or 'Import'",
            style: TextStyle(color: Colors.white24),
          ),
        ],
      ),
    );
  }
}
