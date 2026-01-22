import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:dotenv/dotenv.dart';

class EmailService {
  static final DotEnv _env = DotEnv()..load();

  static String get _smtpHost => _env['SMTP_HOST'] ?? 'smtp.gmail.com';
  static int get _smtpPort => int.parse(_env['SMTP_PORT'] ?? '587');
  static String get _smtpUser => _env['SMTP_USER'] ?? '';
  static String get _smtpPassword => _env['SMTP_PASSWORD'] ?? '';
  static String get _fromEmail => _env['EMAIL_FROM'] ?? _smtpUser;
  static String get _fromName => _env['EMAIL_FROM_NAME'] ?? 'SkillSwapp';

  /// Send OTP verification email
  static Future<bool> sendOTPEmail({
    required String toEmail,
    required String otp,
    required String userName,
  }) async {
    try {
      final smtpServer = gmail(_smtpUser, _smtpPassword);

      final message = Message()
        ..from = Address(_fromEmail, _fromName)
        ..recipients.add(toEmail)
        ..subject = 'SkillSwapp - Email Verification Code'
        ..html = _getOTPEmailTemplate(otp, userName);

      await send(message, smtpServer);
      print('✅ OTP email sent to $toEmail');
      return true;
    } catch (e) {
      print('❌ Failed to send OTP email: $e');
      return false;
    }
  }

  /// Send password reset email
  static Future<bool> sendPasswordResetEmail({
    required String toEmail,
    required String otp,
    required String userName,
  }) async {
    try {
      final smtpServer = gmail(_smtpUser, _smtpPassword);

      final message = Message()
        ..from = Address(_fromEmail, _fromName)
        ..recipients.add(toEmail)
        ..subject = 'SkillSwapp - Password Reset Code'
        ..html = _getPasswordResetTemplate(otp, userName);

      await send(message, smtpServer);
      print('✅ Password reset email sent to $toEmail');
      return true;
    } catch (e) {
      print('❌ Failed to send password reset email: $e');
      return false;
    }
  }

  /// Send welcome email
  static Future<bool> sendWelcomeEmail({
    required String toEmail,
    required String userName,
  }) async {
    try {
      final smtpServer = gmail(_smtpUser, _smtpPassword);

      final message = Message()
        ..from = Address(_fromEmail, _fromName)
        ..recipients.add(toEmail)
        ..subject = 'Welcome to SkillSwapp!'
        ..html = _getWelcomeEmailTemplate(userName);

      await send(message, smtpServer);
      print('✅ Welcome email sent to $toEmail');
      return true;
    } catch (e) {
      print('❌ Failed to send welcome email: $e');
      return false;
    }
  }

  /// OTP email template
  static String _getOTPEmailTemplate(String otp, String userName) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
        .otp-box { background: white; border: 2px dashed #667eea; padding: 20px; text-align: center; margin: 20px 0; border-radius: 8px; }
        .otp-code { font-size: 32px; font-weight: bold; color: #667eea; letter-spacing: 8px; }
        .footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>SkillSwapp</h1>
          <p>Email Verification</p>
        </div>
        <div class="content">
          <p>Hi $userName,</p>
          <p>Thank you for registering with SkillSwapp! Please use the following verification code to complete your registration:</p>
          
          <div class="otp-box">
            <div class="otp-code">$otp</div>
          </div>
          
          <p>This code will expire in <strong>3 minutes</strong>.</p>
          <p>If you didn't request this code, please ignore this email.</p>
          
          <p>Best regards,<br>The SkillSwapp Team</p>
        </div>
        <div class="footer">
          <p>© 2024 SkillSwapp. All rights reserved.</p>
        </div>
      </div>
    </body>
    </html>
    ''';
  }

  /// Password reset email template
  static String _getPasswordResetTemplate(String otp, String userName) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
        .otp-box { background: white; border: 2px dashed #f44336; padding: 20px; text-align: center; margin: 20px 0; border-radius: 8px; }
        .otp-code { font-size: 32px; font-weight: bold; color: #f44336; letter-spacing: 8px; }
        .footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>SkillSwapp</h1>
          <p>Password Reset</p>
        </div>
        <div class="content">
          <p>Hi $userName,</p>
          <p>We received a request to reset your password. Use the following code to reset your password:</p>
          
          <div class="otp-box">
            <div class="otp-code">$otp</div>
          </div>
          
          <p>This code will expire in <strong>3 minutes</strong>.</p>
          <p>If you didn't request a password reset, please ignore this email and your password will remain unchanged.</p>
          
          <p>Best regards,<br>The SkillSwapp Team</p>
        </div>
        <div class="footer">
          <p>© 2024 SkillSwapp. All rights reserved.</p>
        </div>
      </div>
    </body>
    </html>
    ''';
  }

  /// Welcome email template
  static String _getWelcomeEmailTemplate(String userName) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
        .button { display: inline-block; padding: 12px 30px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; }
        .footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>Welcome to SkillSwapp!</h1>
        </div>
        <div class="content">
          <p>Hi $userName,</p>
          <p>Welcome to SkillSwapp - your platform for learning and teaching skills!</p>
          <p>Your email has been successfully verified and your account is now active.</p>
          
          <p>Here's what you can do next:</p>
          <ul>
            <li>Complete your profile</li>
            <li>Browse available courses</li>
            <li>Start learning new skills</li>
            <li>Connect with tutors</li>
          </ul>
          
          <p>We're excited to have you on board!</p>
          
          <p>Best regards,<br>The SkillSwapp Team</p>
        </div>
        <div class="footer">
          <p>© 2024 SkillSwapp. All rights reserved.</p>
        </div>
      </div>
    </body>
    </html>
    ''';
  }
}
