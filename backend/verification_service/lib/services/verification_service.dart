import 'dart:convert';
import '../services/ai_service.dart';
import '../repositories/verification_repository.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';

class VerificationService {
  final VerificationRepository _repository = VerificationRepository();
  final AiService _aiService = AiService();

  /// Request a new verification (Generate Exam)
  Future<Map<String, dynamic>> requestVerification(String userId, String topic) async {
    // 1. Create Request Record
    final requestId = await _repository.createRequest(userId, topic);

    // 2. Generate Exam via AI
    // We do this asynchronously to not block? 
    // For now, let's do it inline for simplicity or return "Pending"
    // User expects exam immediately usually.
    
    final questions = await _aiService.generateExam(topic);
    
    // 3. Save Exam
    await _repository.saveExam(requestId, questions);

    return {
      'requestId': requestId,
      'status': 'generated',
      'message': 'Exam generated successfully. You can now fetch the questions.'
    };
  }

  /// Get exam questions (stripping correct answers)
  Future<Map<String, dynamic>> getExamQuestions(String userId, String requestId) async {
    // Verify ownership first for security
    final request = await _repository.getRequest(requestId);
    if (request == null) throw NotFoundException('Request not found');
    
    final requestUserId = request['user_id']?.toString();
    if (requestUserId != userId) {
      throw UnauthorizedException('You do not have permission to access this exam');
    }
    
    final exam = await _repository.getExam(requestId);
    if (exam == null) throw NotFoundException('Exam not found');
    
    // Type-safe parsing with validation
    final questionsRaw = exam['questions'];
    if (questionsRaw == null) throw NotFoundException('Exam questions not found');
    
    final questions = questionsRaw is String 
        ? (jsonDecode(questionsRaw) as List)
        : (questionsRaw as List);
    
    // Map to client format (remove correctIndex)
    final clientQuestions = questions.map((q) {
      final map = q as Map<String, dynamic>;
      if (!map.containsKey('question') || !map.containsKey('options')) {
        throw Exception('Invalid question format in database');
      }
      return {
        'question': map['question'],
        'options': map['options']
      };
    }).toList();

    return {
      'requestId': requestId,
      'questions': clientQuestions
    };
  }

  /// Submit answers
  Future<Map<String, dynamic>> submitExam(String userId, String requestId, List<int> answers) async {
    // Verify ownership
    final request = await _repository.getRequest(requestId);
    if (request == null) throw NotFoundException('Request not found');
    
    final requestUserId = request['user_id']?.toString();
    if (requestUserId != userId) {
      throw UnauthorizedException('You do not have permission to submit this exam');
    }
    
    final exam = await _repository.getExam(requestId);
    if (exam == null) throw NotFoundException('Exam not found');
    
    // Type-safe parsing
    final questionsRaw = exam['questions'];
    final questions = questionsRaw is String 
        ? (jsonDecode(questionsRaw) as List)
        : (questionsRaw as List);
    final typedQuestions = questions.cast<Map<String, dynamic>>();

    if (answers.length != typedQuestions.length) {
      throw BadRequestException('Mismatch in number of answers');
    }

    // Grade
    final result = await _aiService.gradeExam(request['topic'], typedQuestions, answers);
    final score = (result['score'] as double).toInt(); // store as int percentage
    final passed = result['passed'] as bool;
    final feedback = result['feedback'] as String;

    // Save Result
    await _repository.updateResult(requestId, score, feedback, passed);

    // Issue Badge if passed
    if (passed) {
      await _repository.issueBadge(userId, request['topic']);
    }

    return {
      'score': score,
      'passed': passed,
      'feedback': feedback,
      'badgeEarned': passed
    };
  }
  
  /// Get Badges
  Future<List<Map<String, dynamic>>> getBadges(String userId) async {
    return _repository.getUserBadges(userId);
  }
}
