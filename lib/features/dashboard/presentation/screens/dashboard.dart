import 'package:exim_lab/common/widgets/language_switch.dart';
import 'package:exim_lab/common/widgets/promo_banner_dialog.dart';
import 'package:exim_lab/common/widgets/theme_switch_button.dart';
import 'package:exim_lab/features/certificates/presentation/screens/certificates_screen.dart';
import 'package:exim_lab/features/chatai/presentation/screens/ai_chat_screen.dart';
import 'package:exim_lab/features/cto_banners/presentations/screens/random_cto_banner.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/animated_search_bar.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/continue_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/course_of_the_day.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/cta_carasoul.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/horizontal_courses.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/live_seminar_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/quick_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/section_header.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/tool_section.dart';
import 'package:exim_lab/features/freevideos/presentation/widgets/free_video_section.dart';
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
import 'package:exim_lab/features/resources/presentation/screens/resource_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';
import 'package:sizer/sizer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));
      _showPromoBanner();
    });
  }

  void _showPromoBanner() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const PromoBannerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,

      // Floating AI Support Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: cs.primary,
        tooltip: t.translate('ai_support'),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          AppNavigator.push(context, const AiChatScreen());
        },
        child: Icon(Icons.support_agent, color: cs.onPrimary, size: 28),
      ),

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ================= HEADER =================
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(3.w, 2.h, 3.w, 1.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.translate('welcome_back'),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                t.translate(
                                  'dashboard_title',
                                ), // Assuming this is User Name or Title
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: cs.onSurface,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Utility Buttons
                        const Row(children: [LanguageSwitch()]),
                      ],
                    ),
                    SizedBox(height: 3.h),

                    // Search Bar
                    AnimatedSearchBar(
                      hints: [
                        t.translate('search_hint'),
                        'Search IEC, GST, HS Code',
                        'Find import–export courses',
                        'Read trade policy updates',
                        'Check required documents',
                      ],
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // ================= CONTENT BODY =================
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // CTA Carousel
                  const CtaCarousel(),
                  SizedBox(height: 3.h),

                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: QuickCard(
                          icon: Icons.video_library_rounded,
                          title: t.translate('my_courses'),
                          subtitle: t.translate('completed_status'),
                          onTap: () {
                            AppNavigator.push(
                              context,
                              const CoursesListScreen(),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: QuickCard(
                          icon: Icons.folder_copy_rounded,
                          title: t.translate('resources'),
                          subtitle: t.translate('guides_docs'),
                          onTap: () {
                            AppNavigator.push(context, const ResourcesScreen());
                          },
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: QuickCard(
                          icon: Icons.workspace_premium_rounded,
                          title: t.translate('certificates'),
                          subtitle: t.translate('track_progress'),
                          onTap: () {
                            AppNavigator.push(
                              context,
                              const CertificatesScreen(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Seminar Card
                  LiveSeminarCard(
                    title: 'Export Compliance & Documentation',
                    subtitle: 'Live with Trade Expert',
                    dateTime: '20 Jan • 6:00 PM',
                    onTap: () {},
                  ),

                  SizedBox(height: 4.h),

                  // Free Videos
                  SectionHeader(
                    title: 'Free Videos',
                    subtitle: 'Watch & learn instantly',
                  ),
                  SizedBox(height: 1.5.h),
                  const FreeVideosSection(),

                  SizedBox(height: 4.h),

                  // Tools
                  const SectionHeader(
                    title: 'Tools',
                    subtitle: 'Everything you need in one place',
                  ),
                  SizedBox(height: 1.5.h),
                  const ToolsSection(),

                  SizedBox(height: 4.h),

                  // Continue Watching
                  SectionHeader(
                    title: t.translate('continue_watching'),
                    subtitle: t.translate('continue_subtitle'),
                  ),
                  SizedBox(height: 1.5.h),
                  ContinueCard(),

                  SizedBox(height: 3.h),
                  const RandomCtoBanner(),

                  SizedBox(height: 3.h),

                  // Most Popular
                  SectionHeader(
                    title: t.translate('most_popular'),
                    subtitle: t.translate('most_popular_subtitle'),
                  ),
                  SizedBox(height: 1.5.h),
                  const HorizontalCourses(),

                  SizedBox(height: 4.h),

                  // Course of the Day
                  CourseOfTheDayCard(
                    title: 'Import Export Basics',
                    subtitle: 'Learn trade from scratch',
                    priceText: '₹999',
                    badgeText: 'Limited time',
                    imagePath: 'assets/coursegirl.png',
                    onTap: () {},
                  ),

                  SizedBox(height: 4.h),

                  // Because You Watched
                  SectionHeader(
                    title: t.translate('because_you_watched'),
                    subtitle: t.translate('because_you_watched_subtitle'),
                  ),
                  const HorizontalCourses(),

                  SizedBox(height: 3.h),
                  const RandomCtoBanner(),

                  SizedBox(height: 3.h),

                  // Recommended
                  SectionHeader(
                    title: t.translate('recommended_for_you'),
                    subtitle: t.translate('based_on_interest'),
                    trailing: TextButton(
                      onPressed: () {
                        AppNavigator.push(context, const CoursesListScreen());
                      },
                      child: Text(t.translate('view_all')),
                    ),
                  ),
                  const HorizontalCourses(),

                  SizedBox(height: 10.h), // Bottom Spacing
                ]),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: cs.surface,
          elevation: 0,
          selectedItemColor: cs.primary,
          unselectedItemColor: cs.onSurfaceVariant.withOpacity(0.6),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10.sp,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10.sp,
          ),
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 1) {
              AppNavigator.push(context, const CoursesListScreen());
            } else if (index == 2) {
              AppNavigator.push(context, const NewsListScreen());
            } else if (index == 3) {
              AppNavigator.push(context, const ResourcesScreen());
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              activeIcon: const Icon(Icons.home_filled),
              label: t.translate('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.play_circle_outline_rounded),
              activeIcon: const Icon(Icons.play_circle_filled_rounded),
              label: t.translate('courses'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.newspaper_rounded),
              activeIcon: const Icon(Icons.newspaper),
              label: t.translate('news'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.folder_open_rounded),
              activeIcon: const Icon(Icons.folder_rounded),
              label: t.translate('resources'),
            ),
          ],
        ),
      ),
    );
  }
}
