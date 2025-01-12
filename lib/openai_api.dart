import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey;

  OpenAIService({required this.apiKey});

  Future<String> getResponse(String prompt) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    // Το σώμα του αιτήματος για chat-based μοντέλα
    final body = json.encode({
      'model': 'gpt-3.5-turbo', // Χρησιμοποίησε το σωστό μοντέλο
      'messages': [
        {
          'role': 'system', // Ο ρόλος του συστήματος
          'content': 'You are a helpful assistant.'
        },
        {
          'role': 'user', // Ο ρόλος του χρήστη
          'content': prompt
        },
      ],
      'max_tokens': 100, // Περιορισμός της απάντησης
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']
            ['content']; // Εξαγωγή της απάντησης
      } else {
        print('Σφάλμα HTTP: ${response.statusCode}');
        print('Απάντηση API: ${response.body}');
        return 'Σφάλμα: ${response.body}';
      }
    } catch (e) {
      print('Σφάλμα δικτύου: $e');
      return 'Σφάλμα στην επικοινωνία με το API';
    }
  }
}
//gpt-4o-mini
//https://api.openai.com/v1/chat/completions