// Order Types
enum OrderType { market, limit, stopLoss, stopLimit }

extension OrderTypeExtension on OrderType {
  String get displayName {
    switch (this) {
      case OrderType.market:
        return 'Market';
      case OrderType.limit:
        return 'Limit';
      case OrderType.stopLoss:
        return 'Stop Loss';
      case OrderType.stopLimit:
        return 'Stop Limit';
    }
  }
}

// Order Side
enum OrderSide { buy, sell }

extension OrderSideExtension on OrderSide {
  String get displayName {
    switch (this) {
      case OrderSide.buy:
        return 'Buy';
      case OrderSide.sell:
        return 'Sell';
    }
  }
}

// Order Status
enum OrderStatus { pending, executed, cancelled, rejected, partiallyFilled }

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.executed:
        return 'Executed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.rejected:
        return 'Rejected';
      case OrderStatus.partiallyFilled:
        return 'Partially Filled';
    }
  }
}

// Trading Mode
enum TradingMode { intraday, delivery }

extension TradingModeExtension on TradingMode {
  String get displayName {
    switch (this) {
      case TradingMode.intraday:
        return 'Intraday';
      case TradingMode.delivery:
        return 'Delivery';
    }
  }
}

// Product Type (for trading)
enum ProductType { delivery, intraday }

extension ProductTypeExtension on ProductType {
  String get displayName {
    switch (this) {
      case ProductType.delivery:
        return 'Delivery (CNC)';
      case ProductType.intraday:
        return 'Intraday (MIS)';
    }
  }
}

// KYC Status
enum KycStatus { pending, submitted, verified, rejected }

extension KycStatusExtension on KycStatus {
  String get displayName {
    switch (this) {
      case KycStatus.pending:
        return 'Pending';
      case KycStatus.submitted:
        return 'Under Review';
      case KycStatus.verified:
        return 'Verified';
      case KycStatus.rejected:
        return 'Rejected';
    }
  }
}

// Chart Interval
enum ChartInterval { m1, m5, m15, m30, h1, h4, d1, w1, mo1 }

extension ChartIntervalExtension on ChartInterval {
  String get displayName {
    switch (this) {
      case ChartInterval.m1:
        return '1m';
      case ChartInterval.m5:
        return '5m';
      case ChartInterval.m15:
        return '15m';
      case ChartInterval.m30:
        return '30m';
      case ChartInterval.h1:
        return '1H';
      case ChartInterval.h4:
        return '4H';
      case ChartInterval.d1:
        return '1D';
      case ChartInterval.w1:
        return '1W';
      case ChartInterval.mo1:
        return '1M';
    }
  }

  Duration get duration {
    switch (this) {
      case ChartInterval.m1:
        return const Duration(minutes: 1);
      case ChartInterval.m5:
        return const Duration(minutes: 5);
      case ChartInterval.m15:
        return const Duration(minutes: 15);
      case ChartInterval.m30:
        return const Duration(minutes: 30);
      case ChartInterval.h1:
        return const Duration(hours: 1);
      case ChartInterval.h4:
        return const Duration(hours: 4);
      case ChartInterval.d1:
        return const Duration(days: 1);
      case ChartInterval.w1:
        return const Duration(days: 7);
      case ChartInterval.mo1:
        return const Duration(days: 30);
    }
  }
}

// Market Status
enum MarketStatus { preOpen, open, closed, postClose }

extension MarketStatusExtension on MarketStatus {
  String get displayName {
    switch (this) {
      case MarketStatus.preOpen:
        return 'Pre-Open';
      case MarketStatus.open:
        return 'Open';
      case MarketStatus.closed:
        return 'Closed';
      case MarketStatus.postClose:
        return 'Post-Close';
    }
  }
}

// Alert Type
enum AlertType { priceAbove, priceBelow, percentageChange, volume }

extension AlertTypeExtension on AlertType {
  String get displayName {
    switch (this) {
      case AlertType.priceAbove:
        return 'Price Above';
      case AlertType.priceBelow:
        return 'Price Below';
      case AlertType.percentageChange:
        return 'Percentage Change';
      case AlertType.volume:
        return 'Volume Alert';
    }
  }
}

// View State
enum ViewState { idle, loading, success, error }

// Education Content Type
enum ContentType { video, article, quiz }

extension ContentTypeExtension on ContentType {
  String get displayName {
    switch (this) {
      case ContentType.video:
        return 'Video';
      case ContentType.article:
        return 'Article';
      case ContentType.quiz:
        return 'Quiz';
    }
  }
}

// Risk Level
enum RiskLevel { low, medium, high, veryHigh }

extension RiskLevelExtension on RiskLevel {
  String get displayName {
    switch (this) {
      case RiskLevel.low:
        return 'Low Risk';
      case RiskLevel.medium:
        return 'Medium Risk';
      case RiskLevel.high:
        return 'High Risk';
      case RiskLevel.veryHigh:
        return 'Very High Risk';
    }
  }
}

// Fund Transaction Type
enum FundTransactionType { deposit, withdrawal }

extension FundTransactionTypeExtension on FundTransactionType {
  String get displayName {
    switch (this) {
      case FundTransactionType.deposit:
        return 'Deposit';
      case FundTransactionType.withdrawal:
        return 'Withdrawal';
    }
  }
}

// Payment Method
enum PaymentMethod { upi, netBanking, card, wallet }

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.netBanking:
        return 'Net Banking';
      case PaymentMethod.card:
        return 'Debit/Credit Card';
      case PaymentMethod.wallet:
        return 'Wallet';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethod.upi:
        return 'upi';
      case PaymentMethod.netBanking:
        return 'bank';
      case PaymentMethod.card:
        return 'card';
      case PaymentMethod.wallet:
        return 'wallet';
    }
  }
}

// Fund Transaction Status
enum FundTransactionStatus { pending, processing, completed, failed, cancelled }

extension FundTransactionStatusExtension on FundTransactionStatus {
  String get displayName {
    switch (this) {
      case FundTransactionStatus.pending:
        return 'Pending';
      case FundTransactionStatus.processing:
        return 'Processing';
      case FundTransactionStatus.completed:
        return 'Completed';
      case FundTransactionStatus.failed:
        return 'Failed';
      case FundTransactionStatus.cancelled:
        return 'Cancelled';
    }
  }
}
