import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>?> fetchSmartphoneRecommendation(
    String query,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.42.120:4000/api/query'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": query}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }
}