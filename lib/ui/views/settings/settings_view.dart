import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: viewModel.goBack,
        ),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    context,
                    AppLocalizations.of(context)!.appearance,
                  ),
                  _buildSettingsTile(
                    context,
                    AppLocalizations.of(context)!.darkMode,
                    Icons.dark_mode_outlined,
                    trailing: Switch(
                      value: viewModel.isDarkMode,
                      onChanged: (_) => viewModel.toggleTheme(),
                      activeTrackColor: AppColors.primary.withValues(
                        alpha: 0.5,
                      ),
                      thumbColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primary;
                        }
                        return null;
                      }),
                    ),
                  ),
                  _buildSectionHeader(
                    context,
                    AppLocalizations.of(context)!.notifications,
                  ),
                  _buildSettingsTile(
                    context,
                    AppLocalizations.of(context)!.pushNotifications,
                    Icons.notifications_outlined,
                    trailing: Switch(
                      value: viewModel.pushNotifications,
                      onChanged: viewModel.togglePushNotifications,
                      activeTrackColor: AppColors.primary.withValues(
                        alpha: 0.5,
                      ),
                      thumbColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primary;
                        }
                        return null;
                      }),
                    ),
                  ),
                  _buildSettingsTile(
                    context,
                    AppLocalizations.of(context)!.priceAlerts,
                    Icons.trending_up_rounded,
                    subtitle: viewModel.activePriceAlertsCount > 0
                        ? AppLocalizations.of(
                            context,
                          )!.active(viewModel.activePriceAlertsCount)
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: viewModel.priceAlerts,
                          onChanged: viewModel.togglePriceAlerts,
                          activeTrackColor: AppColors.primary.withValues(
                            alpha: 0.5,
                          ),
                          thumbColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.primary;
                            }
                            return null;
                          }),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.textSecondaryLight,
                        ),
                      ],
                    ),
                    onTap: viewModel.navigateToPriceAlerts,
                  ),
                  _buildSettingsTile(
                    context,
                    AppLocalizations.of(context)!.newsAlerts,
                    Icons.article_outlined,
                    subtitle: viewModel.activeNewsAlertsCount > 0
                        ? AppLocalizations.of(
                            context,
                          )!.active(viewModel.activeNewsAlertsCount)
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: viewModel.newsAlerts,
                          onChanged: viewModel.toggleNewsAlerts,
                          activeTrackColor: AppColors.primary.withValues(
                            alpha: 0.5,
                          ),
                          thumbColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.primary;
                            }
                            return null;
                          }),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.textSecondaryLight,
                        ),
                      ],
                    ),
                    onTap: viewModel.navigateToNewsAlerts,
                  ),
                  _buildSectionHeader(
                    context,
                    AppLocalizations.of(context)!.general,
                  ),
                  _buildSettingsTile(
                    context,
                    AppLocalizations.of(context)!.language,
                    Icons.language_outlined,
                    subtitle: viewModel.currentLanguageName,
                    onTap: () => _showLanguageDialog(context, viewModel),
                  ),

                  _buildSectionHeader(
                    context,
                    AppLocalizations.of(context)!.legal,
                  ),
                  _buildSettingsTile(
                    context,
                    AppLocalizations.of(context)!.privacyPolicy,
                    Icons.privacy_tip_outlined,
                    onTap: viewModel.navigateToPrivacyPolicy,
                  ),
                  _buildSettingsTile(
                    context,
                    AppLocalizations.of(context)!.termsOfService,
                    Icons.description_outlined,
                    onTap: viewModel.navigateToTermsOfService,
                  ),
                  _buildSectionHeader(
                    context,
                    AppLocalizations.of(context)!.about,
                  ),
                  _buildSettingsTile(
                    context,
                    AppLocalizations.of(context)!.appVersion,
                    Icons.info_outline,
                    subtitle: '1.0.0',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon, {
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondaryLight, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15)),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondaryLight,
                ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Radio<String>(
                value: 'en',
                groupValue: viewModel.currentLanguageCode,
                onChanged: (value) {
                  viewModel.setLanguage(value!);
                  Navigator.pop(context);
                },
                activeColor: AppColors.primary,
              ),
              title: Text(l10n.english),
              onTap: () {
                viewModel.setLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Radio<String>(
                value: 'mr',
                groupValue: viewModel.currentLanguageCode,
                onChanged: (value) {
                  viewModel.setLanguage(value!);
                  Navigator.pop(context);
                },
                activeColor: AppColors.primary,
              ),
              title: Text(l10n.marathi),
              onTap: () {
                viewModel.setLanguage('mr');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) =>
      SettingsViewModel();

  @override
  void onViewModelReady(SettingsViewModel viewModel) {
    viewModel.initialize();
  }
}
