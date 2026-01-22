import 'package:dotenv/dotenv.dart';

class DatabaseConfig {
  static final DotEnv _env = DotEnv()..load();

  // Neon PostgreSQL configuration
  static String get host => _env['DATABASE_HOST'] ?? 'localhost';
  static int get port => int.parse(_env['DATABASE_PORT'] ?? '5432');
  static String get database => _env['DATABASE_NAME'] ?? 'neondb';
  static String get username => _env['DATABASE_USER'] ?? 'postgres';
  static String get password => _env['DATABASE_PASSWORD'] ?? '';
  static String get connectionString => _env['DATABASE_URL'] ?? '';

  // Connection pool settings
  static int get maxConnections => int.parse(_env['DB_MAX_CONNECTIONS'] ?? '10');
  static int get minConnections => int.parse(_env['DB_MIN_CONNECTIONS'] ?? '2');

  // SSL configuration (required for Neon)
  static bool get useSSL => _env['DATABASE_SSL'] != 'false'; // Default true
  static String get sslMode => _env['DATABASE_SSL_MODE'] ?? 'require';

  // Connection timeout
  static Duration get connectionTimeout =>
      Duration(seconds: int.parse(_env['DB_TIMEOUT'] ?? '30'));

  static Map<String, String> toMap() {
    return {
      'host': host,
      'port': port.toString(),
      'database': database,
      'username': username,
      'useSSL': useSSL.toString(),
    };
  }
}
