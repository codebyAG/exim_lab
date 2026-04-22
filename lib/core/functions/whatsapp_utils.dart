import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;

class WhatsAppUtils {
  static const String _phoneNumber = "919871769042";

  static Future<void> launch({required String message}) async {
    final encodedMessage = Uri.encodeComponent(message);
    final url = "https://wa.me/$_phoneNumber?text=$encodedMessage";
    
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        developer.log("❌ Could not launch WhatsApp. URL: $url", name: "WHATSAPP_UTILS");
      }
    } catch (e) {
      developer.log("❌ Error launching WhatsApp: $e", name: "WHATSAPP_UTILS");
    }
  }
}
