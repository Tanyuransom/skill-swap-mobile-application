import 'package:postgres/postgres.dart';
import '../config/database_config.dart';
import 'dart:async';

class PostgresClient {
  static final List<Connection> _pool = [];
  static final List<int> _inUse = [];
  static bool _closing = false;
  static bool _isInitialized = false;
  static final _poolLock = Completer<void>()..complete();
  static const int _maxPoolSize = 10;
  static DatabaseConfig? _config; // Cache config

  /// Initialize the database connection pool
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Store config needed for creating new connections later
      // This is a slight hack if DatabaseConfig properties are static, 
      // but assuming they are accessible.
      
      // Initial pool
      for (var i = 0; i < 2; i++) {
        final conn = await _createConnection();
        _pool.add(conn);
      }

      _isInitialized = true;
      print('✅ Database connection pool initialized with initial connections');
    } catch (e) {
      print('❌ Failed to initialize database: $e');
      rethrow;
    }
  }

  /// Create a new database connection
  static Future<Connection> _createConnection() async {
    final endpoint = Endpoint(
      host: DatabaseConfig.host,
      port: DatabaseConfig.port,
      database: DatabaseConfig.database,
      username: DatabaseConfig.username,
      password: DatabaseConfig.password,
    );

    final connection = await Connection.open(
      endpoint,
      settings: ConnectionSettings(
        sslMode: SslMode.require,
        connectTimeout: DatabaseConfig.connectionTimeout,
      ),
    );

    return connection;
  }

  /// Get a connection from the pool
  static Future<Connection> getConnection() async {
    // Basic spin wait if closing
    if (_isInitialized == false) {
       await initialize();
    }
    
    // Try to find an open connection
    for (var i = 0; i < _pool.length; i++) {
      if (_pool[i].isOpen && !_inUse.contains(i)) {
        _inUse.add(i);
        return _pool[i];
      }
    }

    // If pool not full, create new
    if (_pool.length < _maxPoolSize) {
      try {
        final conn = await _createConnection();
        _pool.add(conn);
        _inUse.add(_pool.length - 1);
        return conn;
      } catch (e) {
        print('❌ Error adding new connection to pool: $e');
      }
    }
    
    // If we have dead connections in the pool (not open), replace them
    for (var i = 0; i < _pool.length; i++) {
      if (!_pool[i].isOpen && !_inUse.contains(i)) {
         print('🔄 Replacing dead connection $i');
         _pool[i] = await _createConnection();
         _inUse.add(i);
         return _pool[i];
      }
    }

    // Wait for connection
    await Future.delayed(Duration(milliseconds: 100));
    return getConnection();
  }

  /// Release connection back to pool
  static void releaseConnection(Connection connection) {
    if (_closing) {
        connection.close();
        return;
    }
    
    final index = _pool.indexOf(connection);
    if (index != -1) {
      _inUse.remove(index);
    }
  }

  /// Execute a query with automatic connection management
  static Future<Result> execute(
    String query, {
    Map<String, dynamic>? parameters,
  }) async {
    Connection? conn;
    try {
      conn = await getConnection();
      
      try {
        final result = parameters != null && parameters.isNotEmpty
            ? await conn.execute(Sql.named(query), parameters: parameters)
            : await conn.execute(query);
        return result;
      } catch (e) {
        // If execution fails, check if connection issue
        print('⚠️ Query failed: $e. Retrying once...');
        
        // Remove bad connection from pool
        final index = _pool.indexOf(conn);
        if (index != -1) {
            _pool.removeAt(index);
            _inUse.remove(index);
             // Best effort close
            try { await conn.close(); } catch (_) {}
        }
        
        // Retry with fresh connection
        conn = await getConnection();
        final result = parameters != null && parameters.isNotEmpty
            ? await conn.execute(Sql.named(query), parameters: parameters)
            : await conn.execute(query);
        return result;
      }
    } catch (e) {
      print('❌ Query execution error after retry: $e');
      rethrow;
    } finally {
      if (conn != null) {
        releaseConnection(conn);
      }
    }
  }

  /// Execute a query and return first row
  static Future<ResultRow?> executeOne(
    String query, {
    Map<String, dynamic>? parameters,
  }) async {
    final result = await execute(query, parameters: parameters);
    return result.isNotEmpty ? result.first : null;
  }

  /// Execute a transaction
  static Future<T> transaction<T>(
    Future<T> Function(Connection) action,
  ) async {
    Connection? conn;
    try {
      conn = await getConnection();
      await conn.execute('BEGIN');
      final result = await action(conn);
      await conn.execute('COMMIT');
      return result;
    } catch (e) {
      if (conn != null) {
        try {
          await conn.execute('ROLLBACK');
        } catch (_) {}
      }
      rethrow;
    } finally {
      if (conn != null) {
        releaseConnection(conn);
      }
    }
  }

  /// Close all connections
  static Future<void> close() async {
    _closing = true;
    for (final conn in _pool) {
      await conn.close();
    }
    _pool.clear();
    _inUse.clear();
    _isInitialized = false;
    _closing = false;
    print('✅ Database connections closed');
  }

  /// Test database connection
  static Future<bool> testConnection() async {
    try {
      final result = await execute('SELECT 1 as test');
      return result.isNotEmpty;
    } catch (e) {
      print('❌ Database connection test failed: $e');
      return false;
    }
  }
}
