import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../l10n/app_localizations.dart';
import 'terms_of_service_viewmodel.dart';

class TermsOfServiceView extends StackedView<TermsOfServiceViewModel> {
  const TermsOfServiceView({super.key});

  @override
  Widget builder(
    BuildContext context,
    TermsOfServiceViewModel viewModel,
    Widget? child,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.termsOfService),
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
              l10n.termsOfService,
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
              '1. Acceptance of Terms',
              'By accessing and using this application, you accept and agree to be bound by the terms and provisions of this agreement. If you do not agree to these terms, please do not use this application.',
            ),
            _buildSection(
              context,
              '2. Eligibility',
              'To use our services, you must:\n\n'
              '- Be at least 18 years of age\n'
              '- Be a resident of India\n'
              '- Have a valid PAN card\n'
              '- Complete the KYC verification process\n'
              '- Have a valid bank account linked to your trading account',
            ),
            _buildSection(
              context,
              '3. Account Registration',
              'You agree to:\n\n'
              '- Provide accurate and complete information during registration\n'
              '- Maintain the security of your account credentials\n'
              '- Notify us immediately of any unauthorized access\n'
              '- Be responsible for all activities under your account',
            ),
            _buildSection(
              context,
              '4. Trading Services',
              'Our platform provides stock trading services subject to:\n\n'
              '- SEBI regulations and guidelines\n'
              '- Stock exchange rules (NSE, BSE)\n'
              '- Market hours and trading holidays\n'
              '- Available margin and funds in your account',
            ),
            _buildSection(
              context,
              '5. Risks and Disclaimers',
              'Trading in securities involves significant risks:\n\n'
              '- Past performance does not guarantee future results\n'
              '- You may lose some or all of your invested capital\n'
              '- Market conditions can change rapidly\n'
              '- We do not provide investment advice\n'
              '- AI suggestions are for informational purposes only',
            ),
            _buildSection(
              context,
              '6. Fees and Charges',
              'You agree to pay applicable fees including:\n\n'
              '- Brokerage charges on trades\n'
              '- Securities Transaction Tax (STT)\n'
              '- GST on brokerage\n'
              '- Exchange transaction charges\n'
              '- SEBI turnover fees\n'
              '- Stamp duty',
            ),
            _buildSection(
              context,
              '7. Prohibited Activities',
              'You agree not to:\n\n'
              '- Engage in market manipulation\n'
              '- Use the platform for illegal activities\n'
              '- Share your account credentials\n'
              '- Attempt to hack or disrupt our services\n'
              '- Violate any applicable laws or regulations',
            ),
            _buildSection(
              context,
              '8. Intellectual Property',
              'All content, features, and functionality of this application are owned by us and are protected by copyright, trademark, and other intellectual property laws.',
            ),
            _buildSection(
              context,
              '9. Limitation of Liability',
              'We shall not be liable for:\n\n'
              '- Trading losses incurred by you\n'
              '- Service interruptions or technical failures\n'
              '- Unauthorized access to your account\n'
              '- Any indirect or consequential damages',
            ),
            _buildSection(
              context,
              '10. Termination',
              'We reserve the right to terminate or suspend your account at any time for violation of these terms or for any other reason at our discretion.',
            ),
            _buildSection(
              context,
              '11. Governing Law',
              'These terms shall be governed by and construed in accordance with the laws of India. Any disputes shall be subject to the exclusive jurisdiction of courts in Mumbai.',
            ),
            _buildSection(
              context,
              '12. Contact Information',
              'For questions about these Terms of Service, please contact us at:\n\n'
              'Email: legal@stockmarketapp.com\n'
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
  TermsOfServiceViewModel viewModelBuilder(BuildContext context) =>
      TermsOfServiceViewModel();
}
