// Shared library exports
library skillswapp_shared;

// External packages
export 'package:postgres/postgres.dart';
export 'package:dotenv/dotenv.dart';
export 'package:logger/logger.dart';

// Config
export 'config/database_config.dart';

// Database
export 'database/postgres_client.dart';

// Middleware
export 'middleware/cors_middleware.dart';
export 'middleware/auth_middleware.dart';
export 'middleware/logging_middleware.dart';

// Utils
export 'utils/jwt_utils.dart';
export 'utils/hash_utils.dart';
export 'utils/otp_utils.dart';
export 'utils/email_service.dart';
export 'utils/uuid_utils.dart';

// Models
export 'models/api_response.dart';
export 'models/user_model.dart';

// Exceptions
export 'exceptions/app_exception.dart';
export 'exceptions/auth_exception.dart';
