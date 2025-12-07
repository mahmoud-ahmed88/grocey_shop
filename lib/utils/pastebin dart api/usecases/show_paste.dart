import 'package:http/http.dart' as http;
import 'package:product_shop/config/core/api/api.dart';

Future<String> showPaste({
  required String pasteKey,
  String? pastePassword,
}) async {
  final uri = Uri.https('pastebin.com', '/api/api_raw.php');

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'api_dev_key': Api.primaryApiDevKey,
        'api_user_key': Api.apiUserKey,
        'api_paste_key': pasteKey,
        'api_option': 'show_paste',
        if (pastePassword != null) 'api_paste_password': pastePassword,
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    }

    throw Exception('Pastebin API error ${response.statusCode}: ${response.body}');
  } catch (e) {
    throw Exception('Failed to fetch paste: $e');
  }
}
