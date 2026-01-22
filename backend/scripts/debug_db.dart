import 'package:skillswapp_shared/skillswapp_shared.dart';

void main() async {
  // Try loading env
  var env = DotEnv(includePlatformEnvironment: true)..load();
  if (env['DB_HOST'] == null) {
      print('Loading .env explicitly...');
      env = DotEnv(includePlatformEnvironment: true)..load(['.env']);
  }
  
  print('--- Debug Config ---');
  print('Host: ${env['DB_HOST']}');
  print('Port: ${env['DB_PORT']}');
  print('User: ${env['DB_USER']}');
  print('Database: ${env['DB_NAME']}');
  print('SSL Mode: Require');
  
  // Test Connection directly using PostgresClient
  try {
     print('Initializing Client...');
     // Force config load if needed in shared lib
     await PostgresClient.initialize();
     print('✅ Connection Successful');
      
     // Check if table exists
     final check = await PostgresClient.execute("SELECT to_regclass('public.verification_requests')");
     print('Table Check: $check');
     
  } catch (e) {
     print('❌ Connection Failed: $e');
  } finally {
     await PostgresClient.close();
  }
}
