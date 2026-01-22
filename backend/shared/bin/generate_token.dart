import 'package:skillswapp_shared/skillswapp_shared.dart';

void main() async {
  // Load environment variables from parent directory if possible, or current
  // Assuming run from backend/shared/
  var env = DotEnv(includePlatformEnvironment: true)..load(['../.env']);
  
  // print('Secret: ${env['JWT_SECRET']}'); 

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

  print(token);
}
