import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';

class HelpSupportViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  int? _expandedFaqIndex;
  int? get expandedFaqIndex => _expandedFaqIndex;

  void toggleFaq(int index) {
    if (_expandedFaqIndex == index) {
      _expandedFaqIndex = null;
    } else {
      _expandedFaqIndex = index;
    }
    notifyListeners();
  }

  void goBack() {
    _navigationService.back();
  }

  void openEmail() {
    _snackbarService.showSnackbar(
      message: 'Email: support@stockapp.com',
      duration: const Duration(seconds: 3),
    );
  }

  void openPhone() {
    _snackbarService.showSnackbar(
      message: 'Call: +91 1800-XXX-XXXX',
      duration: const Duration(seconds: 3),
    );
  }

  void openChat() {
    _snackbarService.showSnackbar(
      message: 'Live chat coming soon!',
      duration: const Duration(seconds: 2),
    );
  }
}
