import 'package:flutter/material.dart';
import 'package:exim_lab/features/premium/presentation/screens/premium_features_screen.dart';
import 'package:exim_lab/features/one_on_one/presentation/screens/one_on_one_screen.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
import 'package:exim_lab/features/shorts/presentation/screens/shorts_feed_screen.dart';
import 'package:exim_lab/features/chat/presentation/screens/community_chat_screen.dart';
import 'package:exim_lab/features/quiz/presentation/screens/quiz_topics_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/all_tools_screen.dart';
import 'package:exim_lab/features/gallery/presentation/screens/gallery_screen.dart';
import 'package:exim_lab/features/profile/presentation/screens/profile_screen.dart';
import 'package:exim_lab/features/journey/presentation/screens/import_journey_screen.dart';
import 'package:exim_lab/features/journey/presentation/screens/export_journey_screen.dart';
import 'package:exim_lab/features/chatai/presentation/screens/consultation_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/export_price_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/import_calculator_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/cbm_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/gst_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/hsn_finder_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/forex_converter_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/forex_rates_list_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/gov_benefits_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/incoterms_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/product_cert_screen.dart';

/// Resolves a banner's `ctaUrl`/`linkUrl` to an internal page push, using
/// the same `scheme://path` convention as [NotificationRouter] (e.g.
/// `premium://premium-features`).
///
/// Deliberately limited to pages that need no extra admin-picked item
/// (a specific course/news article/etc.) — those need an item-picker on
/// the admin side that doesn't exist yet, so they're not wired here.
class InternalLinkRouter {
  InternalLinkRouter._();

  static final Map<String, WidgetBuilder> _routes = {
    'premium://premium-features': (_) => const PremiumFeaturesScreen(),
    'one-on-one://one-on-one': (_) => const OneOnOneScreen(),
    'courses://list': (_) => const CoursesListScreen(),
    'news://list': (_) => const NewsListScreen(),
    'shorts://feed': (_) => const ShortsFeedScreen(),
    'community://chat': (_) => const CommunityChatScreen(),
    'quiz://topics': (_) => const QuizTopicsScreen(),
    'tools://all': (_) => const AllToolsScreen(),
    'gallery://home': (_) => const GalleryScreen(),
    'profile://me': (_) => const ProfileScreen(),
    'journey://import': (_) => const ImportJourneyScreen(),
    'journey://export': (_) => const ExportJourneyScreen(),
    'consultation://book': (_) => const ConsultationScreen(),
    'tools://export-price': (_) => const ExportPriceCalculatorScreen(),
    'tools://import-calc': (_) => const ImportCalculatorScreen(),
    'tools://cbm': (_) => const CbmCalculatorScreen(),
    'tools://gst': (_) => const GstCalculatorScreen(),
    'tools://hsn-finder': (_) => const HsnFinderScreen(),
    'tools://forex': (_) => const ForexConverterScreen(),
    'tools://forex-rates': (_) => const ForexRatesListScreen(),
    'tools://gov-benefits': (_) => const GovBenefitsScreen(),
    'tools://incoterms': (_) => const IncotermsScreen(),
    'tools://product-cert': (_) => const ProductCertScreen(),
  };

  static bool isInternalLink(String link) => _routes.containsKey(link.trim());

  /// Pushes the matching internal page and returns true, or returns false
  /// (without navigating) so the caller can fall back to launching [link]
  /// externally instead.
  static bool tryOpen(BuildContext context, String link) {
    final builder = _routes[link.trim()];
    if (builder == null) return false;
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
    return true;
  }
}
