class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException() : super('Invalid email or password');
}

class EmailAlreadyExistsException extends AuthException {
  EmailAlreadyExistsException() : super('Email already exists');
}

class InvalidTokenException extends AuthException {
  InvalidTokenException() : super('Invalid or expired token');
}

class EmailNotVerifiedException extends AuthException {
  EmailNotVerifiedException() : super('Email not verified');
}

class AccountInactiveException extends AuthException {
  AccountInactiveException() : super('Account is inactive');
}

class InvalidOTPException extends AuthException {
  InvalidOTPException() : super('Invalid or expired OTP');
}

class WeakPasswordException extends AuthException {
  WeakPasswordException(String message) : super(message);
}
