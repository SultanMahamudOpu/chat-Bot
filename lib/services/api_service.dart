import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String _apiKey = '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'; // Replace with a secure way to store API keys

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'openai/gpt-3.5-turbo', // Use a valid model
          'messages': [
            {'role': 'user', 'content': message}
          ],
          'temperature': 0.7, // Optional, controls randomness
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        print('API Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed API request: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in sendMessage: $e');
      throw Exception('Failed to send message: $e');
    }
  }
}
