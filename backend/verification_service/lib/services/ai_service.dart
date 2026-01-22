import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dotenv/dotenv.dart';

class AiService {
  static final _env = DotEnv(includePlatformEnvironment: true)..load();
  static String get _apiKey => _env['MISTRAL_API_KEY'] ?? '';
  static String get _model => _env['MISTRAL_MODEL'] ?? 'mistral-small';
  static const String _baseUrl = 'https://api.mistral.ai/v1/chat/completions';

  /// Generates a strict JSON exam for the given topic
  Future<List<Map<String, dynamic>>> generateExam(String topic) async {
    if (_apiKey.isEmpty) {
      print('❌ Mistral API Key is missing. Check .env file.');
      throw Exception('Mistral API Key is missing');
    }

    final prompt = '''
You are the world's leading authority and expert examiner in $topic. 
Your task is to create a professional certification exam to verify a tutor's expertise.

INSTRUCTIONS:
1. Generate exactly 10 high-quality multiple-choice questions about $topic.
2. The difficulty must be a mix of Intermediate and Advanced.
3. Questions must test deep understanding, code logic, or best practices (not just syntax).
4. Provide exactly 4 options (A, B, C, D) for each question.
5. You MUST indicate the correct answer (index 0-3).

OUTPUT FORMAT:
Return ONLY a valid raw JSON array. Do not include markdown formatting (like ```json).
The JSON structure must be exactly:
[
  {
    "question": "The text of the question?",
    "options": ["Option A", "Option B", "Option C", "Option D"],
    "correctIndex": 0 // The integer index of the correct option (0, 1, 2, or 3)
  }
]
''';

    try {
      print('🤖 Requesting Exam from Mistral ($topic)...');
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
        }),
      ).timeout(Duration(seconds: 30)); // Add 30-second timeout

      if (response.statusCode != 200) {
        print('❌ Mistral API Error (${response.statusCode}): ${response.body}');
        throw Exception('Mistral API Error: ${response.body}');
      }

      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'] as String;

      print('✅ AI Response Received (${content.length} chars)');
      // print('DEBUG CONTENT: $content'); // Uncomment for deep debug

      // Clean markdown if present (Mistral might still wrap in ```json)
      String cleanJson = content.trim();
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.replaceAll('```json', '').replaceAll('```', '');
      } else if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.replaceAll('```', '');
      }
      
      cleanJson = cleanJson.trim();

      final List<dynamic> parsed = jsonDecode(cleanJson);
      return parsed.cast<Map<String, dynamic>>();

    } catch (e) {
      print('❌ AI Generation Failed: $e');
      throw Exception('Failed to generate exam: $e');
    }
  }

  /// Grades the exam based on user answers
  Future<Map<String, dynamic>> gradeExam(
    String topic,
    List<Map<String, dynamic>> questions,
    List<int> userAnswers,
  ) async {
    int score = 0;
    List<String> failedQuestions = [];

    for (var i = 0; i < questions.length; i++) {
      if (i < userAnswers.length && userAnswers[i] == questions[i]['correctIndex']) {
        score++;
      } else {
        failedQuestions.add(questions[i]['question']);
      }
    }

    final percentage = (score / questions.length) * 100;
    final passed = percentage >= 80;

    String feedback = 'Excellent work!';
    if (failedQuestions.isNotEmpty) {
      try {
        feedback = await _generateFeedback(topic, score, failedQuestions);
      } catch (e) {
        feedback = 'You scored $score/10. Review the failed topics.';
      }
    }

    return {
      'score': percentage,
      'passed': passed,
      'feedback': feedback,
    };
  }

  Future<String> _generateFeedback(String topic, int score, List<String> failedQuestions) async {
     final prompt = '''
You are a senior mentor in $topic. A student just took an exam and scored $score/10.
They failed the following questions:
${failedQuestions.map((q) => "- $q").join('\n')}

Provide brief, constructive feedback on what concepts they need to study to improve. 
Keep it encouraging but professional. Max 3 sentences.
''';

    try {
      final response = await http.post(
          Uri.parse(_baseUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_apiKey',
          },
          body: jsonEncode({
            'model': _model,
            'messages': [
              {'role': 'user', 'content': prompt}
            ],
            'max_tokens': 150,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['choices'][0]['message']['content'];
        }
    } catch (e) {
      print('❌ Feedback Generation Failed: $e');
    }
    return 'Please review the topics you missed.';
  }
}
