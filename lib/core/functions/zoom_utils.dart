import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;

/// Opens a Zoom meeting link externally — no Zoom SDK needed. A
/// https://zoom.us/j/... URL is a normal app-link: if the Zoom app is
/// installed, the OS hands it straight to Zoom; if not, it opens the
/// meeting in the browser instead. Same pattern as [WhatsAppUtils].
class ZoomUtils {
  static Future<void> launchMeeting(String meetingUrl) async {
    if (meetingUrl.isEmpty) {
      developer.log("❌ Empty Zoom meeting URL", name: "ZOOM_UTILS");
      return;
    }
    try {
      final uri = Uri.parse(meetingUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        developer.log(
          "❌ Could not launch Zoom meeting. URL: $meetingUrl",
          name: "ZOOM_UTILS",
        );
      }
    } catch (e) {
      developer.log("❌ Error launching Zoom meeting: $e", name: "ZOOM_UTILS");
    }
  }
}
