import '../shared/lib/skillswapp_shared.dart';
import 'dart:io';

void main() async {
  // Load environment variables
  var env = DotEnv(includePlatformEnvironment: true)..load();
  
  // backend/.env is usually where it is, assuming run from backend/
  if (env['JWT_SECRET'] == null) {
      env = DotEnv(includePlatformEnvironment: true)..load(['.env']);
  }

  // User details for token
  final userId = '5bff3fec-79b4-4181-92e9-cce2f5afa6b7'; // ID from previous registration log
  final email = 'pepe@gmail.com';
  final role = 'tutor';

  // Generate token
  final token = JWTUtils.generateAccessToken(
    userId: userId,
    email: email,
    role: role,
  );

  print('New Token: $token');
  
  // Save to token.txt for test scripts
  final file = File('token.txt');
  await file.writeAsString(token);
  print('✅ Token saved to token.txt');
}
