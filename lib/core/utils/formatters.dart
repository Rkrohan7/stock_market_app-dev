import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  // Currency Formatters
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final NumberFormat _compactCurrencyFormat = NumberFormat.compactCurrency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatCompactCurrency(double amount) {
    return _compactCurrencyFormat.format(amount);
  }

  static String formatCurrencyWithSign(double amount) {
    final formatted = _currencyFormat.format(amount.abs());
    return amount >= 0 ? '+$formatted' : '-$formatted';
  }

  // Number Formatters
  static final NumberFormat _numberFormat = NumberFormat('#,##,###.##', 'en_IN');
  static final NumberFormat _compactNumberFormat = NumberFormat.compact(locale: 'en_IN');

  static String formatNumber(double number) {
    return _numberFormat.format(number);
  }

  static String formatCompactNumber(double number) {
    return _compactNumberFormat.format(number);
  }

  static String formatInteger(int number) {
    return NumberFormat('#,##,###', 'en_IN').format(number);
  }

  // Percentage Formatters
  static String formatPercentage(double percentage, {int decimals = 2}) {
    final formatted = percentage.toStringAsFixed(decimals);
    return percentage >= 0 ? '+$formatted%' : '$formatted%';
  }

  static String formatPercentageNoSign(double percentage, {int decimals = 2}) {
    return '${percentage.toStringAsFixed(decimals)}%';
  }

  // Volume Formatters
  static String formatVolume(int volume) {
    if (volume >= 10000000) {
      return '${(volume / 10000000).toStringAsFixed(2)} Cr';
    } else if (volume >= 100000) {
      return '${(volume / 100000).toStringAsFixed(2)} L';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(2)} K';
    }
    return volume.toString();
  }

  // Market Cap Formatter
  static String formatMarketCap(double marketCap) {
    if (marketCap >= 10000000000000) {
      return '₹${(marketCap / 10000000000000).toStringAsFixed(2)} L Cr';
    } else if (marketCap >= 100000000000) {
      return '₹${(marketCap / 100000000000).toStringAsFixed(2)} K Cr';
    } else if (marketCap >= 10000000) {
      return '₹${(marketCap / 10000000).toStringAsFixed(2)} Cr';
    }
    return formatCompactCurrency(marketCap);
  }

  // Date Formatters
  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _shortDateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _chartDateFormat = DateFormat('dd MMM');
  static final DateFormat _chartTimeFormat = DateFormat('HH:mm');

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  static String formatChartDate(DateTime date) {
    return _chartDateFormat.format(date);
  }

  static String formatChartTime(DateTime time) {
    return _chartTimeFormat.format(time);
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return formatDate(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Phone Number Formatter
  static String formatPhoneNumber(String phone) {
    if (phone.length == 10) {
      return '${phone.substring(0, 5)} ${phone.substring(5)}';
    }
    return phone;
  }

  // Mask formatters
  static String maskPhoneNumber(String phone) {
    if (phone.length >= 10) {
      return '${phone.substring(0, 2)}******${phone.substring(phone.length - 2)}';
    }
    return phone;
  }

  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length == 2 && parts[0].length > 2) {
      final name = parts[0];
      final maskedName = '${name.substring(0, 2)}${'*' * (name.length - 2)}';
      return '$maskedName@${parts[1]}';
    }
    return email;
  }

  // PAN/Aadhaar Formatter
  static String formatPan(String pan) {
    if (pan.length == 10) {
      return '${pan.substring(0, 5)}****${pan.substring(9)}';
    }
    return pan;
  }

  static String formatAadhaar(String aadhaar) {
    if (aadhaar.length == 12) {
      return 'XXXX XXXX ${aadhaar.substring(8)}';
    }
    return aadhaar;
  }
}
