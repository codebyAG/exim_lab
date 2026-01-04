import 'package:exim_lab/common/widgets/language_switch.dart';
import 'package:exim_lab/features/certificates/presentation/screens/certificates_screen.dart';
import 'package:exim_lab/features/chatai/presentation/screens/ai_chat_screen.dart';
import 'package:exim_lab/features/resources/presentation/screens/resource_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppNavigator.push(context, const AiChatScreen());
        },
        backgroundColor: const Color(0xFFFF8A00),
        elevation: 6,
        tooltip: t.translate('ai_support'),

        child: const Icon(Icons.support_agent, color: Colors.white),
      ),

      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 HEADER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F2A44),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOP ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.translate('app_name'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            LanguageSwitch(),
                            SizedBox(width: 10),
                            Icon(Icons.notifications_none, color: Colors.white),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      t.translate('welcome_back'),
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      t.translate('dashboard_title'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      t.translate('dashboard_subtitle'),
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 CTA CARD (IMPROVED)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8A00), Color(0xFFFFB347)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.translate('cta_title'),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  t.translate('cta_subtitle'),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          ElevatedButton(
                            onPressed: () {
                              AppNavigator.push(
                                context,
                                const CoursesListScreen(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFFF8A00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              t.translate('start_learning'),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔍 GLOBAL SEARCH BAR
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: GestureDetector(
                  onTap: () {
                    // TODO: Navigate to Search Screen later
                    // AppNavigator.push(context, const SearchScreen());
                  },
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            t.translate('search_hint'),
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        Icon(
                          Icons.tune,
                          color: Colors.grey,
                        ), // optional filter icon
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 QUICK ACTIONS
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _QuickCard(
                      icon: Icons.video_library_outlined,
                      title: t.translate('my_courses'),
                      subtitle: t.translate('completed_status'),
                      onTap: () {
                        AppNavigator.push(context, const CoursesListScreen());
                      },
                    ),
                    SizedBox(width: 12),
                    _QuickCard(
                      icon: Icons.description_outlined,
                      title: t.translate('resources'),

                      subtitle: t.translate('guides_docs'),

                      onTap: () {
                        AppNavigator.push(context, const ResourcesScreen());
                      },
                    ),
                    SizedBox(width: 12),
                    _QuickCard(
                      icon: Icons.verified_outlined,
                      title: t.translate('certificates'),

                      subtitle: t.translate('track_progress'),

                      onTap: () {
                        AppNavigator.push(context, const CertificatesScreen());
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // 🔹 CONTINUE WATCHING
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.translate('continue_watching'),

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.translate('continue_subtitle'),

                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.play_circle_fill,
                              size: 36,
                              color: Color(0xFFFF8A00),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Export Basics – Lesson 3',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6),
                                LinearProgressIndicator(
                                  value: 0.65,
                                  minHeight: 6,
                                  backgroundColor: Color(0xFFE5E7EB),
                                  color: Color(0xFFFF8A00),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  '65% completed',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF8A00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(t.translate('resume')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 MOST POPULAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.translate('most_popular'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      t.translate('most_popular_subtitle'),
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: const [
                    _CourseCard(
                      title: 'Export Documentation Mastery',
                      rating: '4.9',
                      learners: '3.2k',
                    ),
                    SizedBox(width: 14),
                    _CourseCard(
                      title: 'Global Logistics & Shipping',
                      rating: '4.8',
                      learners: '2.7k',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 BECAUSE YOU WATCHED
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.translate('because_you_watched'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      t.translate('because_you_watched_subtitle'),
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: const [
                    _CourseCard(
                      title: 'Advanced Import Compliance',
                      rating: '4.7',
                      learners: '1.6k',
                    ),
                    SizedBox(width: 14),
                    _CourseCard(
                      title: 'HS Code & Classification',
                      rating: '4.8',
                      learners: '1.9k',
                    ),
                  ],
                ),
              ),

              // 🔹 RECOMMENDED
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.translate('recommended_for_you'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            AppNavigator.push(context, CoursesListScreen());
                          },
                          child: Text(t.translate('view_all')),
                        ),
                      ],
                    ),

                    SizedBox(height: 4),
                    Text(
                      t.translate('based_on_interest'),
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 COURSE CARDS
              SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: const [
                    _CourseCard(
                      title: 'Advanced Export Strategy',
                      rating: '4.8',
                      learners: '2.1k',
                    ),
                    SizedBox(width: 14),
                    _CourseCard(
                      title: 'Import Documentation Mastery',
                      rating: '4.8',
                      learners: '1.9k',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Dashboard = Home
        selectedItemColor: const Color(0xFFFF8A00),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          if (index == 0) {
            // Already on Dashboard → do nothing
            return;
          }

          if (index == 1) {
            AppNavigator.push(context, const CoursesListScreen());
          }

          if (index == 2) {
            AppNavigator.push(context, const ResourcesScreen());
          }
        },

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: t.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: t.translate('courses'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: t.translate('resources'),
          ),
        ],
      ),
    );
  }
}

// 🔹 QUICK CARD
class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _QuickCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,

        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            children: [
              Icon(icon, size: 28, color: const Color(0xFFFF8A00)),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔹 COURSE CARD
class _CourseCard extends StatelessWidget {
  final String title;
  final String rating;
  final String learners;

  const _CourseCard({
    required this.title,
    required this.rating,
    required this.learners,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_outline, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '$rating • $learners ${t.translate('learners')}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8A00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(t.translate('unlock')),
            ),
          ),
        ],
      ),
    );
  }
}
