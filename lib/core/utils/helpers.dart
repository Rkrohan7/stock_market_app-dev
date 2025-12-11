import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class Helpers {
  Helpers._();

  // Check if market is open (IST: 9:15 AM - 3:30 PM, Mon-Fri)
  static bool isMarketOpen() {
    final now = DateTime.now();
    final weekday = now.weekday;

    // Market closed on weekends
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      return false;
    }

    final marketOpen = DateTime(now.year, now.month, now.day, 9, 15);
    final marketClose = DateTime(now.year, now.month, now.day, 15, 30);

    return now.isAfter(marketOpen) && now.isBefore(marketClose);
  }

  // Get market status message
  static String getMarketStatusMessage() {
    if (isMarketOpen()) {
      return 'Market is Open';
    }

    final now = DateTime.now();
    final weekday = now.weekday;

    if (weekday == DateTime.saturday) {
      return 'Market opens Monday 9:15 AM';
    } else if (weekday == DateTime.sunday) {
      return 'Market opens tomorrow 9:15 AM';
    }

    final marketOpen = DateTime(now.year, now.month, now.day, 9, 15);
    final marketClose = DateTime(now.year, now.month, now.day, 15, 30);

    if (now.isBefore(marketOpen)) {
      return 'Market opens at 9:15 AM';
    } else if (now.isAfter(marketClose)) {
      return 'Market closed for today';
    }

    return 'Market is Closed';
  }

  // Calculate percentage change
  static double calculatePercentageChange(double current, double previous) {
    if (previous == 0) return 0;
    return ((current - previous) / previous) * 100;
  }

  // Get color based on value (positive/negative)
  static Color getChangeColor(double value) {
    if (value > 0) return AppColors.profit;
    if (value < 0) return AppColors.loss;
    return AppColors.neutral;
  }

  // Get arrow icon based on value
  static IconData getChangeIcon(double value) {
    if (value > 0) return Icons.arrow_upward_rounded;
    if (value < 0) return Icons.arrow_downward_rounded;
    return Icons.remove_rounded;
  }

  // Format stock symbol
  static String formatSymbol(String symbol) {
    return symbol.toUpperCase().replaceAll(' ', '');
  }

  // Generate order ID
  static String generateOrderId() {
    final now = DateTime.now();
    return 'ORD${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecondsSinceEpoch.toString().substring(7)}';
  }

  // Generate transaction ID
  static String generateTransactionId() {
    final now = DateTime.now();
    return 'TXN${now.millisecondsSinceEpoch}';
  }

  // Copy to clipboard
  static Future<void> copyToClipboard(String text, BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Show snackbar
  static void showSnackbar(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : null,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Show confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDangerous
                ? ElevatedButton.styleFrom(backgroundColor: AppColors.error)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Calculate investment value
  static double calculateInvestmentValue(int quantity, double averagePrice) {
    return quantity * averagePrice;
  }

  // Calculate current value
  static double calculateCurrentValue(int quantity, double currentPrice) {
    return quantity * currentPrice;
  }

  // Calculate profit/loss
  static double calculateProfitLoss(int quantity, double averagePrice, double currentPrice) {
    return (currentPrice - averagePrice) * quantity;
  }

  // Calculate profit/loss percentage
  static double calculateProfitLossPercentage(double averagePrice, double currentPrice) {
    if (averagePrice == 0) return 0;
    return ((currentPrice - averagePrice) / averagePrice) * 100;
  }

  // Get greeting based on time
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Debounce helper
  static Function(T) debounce<T>(
    Duration duration,
    Function(T) callback,
  ) {
    DateTime? lastCall;
    return (T argument) {
      final now = DateTime.now();
      if (lastCall == null || now.difference(lastCall!) > duration) {
        lastCall = now;
        callback(argument);
      }
    };
  }
}
