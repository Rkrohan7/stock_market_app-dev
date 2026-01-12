import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/stock_service.dart';
import '../../../services/order_service.dart';
import '../../../services/portfolio_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/fund_service.dart';
import '../../../services/user_service.dart';
import '../../../data/models/stock_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/portfolio_model.dart';
import '../../../data/models/user_model.dart';
import '../../../core/enums/enums.dart';

class TradingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _stockService = locator<StockService>();
  final _orderService = locator<OrderService>();
  final _portfolioService = locator<PortfolioService>();
  final _authService = locator<AuthService>();
  final _fundService = locator<FundService>();
  final _userService = locator<UserService>();
  final _snackbarService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();

  final String symbol;
  final bool isBuy;

  TradingViewModel({required this.symbol, required this.isBuy});

  // User verification status
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // All users can now trade
  bool get isUserVerified => true;
  bool get isVerificationPending => false;

  // KYC is now optional
  bool get needsKyc => false;

  // Check if KYC is rejected
  bool get isKycRejected => false;

  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  StockModel? _stock;
  StockModel? get stock => _stock;

  // Available quantity in portfolio (for selling)
  int _availableQuantity = 0;
  int get availableQuantity => _availableQuantity;

  // Wallet balance (for buying)
  double _walletBalance = 0;
  double get walletBalance => _walletBalance;

  // Holding info
  HoldingModel? _holding;
  HoldingModel? get holding => _holding;

  OrderType _orderType = OrderType.market;
  OrderType get orderType => _orderType;

  ProductType _productType = ProductType.delivery;
  ProductType get productType => _productType;

  int _quantity = 0;
  int get quantity => _quantity;

  double _limitPrice = 0;
  double get limitPrice => _limitPrice;

  double get estimatedValue =>
      _quantity *
      (orderType == OrderType.market
          ? (_stock?.currentPrice ?? 0)
          : _limitPrice);

  double get brokerage =>
      _orderService.calculateBrokerage(estimatedValue, isBuy);

  double get totalValue =>
      isBuy ? estimatedValue + brokerage : estimatedValue - brokerage;

  // For buy: check quantity > 0 AND sufficient balance AND user verified
  // For sell: check quantity > 0 AND quantity <= available shares AND user verified
  bool get canPlaceOrder {
    // User must be verified by admin to trade
    if (!isUserVerified) return false;

    if (_quantity <= 0) return false;
    if (orderType == OrderType.limit && _limitPrice <= 0) return false;

    // For buy orders, validate against wallet balance
    if (isBuy && totalValue > _walletBalance) return false;

    // For sell orders, validate against available quantity
    if (!isBuy && _quantity > _availableQuantity) return false;

    return true;
  }

  // Check if user has insufficient balance for buy
  bool get hasInsufficientBalance =>
      isBuy && totalValue > _walletBalance && _quantity > 0;

  // Error message for invalid quantity or insufficient balance
  String? get quantityError {
    if (isBuy && _quantity > 0 && totalValue > _walletBalance) {
      return 'Insufficient balance. You need ₹${totalValue.toStringAsFixed(2)} but have ₹${_walletBalance.toStringAsFixed(2)}';
    }
    if (!isBuy && _quantity > _availableQuantity) {
      return 'You only have $_availableQuantity shares available to sell';
    }
    return null;
  }

  Future<void> initialize() async {
    setBusy(true);
    await _loadUserVerificationStatus();
    await _loadStockDetails();
    if (isBuy) {
      await _loadWalletBalance();
    } else {
      await _loadHolding();
    }
    setBusy(false);
  }

  Future<void> _loadUserVerificationStatus() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      _currentUser = await _userService.getUserById(userId);
    } catch (e) {
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<void> _loadWalletBalance() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      _walletBalance = await _fundService.getWalletBalance(userId);
    } catch (e) {
      _walletBalance = 0;
    }
    notifyListeners();
  }

  Future<void> _loadStockDetails() async {
    _stock = await _stockService.getStockDetails(symbol);
    if (_stock != null) {
      priceController.text = _stock!.currentPrice.toStringAsFixed(2);
      _limitPrice = _stock!.currentPrice;
    }
    notifyListeners();
  }

  // Load user's holding for this stock (for sell validation)
  Future<void> _loadHolding() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      final portfolio = await _portfolioService.getPortfolio(userId);
      if (portfolio != null) {
        _holding = portfolio.holdings.firstWhere(
          (h) => h.symbol == symbol,
          orElse: () => HoldingModel(
            id: '',
            symbol: symbol,
            name: '',
            quantity: 0,
            averagePrice: 0,
            currentPrice: 0,
            purchaseDate: DateTime.now(),
          ),
        );
        _availableQuantity = _holding?.quantity ?? 0;
      }
    } catch (e) {
      _availableQuantity = 0;
    }
    notifyListeners();
  }

  void setOrderType(OrderType type) {
    _orderType = type;
    notifyListeners();
  }

  void setProductType(ProductType type) {
    _productType = type;
    notifyListeners();
  }

  void updateQuantity(String value) {
    _quantity = int.tryParse(value) ?? 0;
    notifyListeners();
  }

  void updateLimitPrice(String value) {
    _limitPrice = double.tryParse(value) ?? 0;
    notifyListeners();
  }

  void incrementQuantity() {
    _quantity++;
    quantityController.text = _quantity.toString();
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 0) {
      _quantity--;
      quantityController.text = _quantity.toString();
      notifyListeners();
    }
  }

  // Track order success state
  bool _orderSuccess = false;
  bool get orderSuccess => _orderSuccess;

  String _orderId = '';
  String get orderId => _orderId;

  // Show verification message (not applicable in learning mode)
  void showKycPendingMessage() {
    // In learning mode, all users can trade immediately
    if (isVerificationPending) {
      _snackbarService.showSnackbar(
        message:
            'Your KYC is pending admin approval. Please wait for verification.',
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> placeOrder() async {
    // Check KYC status before allowing order
    if (!isUserVerified) {
      showKycPendingMessage();
      return;
    }

    if (!canPlaceOrder) return;

    final confirmed = await _dialogService.showConfirmationDialog(
      title: 'Confirm ${isBuy ? 'Buy' : 'Sell'} Order',
      description:
          'Are you sure you want to ${isBuy ? 'buy' : 'sell'} $_quantity shares of $symbol at ${orderType == OrderType.market ? 'market price' : '₹${_limitPrice.toStringAsFixed(2)}'}?',
      confirmationTitle: 'Confirm',
      cancelTitle: 'Cancel',
    );

    if (confirmed?.confirmed ?? false) {
      setBusy(true);

      try {
        final price = orderType == OrderType.market
            ? _stock!.currentPrice
            : _limitPrice;
        final userId = _authService.userId ?? 'demo_user';

        final order = OrderModel(
          id: '',
          odersId: userId,
          symbol: symbol,
          stockName: _stock!.name,
          orderType: _orderType,
          orderSide: isBuy ? OrderSide.buy : OrderSide.sell,
          tradingMode: _productType == ProductType.delivery
              ? TradingMode.delivery
              : TradingMode.intraday,
          status: OrderStatus.pending,
          quantity: _quantity,
          price: price,
          createdAt: DateTime.now(),
        );

        _orderId = await _orderService.placeOrder(order);
        _orderSuccess = true;
        setBusy(false);
        notifyListeners();
      } catch (e) {
        _orderSuccess = false;
        setBusy(false);
        _snackbarService.showSnackbar(
          message: 'Failed to place order: $e',
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  void goBack() {
    _navigationService.back();
  }

  // Navigate to portfolio after successful order
  void navigateToPortfolio() {
    _navigationService.clearStackAndShow(Routes.homeView);
  }

  // Navigate to home after successful order
  void navigateToHome() {
    _navigationService.clearStackAndShow(Routes.homeView);
  }

  @override
  void dispose() {
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
