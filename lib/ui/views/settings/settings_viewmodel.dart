import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/theme_service.dart';
import '../../../services/alert_service.dart';
import '../../../services/localization_service.dart';

class SettingsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _themeService = locator<ThemeService>();
  final _alertService = locator<AlertService>();
  final _localizationService = locator<LocalizationService>();

  bool get isDarkMode => _themeService.isDarkMode;

  // Language
  String get currentLanguageName => _localizationService.currentLanguageName;
  String get currentLanguageCode => _localizationService.currentLanguageCode;

  bool _pushNotifications = true;
  bool get pushNotifications => _pushNotifications;

  bool _priceAlerts = true;
  bool get priceAlerts => _priceAlerts;

  bool _newsAlerts = true;
  bool get newsAlerts => _newsAlerts;

  // Alert counts for display
  int get activePriceAlertsCount => _alertService.activePriceAlertsCount;
  int get activeNewsAlertsCount => _alertService.activeNewsAlertsCount;

  Future<void> initialize() async {
    setBusy(true);

    // Load preferences from AlertService
    _pushNotifications = await _alertService.getPushNotificationsEnabled();
    _priceAlerts = await _alertService.getPriceAlertsEnabled();
    _newsAlerts = await _alertService.getNewsAlertsEnabled();

    setBusy(false);
    notifyListeners();
  }

  void toggleTheme() {
    _themeService.toggleTheme();
    notifyListeners();
  }

  Future<void> togglePushNotifications(bool value) async {
    _pushNotifications = value;
    notifyListeners();
    await _alertService.setPushNotificationsEnabled(value);
  }

  Future<void> togglePriceAlerts(bool value) async {
    _priceAlerts = value;
    notifyListeners();
    await _alertService.setPriceAlertsEnabled(value);
  }

  Future<void> toggleNewsAlerts(bool value) async {
    _newsAlerts = value;
    notifyListeners();
    await _alertService.setNewsAlertsEnabled(value);
  }

  void navigateToPriceAlerts() {
    _navigationService.navigateTo(Routes.priceAlertsView);
  }

  void navigateToNewsAlerts() {
    _navigationService.navigateTo(Routes.newsAlertsView);
  }

  void goBack() {
    _navigationService.back();
  }

  void navigateToPrivacyPolicy() {
    _navigationService.navigateTo(Routes.privacyPolicyView);
  }

  void navigateToTermsOfService() {
    _navigationService.navigateTo(Routes.termsOfServiceView);
  }

  // Language selection
  Future<void> setLanguage(String languageCode) async {
    await _localizationService.setLanguageCode(languageCode);
    notifyListeners();
  }

  void showLanguageSelector(Function(String) onLanguageSelected) {
    // This will be called from the view to show language options
  }
}
