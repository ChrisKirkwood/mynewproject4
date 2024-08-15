import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String apiKeyGoogle = dotenv.env['GOOGLE_APP_CRED_ATHENA']!;
  final String apiKeyOpenAI = dotenv.env['OPENAI_ATHENA']!;
  final Logger logger = Logger();

  Future<String> getAiResponse(String query) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Authorization': 'Bearer $apiKeyOpenAI',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': query,
          'max_tokens': 100,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['text'];
      } else {
        logger.e('Failed to get AI response: ${response.statusCode}');
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      logger.e('Error getting AI response: $e');
      throw Exception('Error getting AI response');
    }
  }

  Future<void> someGoogleApiFunction() async {
    // Example function for Google API
    try {
      // Your Google API logic here
    } catch (e) {
      logger.e('Error in Google API function: $e');
    }
  }
}
