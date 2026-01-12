import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import 'fund_viewmodel.dart';

class WithdrawFundsView extends StackedView<FundViewModel> {
  const WithdrawFundsView({super.key});

  @override
  Widget builder(BuildContext context, FundViewModel viewModel, Widget? child) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: 'Rs. ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Funds'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: viewModel.goBack,
        ),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBalanceInfo(context, viewModel, currencyFormat),
                  const SizedBox(height: 24),
                  _buildAmountInput(context, viewModel),
                  const SizedBox(height: 16),
                  _buildQuickAmounts(context, viewModel),
                  const SizedBox(height: 24),
                  _buildPaymentMethods(context, viewModel),
                  const SizedBox(height: 16),
                  _buildWithdrawalNote(context),
                  const SizedBox(height: 32),
                  _buildWithdrawButton(context, viewModel),
                ],
              ),
            ),
    );
  }

  Widget _buildBalanceInfo(BuildContext context, FundViewModel viewModel, NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.profit.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.profit.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet, color: AppColors.profit),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available to Withdraw',
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                currencyFormat.format(viewModel.walletBalance),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.profit,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildAmountInput(BuildContext context, FundViewModel viewModel) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: 'Rs. ');
    final insufficientFunds = viewModel.parsedAmount != null &&
        viewModel.parsedAmount! > viewModel.walletBalance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter Amount',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          onChanged: viewModel.setAmount,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            prefixText: 'Rs. ',
            prefixStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            hintText: '0.00',
            hintStyle: TextStyle(
              color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            errorText: insufficientFunds ? 'Insufficient balance' : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
          ),
        ),
        if (viewModel.walletBalance > 0) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => viewModel.setQuickAmount(viewModel.walletBalance),
            child: Text(
              'Withdraw all (${currencyFormat.format(viewModel.walletBalance)})',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ],
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildQuickAmounts(BuildContext context, FundViewModel viewModel) {
    final amounts = [500, 1000, 2000, 5000];
    final availableAmounts = amounts.where((a) => a <= viewModel.walletBalance).toList();

    if (availableAmounts.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: availableAmounts.map((amount) {
        return InkWell(
          onTap: () => viewModel.setQuickAmount(amount.toDouble()),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Text(
              'Rs. $amount',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 150.ms);
  }

  Widget _buildPaymentMethods(BuildContext context, FundViewModel viewModel) {
    // For withdrawals, typically only bank transfer is available
    final withdrawalMethods = [PaymentMethod.netBanking, PaymentMethod.upi];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Withdraw To',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: withdrawalMethods.map((method) {
              final isSelected = viewModel.selectedPaymentMethod == method;
              final isLast = method == withdrawalMethods.last;
              return InkWell(
                onTap: () => viewModel.setPaymentMethod(method),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: !isLast
                          ? BorderSide(color: AppColors.borderLight.withValues(alpha: 0.5))
                          : BorderSide.none,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getPaymentIcon(method),
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          method.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.borderLight,
                            width: 2,
                          ),
                          color: isSelected ? AppColors.primary : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 16)
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  IconData _getPaymentIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.upi:
        return Icons.qr_code;
      case PaymentMethod.netBanking:
        return Icons.account_balance;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.wallet:
        return Icons.account_balance_wallet;
    }
  }

  Widget _buildWithdrawalNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.warning, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Withdrawal requests are typically processed within 24-48 hours on business days.',
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 250.ms);
  }

  Widget _buildWithdrawButton(BuildContext context, FundViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: viewModel.canWithdraw && !viewModel.isProcessing
            ? viewModel.withdrawFunds
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.loss,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: AppColors.loss.withValues(alpha: 0.5),
        ),
        child: viewModel.isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Withdraw Funds',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  @override
  FundViewModel viewModelBuilder(BuildContext context) => FundViewModel();

  @override
  void onViewModelReady(FundViewModel viewModel) => viewModel.initialize();
}
