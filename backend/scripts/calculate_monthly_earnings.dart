import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../analytics_service/lib/services/analytics_service.dart';

/// Cron job to calculate monthly earnings
/// Run this at the end of each month (e.g., via crontab)
/// Example: 0 0 1 * * dart scripts/calculate_monthly_earnings.dart
void main(List<String> args) async {
  print('💰 Monthly Earnings Calculator');
  print('================================');
  
  // Determine which month to calculate
  DateTime targetMonth;
  
  if (args.isNotEmpty) {
    // Parse month from argument (format: YYYY-MM)
    final parts = args[0].split('-');
    targetMonth = DateTime(int.parse(parts[0]), int.parse(parts[1]), 1);
  } else {
    // Default: previous month
    final now = DateTime.now();
    targetMonth = DateTime(now.year, now.month - 1, 1);
  }
  
  print('📅 Calculating earnings for: ${targetMonth.year}-${targetMonth.month.toString().padLeft(2, '0')}');
  print('');
  
  try {
    // Initialize database
    await PostgresClient.initialize();
    print('✅ Database connected');
    
    // Calculate earnings
    final analyticsService = AnalyticsService();
    await analyticsService.calculateMonthlyEarnings(targetMonth);
    
    // Credit wallets
    print('');
    print('💳 Crediting tutor wallets...');
    await _creditTutorWallets(targetMonth);
    
    print('');
    print('✅ Monthly earnings calculation complete!');
    
  } catch (e, stackTrace) {
    print('❌ Error: $e');
    print(stackTrace);
  } finally {
    await PostgresClient.close();
  }
}

/// Credit tutor wallets with their earnings
Future<void> _creditTutorWallets(DateTime month) async {
  final monthStr = '${month.year}-${month.month.toString().padLeft(2, '0')}-01';
  
  final result = await PostgresClient.execute(
    '''
    SELECT tutor_id, total_earnings 
    FROM tutor_earnings
    WHERE month = @month AND total_earnings > 0
    ''',
    parameters: {'month': monthStr},
  );
  
  for (var row in result) {
    final tutorId = row.toColumnMap()['tutor_id'].toString();
    final earnings = double.parse(row.toColumnMap()['total_earnings'].toString());
    
    // Credit wallet
    await PostgresClient.execute(
      '''
      UPDATE wallets
      SET balance = balance + @earnings,
          total_earned = total_earned + @earnings,
          updated_at = CURRENT_TIMESTAMP
      WHERE user_id = @tutorId
      ''',
      parameters: {
        'tutorId': tutorId,
        'earnings': earnings,
      },
    );
    
    print('  ✅ Credited ${earnings.toStringAsFixed(2)} XAF to tutor $tutorId');
  }
}
