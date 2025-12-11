import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/order_service.dart';
import '../../../services/auth_service.dart';
import '../../../data/models/order_model.dart';
import '../../../core/enums/enums.dart';

class OrderHistoryViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _orderService = locator<OrderService>();
  final _authService = locator<AuthService>();
  final _snackbarService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _filteredOrders;

  List<OrderModel> get _filteredOrders {
    if (_selectedFilter == 'All') return _orders;
    return _orders.where((order) {
      switch (_selectedFilter) {
        case 'Pending':
          return order.status == OrderStatus.pending;
        case 'Executed':
          return order.status == OrderStatus.executed;
        case 'Cancelled':
          return order.status == OrderStatus.cancelled;
        default:
          return true;
      }
    }).toList();
  }

  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  final List<String> filters = ['All', 'Pending', 'Executed', 'Cancelled'];

  Future<void> initialize() async {
    setBusy(true);
    await _loadOrders();
    setBusy(false);
  }

  Future<void> refreshData() async {
    await _loadOrders();
    notifyListeners();
  }

  Future<void> _loadOrders() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      _orders = await _orderService.getOrderHistory(userId, limit: 100);
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Failed to load orders');
    }
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<void> cancelOrder(OrderModel order) async {
    if (order.status != OrderStatus.pending) {
      _snackbarService.showSnackbar(message: 'Only pending orders can be cancelled');
      return;
    }

    final result = await _dialogService.showConfirmationDialog(
      title: 'Cancel Order',
      description: 'Are you sure you want to cancel this order?',
      confirmationTitle: 'Cancel Order',
      cancelTitle: 'Keep Order',
    );

    if (result?.confirmed ?? false) {
      setBusy(true);
      try {
        final success = await _orderService.cancelOrder(order.id);
        if (success) {
          _snackbarService.showSnackbar(message: 'Order cancelled successfully');
          await _loadOrders();
        } else {
          _snackbarService.showSnackbar(message: 'Failed to cancel order');
        }
      } catch (e) {
        _snackbarService.showSnackbar(message: 'Failed to cancel order');
      }
      setBusy(false);
    }
  }

  void openStockDetails(String symbol) {
    _navigationService.navigateTo(
      Routes.stockDetailsView,
      arguments: StockDetailsViewArguments(symbol: symbol),
    );
  }

  void goBack() {
    _navigationService.back();
  }
}
