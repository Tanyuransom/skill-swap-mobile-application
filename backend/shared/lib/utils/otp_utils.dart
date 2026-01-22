import 'dart:math';

class OTPUtils {
  static final Random _random = Random.secure();

  /// Generate a 6-digit OTP
  static String generateOTP({int length = 6}) {
    String otp = '';
    for (int i = 0; i < length; i++) {
      otp += _random.nextInt(10).toString();
    }
    return otp;
  }

  /// Generate OTP expiry time (default 10 minutes)
  static DateTime getOTPExpiry({int minutes = 3}) {
    return DateTime.now().add(Duration(minutes: minutes));
  }

  /// Check if OTP is expired
  static bool isOTPExpired(DateTime expiryTime) {
    return DateTime.now().isAfter(expiryTime);
  }

  /// Validate OTP format
  static bool isValidOTPFormat(String otp, {int length = 6}) {
    if (otp.length != length) return false;
    return RegExp(r'^\d+$').hasMatch(otp);
  }
}
