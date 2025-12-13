import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../l10n/app_localizations.dart';
import 'privacy_policy_viewmodel.dart';

class PrivacyPolicyView extends StackedView<PrivacyPolicyViewModel> {
  const PrivacyPolicyView({super.key});

  @override
  Widget builder(
    BuildContext context,
    PrivacyPolicyViewModel viewModel,
    Widget? child,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: viewModel.goBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.privacyPolicy,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: December 2024',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '1. Information We Collect',
              'We collect information you provide directly to us, such as when you create an account, make a transaction, or contact us for support. This includes:\n\n'
              '- Personal information (name, email, phone number)\n'
              '- Financial information (bank account details, PAN card)\n'
              '- KYC documents (ID proof, address proof)\n'
              '- Transaction history and trading data',
            ),
            _buildSection(
              context,
              '2. How We Use Your Information',
              'We use the information we collect to:\n\n'
              '- Provide, maintain, and improve our services\n'
              '- Process transactions and send related information\n'
              '- Send technical notices, updates, and security alerts\n'
              '- Respond to your comments and questions\n'
              '- Comply with legal and regulatory requirements',
            ),
            _buildSection(
              context,
              '3. Information Sharing',
              'We do not sell, trade, or rent your personal information to third parties. We may share your information with:\n\n'
              '- Stock exchanges and depositories (as required for trading)\n'
              '- Regulatory authorities (SEBI, RBI) when required by law\n'
              '- Service providers who assist in our operations\n'
              '- Law enforcement when legally required',
            ),
            _buildSection(
              context,
              '4. Data Security',
              'We implement appropriate security measures to protect your personal information, including:\n\n'
              '- Encryption of sensitive data\n'
              '- Secure servers and firewalls\n'
              '- Regular security audits\n'
              '- Two-factor authentication',
            ),
            _buildSection(
              context,
              '5. Your Rights',
              'You have the right to:\n\n'
              '- Access your personal data\n'
              '- Correct inaccurate data\n'
              '- Request deletion of your data\n'
              '- Object to data processing\n'
              '- Data portability',
            ),
            _buildSection(
              context,
              '6. Cookies and Tracking',
              'We use cookies and similar tracking technologies to track activity on our app and hold certain information. You can instruct your browser to refuse all cookies or indicate when a cookie is being sent.',
            ),
            _buildSection(
              context,
              '7. Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at:\n\n'
              'Email: privacy@stockmarketapp.com\n'
              'Phone: +91 1800-XXX-XXXX',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  PrivacyPolicyViewModel viewModelBuilder(BuildContext context) =>
      PrivacyPolicyViewModel();
}
