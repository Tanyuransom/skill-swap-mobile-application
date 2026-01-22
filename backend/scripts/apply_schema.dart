import 'dart:io';
import 'package:postgres/postgres.dart';
import 'package:dotenv/dotenv.dart';

/// Script to apply database schema to Neon PostgreSQL
void main() async {
  print('🚀 Applying database schema to Neon PostgreSQL...\n');

  try {
    // Load environment variables
    final env = DotEnv()..load();

    // Read schema file
    final schemaFile = File('database/schema.sql');
    if (!schemaFile.existsSync()) {
      print('❌ Schema file not found: database/schema.sql');
      exit(1);
    }

    final schema = await schemaFile.readAsString();
    print('✅ Schema file loaded (${schema.length} characters)\n');

    // Connect to database
    print('📡 Connecting to Neon PostgreSQL...');
    final endpoint = Endpoint(
      host: env['DATABASE_HOST'] ?? '',
      port: int.parse(env['DATABASE_PORT'] ?? '5432'),
      database: env['DATABASE_NAME'] ?? '',
      username: env['DATABASE_USER'] ?? '',
      password: env['DATABASE_PASSWORD'] ?? '',
    );

    final connection = await Connection.open(
      endpoint,
      settings: ConnectionSettings(
        sslMode: SslMode.require,
      ),
    );

    print('✅ Connected to database\n');

    // Execute schema
    print('📝 Applying schema...');
    await connection.execute(schema);
    
    print('✅ Schema applied successfully!\n');

    // Verify tables created
    print('🔍 Verifying tables...');
    final result = await connection.execute(
      "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name",
    );

    print('✅ Created ${result.length} tables:');
    for (final row in result) {
      print('   - ${row[0]}');
    }

    await connection.close();
    print('\n✅ Database setup complete!');
  } catch (e, stackTrace) {
    print('❌ Error applying schema: $e');
    print(stackTrace);
    exit(1);
  }
}
