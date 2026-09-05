import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:exim_lab/features/news/presentation/screens/news_details_screen.dart';
import 'package:exim_lab/features/premium/presentation/screens/premium_features_screen.dart';
import 'package:exim_lab/features/one_on_one/presentation/screens/one_on_one_screen.dart';
import 'package:exim_lab/features/seminar/presentation/screens/webinar_detail_screen.dart';
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

/// Routes notification taps (FCM / local / in-app list) to the right screen.
///
/// Expected payload keys from backend:
///   `{ "type": "news", "newsId": "..." }`
/// In-app notifications may instead carry linkUrl: `news://id`.
class NotificationRouter {
  NotificationRouter._();

  /// Global key wired into [MaterialApp] so we can navigate without context.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Route based on a data payload (FCM `message.data` or awesome payload).
  static void routeFromData(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return;

    final type = data['type']?.toString();
    if (type == 'news') {
      final id = data['newsId']?.toString();
      if (id != null && id.isNotEmpty) {
        openNewsDetails(id);
      }
    } else if (type == 'premium') {
      openPremiumFeatures();
    } else if (type == 'one-on-one') {
      openOneOnOne();
    } else if (type == 'webinar') {
      final id = data['seminarId']?.toString();
      if (id != null && id.isNotEmpty) {
        openWebinarDetail(id);
      }
    } else if (type != null) {
      final builder = _simplePageRoutes[type];
      if (builder != null) {
        navigatorKey.currentState?.push(MaterialPageRoute(builder: builder));
      }
    }
  }

  /// Looks up a no-extra-data page by `type`, for the in-app notification
  /// list screen (which navigates via its own `context`, not
  /// [navigatorKey]) to use as a fallback after its bespoke
  /// news/premium/one-on-one/webinar checks.
  static WidgetBuilder? simplePageBuilder(String? type) =>
      type == null ? null : _simplePageRoutes[type];

  /// Pages that need no extra data beyond the `type` itself — same set the
  /// dashboard banners support via `InternalLinkRouter`, kept as separate
  /// entries here since notifications route by `type`, not a `linkUrl`
  /// string. `news`/`premium`/`one-on-one`/`webinar` are handled above and
  /// intentionally not duplicated here.
  static final Map<String, WidgetBuilder> _simplePageRoutes = {
    'courses': (_) => const CoursesListScreen(),
    'news-list': (_) => const NewsListScreen(),
    'shorts': (_) => const ShortsFeedScreen(),
    'community': (_) => const CommunityChatScreen(),
    'quiz': (_) => const QuizTopicsScreen(),
    'tools': (_) => const AllToolsScreen(),
    'gallery': (_) => const GalleryScreen(),
    'profile': (_) => const ProfileScreen(),
    'import-journey': (_) => const ImportJourneyScreen(),
    'export-journey': (_) => const ExportJourneyScreen(),
    'consultation': (_) => const ConsultationScreen(),
    'tool-export-price': (_) => const ExportPriceCalculatorScreen(),
    'tool-import-calc': (_) => const ImportCalculatorScreen(),
    'tool-cbm': (_) => const CbmCalculatorScreen(),
    'tool-gst': (_) => const GstCalculatorScreen(),
    'tool-hsn-finder': (_) => const HsnFinderScreen(),
    'tool-forex': (_) => const ForexConverterScreen(),
    'tool-forex-rates': (_) => const ForexRatesListScreen(),
    'tool-gov-benefits': (_) => const GovBenefitsScreen(),
    'tool-incoterms': (_) => const IncotermsScreen(),
    'tool-product-cert': (_) => const ProductCertScreen(),
  };

  /// Extract a news id from an in-app notification linkUrl (`news://id`).
  static String? newsIdFromLink(String? linkUrl) {
    if (linkUrl == null) return null;
    if (linkUrl.startsWith('news://')) {
      final id = linkUrl.substring('news://'.length).trim();
      return id.isEmpty ? null : id;
    }
    return null;
  }

  /// `linkUrl` for a premium-features deep link, e.g. `premium://premium-features`.
  static bool isPremiumLink(String? linkUrl) =>
      linkUrl != null && linkUrl.startsWith('premium://');

  /// `linkUrl` for a one-on-one deep link, e.g. `one-on-one://one-on-one`.
  static bool isOneOnOneLink(String? linkUrl) =>
      linkUrl != null && linkUrl.startsWith('one-on-one://');

  /// Extract a seminar id from an in-app notification linkUrl
  /// (`webinar://<seminarId>`) — fallback only; prefer `data.seminarId`
  /// directly when available, since this scheme isn't itself openable.
  static String? seminarIdFromLink(String? linkUrl) {
    if (linkUrl == null) return null;
    if (linkUrl.startsWith('webinar://')) {
      final id = linkUrl.substring('webinar://'.length).trim();
      return id.isEmpty ? null : id;
    }
    return null;
  }

  static void openNewsDetails(String newsId) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => NewsDetailScreen(newsId: newsId),
      ),
    );
  }

  static void openPremiumFeatures() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const PremiumFeaturesScreen()),
    );
  }

  static void openOneOnOne() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const OneOnOneScreen()),
    );
  }

  static void openWebinarDetail(String seminarId) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => WebinarDetailScreen(seminarId: seminarId),
      ),
    );
  }

  /// AwesomeNotifications tap listener (local notifications shown by
  /// FirebaseMessagingService carry the FCM data as payload).
  @pragma('vm:entry-point')
  static Future<void> onActionReceived(ReceivedAction action) async {
    routeFromData(action.payload);
  }
}
