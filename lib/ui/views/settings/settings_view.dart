import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../core/theme/app_colors.dart';
import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({super.key});

  @override
  Widget builder(BuildContext context, SettingsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: viewModel.goBack,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Appearance'),
            _buildSettingsTile(
              context,
              'Dark Mode',
              Icons.dark_mode_outlined,
              trailing: Switch(
                value: viewModel.isDarkMode,
                onChanged: (_) => viewModel.toggleTheme(),
                activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                activeThumbColor: AppColors.primary,
              ),
            ),
            _buildSectionHeader(context, 'Notifications'),
            _buildSettingsTile(
              context,
              'Push Notifications',
              Icons.notifications_outlined,
              trailing: Switch(
                value: viewModel.pushNotifications,
                onChanged: viewModel.togglePushNotifications,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                activeThumbColor: AppColors.primary,
              ),
            ),
            _buildSettingsTile(
              context,
              'Price Alerts',
              Icons.trending_up_rounded,
              trailing: Switch(
                value: viewModel.priceAlerts,
                onChanged: viewModel.togglePriceAlerts,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                activeThumbColor: AppColors.primary,
              ),
            ),
            _buildSettingsTile(
              context,
              'News Alerts',
              Icons.article_outlined,
              trailing: Switch(
                value: viewModel.newsAlerts,
                onChanged: viewModel.toggleNewsAlerts,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                activeThumbColor: AppColors.primary,
              ),
            ),
            _buildSectionHeader(context, 'Security'),
            _buildSettingsTile(
              context,
              'Biometric Authentication',
              Icons.fingerprint,
              trailing: Switch(
                value: viewModel.biometricAuth,
                onChanged: viewModel.toggleBiometricAuth,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                activeThumbColor: AppColors.primary,
              ),
            ),
            _buildSettingsTile(
              context,
              'Change PIN',
              Icons.pin_outlined,
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              'Change Password',
              Icons.lock_outline,
              onTap: () {},
            ),
            _buildSectionHeader(context, 'General'),
            _buildSettingsTile(
              context,
              'Language',
              Icons.language_outlined,
              subtitle: 'English',
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              'Currency',
              Icons.currency_rupee_rounded,
              subtitle: 'INR (₹)',
              onTap: () {},
            ),
            _buildSectionHeader(context, 'Legal'),
            _buildSettingsTile(
              context,
              'Privacy Policy',
              Icons.privacy_tip_outlined,
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              'Terms of Service',
              Icons.description_outlined,
              onTap: () {},
            ),
            _buildSectionHeader(context, 'About'),
            _buildSettingsTile(
              context,
              'App Version',
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
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15),
                  ),
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

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) => SettingsViewModel();
}
