import 'package:skillswapp_shared/skillswapp_shared.dart';

void main() async {
  await PostgresClient.initialize();
  
  // Create a test course
  final result = await PostgresClient.execute('''
    INSERT INTO courses (tutor_id, title, description, category, level, price)
    VALUES (
      '5bff3fec-79b4-4181-92e9-cce2f5afa6b7',
      'Test Course for Learning Service',
      'Test course',
      'Programming',
      'beginner',
      0
    )
    RETURNING id
  ''');
  
  final courseId = result.first.toColumnMap()['id'].toString();
  print('COURSE_ID=$courseId');
  
  // Create 10 test lessons
  for (var i = 1; i <= 10; i++) {
    await PostgresClient.execute('''
      INSERT INTO lessons (course_id, title, content, video_url, duration, lesson_order)
      VALUES (@courseId, @title, 'Content', @videoUrl, 300, @order)
    ''', parameters: {
      'courseId': courseId,
      'title': 'Lesson $i',
      'videoUrl': 'https://example.com/video$i.mp4',
      'order': i,
    });
  }
  
  print('Created 10 lessons');
  
  await PostgresClient.close();
}
