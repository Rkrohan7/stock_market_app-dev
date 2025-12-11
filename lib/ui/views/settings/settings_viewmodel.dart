import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../services/theme_service.dart';

class SettingsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _themeService = locator<ThemeService>();

  bool get isDarkMode => _themeService.isDarkMode;

  bool _pushNotifications = true;
  bool get pushNotifications => _pushNotifications;

  bool _priceAlerts = true;
  bool get priceAlerts => _priceAlerts;

  bool _newsAlerts = true;
  bool get newsAlerts => _newsAlerts;

  bool _biometricAuth = false;
  bool get biometricAuth => _biometricAuth;

  void toggleTheme() {
    _themeService.toggleTheme();
    notifyListeners();
  }

  void togglePushNotifications(bool value) {
    _pushNotifications = value;
    notifyListeners();
  }

  void togglePriceAlerts(bool value) {
    _priceAlerts = value;
    notifyListeners();
  }

  void toggleNewsAlerts(bool value) {
    _newsAlerts = value;
    notifyListeners();
  }

  void toggleBiometricAuth(bool value) {
    _biometricAuth = value;
    notifyListeners();
  }

  void goBack() {
    _navigationService.back();
  }
}
