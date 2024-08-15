import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'api_service.dart';

void main() async {
  final logger = Logger();

  try {
    await dotenv.load(fileName: ".env");
    logger.i("Environment variables loaded");

    final apiService = ApiService();

    // Example of using the API service
    final response = await apiService.getAiResponse("Hello, OpenAI!");
    logger.i("Received AI response: $response");
  } catch (e) {
    logger.e("Error occurred: $e");
  }
}
