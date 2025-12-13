import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';

class AboutViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  void goBack() {
    _navigationService.back();
  }

  void openPrivacyPolicy() {
    _snackbarService.showSnackbar(
      message: 'Privacy Policy coming soon!',
      duration: const Duration(seconds: 2),
    );
  }

  void openTermsOfService() {
    _snackbarService.showSnackbar(
      message: 'Terms of Service coming soon!',
      duration: const Duration(seconds: 2),
    );
  }

  void openLicenses() {
    _navigationService.navigateToView(const LicensePage(
      applicationName: 'Stock Trading App',
      applicationVersion: '1.0.0',
    ));
  }

  void openWebsite() {
    _snackbarService.showSnackbar(
      message: 'Website: www.stockapp.com',
      duration: const Duration(seconds: 2),
    );
  }

  void openEmail() {
    _snackbarService.showSnackbar(
      message: 'Email: contact@stockapp.com',
      duration: const Duration(seconds: 2),
    );
  }

  void shareApp() {
    _snackbarService.showSnackbar(
      message: 'Share feature coming soon!',
      duration: const Duration(seconds: 2),
    );
  }
}
