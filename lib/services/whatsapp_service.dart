import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> sendWhatsAppMessage(String phoneNumber, String message) async {
    final encodedMessage = Uri.encodeComponent(message);
    final url = "https://wa.me/$phoneNumber?text=$encodedMessage";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw "Não foi possível abrir o WhatsApp";
    }
  }
}
