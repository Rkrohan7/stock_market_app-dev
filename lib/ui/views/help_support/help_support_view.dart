import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import 'help_support_viewmodel.dart';

class HelpSupportView extends StackedView<HelpSupportViewModel> {
  const HelpSupportView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HelpSupportViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
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
            _buildSearchBar(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Quick Help'),
            const SizedBox(height: 12),
            _buildQuickHelpCards(context, viewModel),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'FAQs'),
            const SizedBox(height: 12),
            _buildFaqSection(context, viewModel),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Contact Us'),
            const SizedBox(height: 12),
            _buildContactSection(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for help...',
          hintStyle: TextStyle(color: AppColors.textSecondaryLight),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondaryLight),
          border: InputBorder.none,
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildQuickHelpCards(
      BuildContext context, HelpSupportViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickHelpCard(
            context,
            'Getting Started',
            Icons.play_circle_outline,
            () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickHelpCard(
            context,
            'Trading Guide',
            Icons.trending_up,
            () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickHelpCard(
            context,
            'Account',
            Icons.person_outline,
            () {},
          ),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildQuickHelpCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context, HelpSupportViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildFaqItem(
            context,
            'How do I start trading?',
            'To start trading, complete your KYC verification, add funds to your account, and then you can buy or sell stocks from the market section.',
            viewModel,
            0,
          ),
          _buildDivider(),
          _buildFaqItem(
            context,
            'How to add funds to my account?',
            'Go to Profile > Funds > Add Funds. You can add funds using UPI, Net Banking, or Debit Card.',
            viewModel,
            1,
          ),
          _buildDivider(),
          _buildFaqItem(
            context,
            'What are the trading hours?',
            'The Indian stock market operates from 9:15 AM to 3:30 PM on weekdays (Monday to Friday), excluding market holidays.',
            viewModel,
            2,
          ),
          _buildDivider(),
          _buildFaqItem(
            context,
            'How to withdraw funds?',
            'Go to Profile > Funds > Withdraw. Enter the amount and confirm. Funds will be credited to your linked bank account within 24-48 hours.',
            viewModel,
            3,
          ),
          _buildDivider(),
          _buildFaqItem(
            context,
            'How is brokerage calculated?',
            'We charge a flat fee of ₹20 per executed order or 0.03% of trade value, whichever is lower. Delivery trades are free.',
            viewModel,
            4,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildFaqItem(
    BuildContext context,
    String question,
    String answer,
    HelpSupportViewModel viewModel,
    int index,
  ) {
    final isExpanded = viewModel.expandedFaqIndex == index;
    return InkWell(
      onTap: () => viewModel.toggleFaq(index),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondaryLight,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              Text(
                answer,
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(
      BuildContext context, HelpSupportViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildContactItem(
            context,
            'Email Support',
            'support@stockapp.com',
            Icons.email_outlined,
            viewModel.openEmail,
          ),
          _buildDivider(),
          _buildContactItem(
            context,
            'Call Us',
            '+91 1800-XXX-XXXX',
            Icons.phone_outlined,
            viewModel.openPhone,
          ),
          _buildDivider(),
          _buildContactItem(
            context,
            'Live Chat',
            'Chat with our support team',
            Icons.chat_outlined,
            viewModel.openChat,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildContactItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: AppColors.borderLight.withValues(alpha: 0.5),
    );
  }

  @override
  HelpSupportViewModel viewModelBuilder(BuildContext context) =>
      HelpSupportViewModel();
}
