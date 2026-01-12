import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/enums/enums.dart';
import '../../../app/app.router.dart';
import 'trading_viewmodel.dart';
import 'order_success_view.dart';

class TradingView extends StackedView<TradingViewModel> {
  final String symbol;
  final bool isBuy;

  const TradingView({super.key, required this.symbol, required this.isBuy});

  @override
  Widget builder(BuildContext context, TradingViewModel viewModel, Widget? child) {
    final actionColor = isBuy ? AppColors.profit : AppColors.loss;

    // Show success screen after order is placed
    if (viewModel.orderSuccess) {
      return OrderSuccessView(
        isBuy: isBuy,
        symbol: symbol,
        stockName: viewModel.stock?.name ?? symbol,
        quantity: viewModel.quantity,
        price: viewModel.orderType == OrderType.market
            ? (viewModel.stock?.currentPrice ?? 0)
            : viewModel.limitPrice,
        totalValue: viewModel.totalValue,
        orderId: viewModel.orderId,
        onViewPortfolio: viewModel.navigateToPortfolio,
        onDone: viewModel.navigateToHome,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${isBuy ? 'Buy' : 'Sell'} ${viewModel.stock?.symbol ?? symbol}'),
        backgroundColor: actionColor,
        foregroundColor: Colors.white,
      ),
      body: viewModel.isBusy && viewModel.stock == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStockInfo(context, viewModel, actionColor),
                  const SizedBox(height: 24),
                  _buildOrderTypeSelector(context, viewModel),
                  const SizedBox(height: 24),
                  _buildProductTypeSelector(context, viewModel),
                  const SizedBox(height: 24),
                  _buildQuantityInput(context, viewModel),
                  const SizedBox(height: 24),
                  if (viewModel.orderType == OrderType.limit)
                    _buildPriceInput(context, viewModel),
                  const SizedBox(height: 24),
                  _buildOrderSummary(context, viewModel, actionColor),
                  const SizedBox(height: 100),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomBar(context, viewModel, actionColor),
    );
  }

  Widget _buildStockInfo(BuildContext context, TradingViewModel viewModel, Color actionColor) {
    if (viewModel.stock == null) return const SizedBox.shrink();

    final stock = viewModel.stock!;
    final isProfit = stock.change >= 0;
    final changeColor = isProfit ? AppColors.profit : AppColors.loss;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: actionColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: actionColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: actionColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                stock.symbol[0],
                style: TextStyle(
                  color: actionColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock.symbol,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  stock.name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.formatCurrency(stock.currentPrice),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                    color: changeColor,
                    size: 14,
                  ),
                  Text(
                    '${isProfit ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
                    style: TextStyle(color: changeColor, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildOrderTypeSelector(BuildContext context, TradingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOptionButton(
                context,
                'Market',
                Icons.flash_on,
                viewModel.orderType == OrderType.market,
                () => viewModel.setOrderType(OrderType.market),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOptionButton(
                context,
                'Limit',
                Icons.tune,
                viewModel.orderType == OrderType.limit,
                () => viewModel.setOrderType(OrderType.limit),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildProductTypeSelector(BuildContext context, TradingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOptionButton(
                context,
                'Delivery',
                Icons.inventory_2_outlined,
                viewModel.productType == ProductType.delivery,
                () => viewModel.setProductType(ProductType.delivery),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOptionButton(
                context,
                'Intraday',
                Icons.today,
                viewModel.productType == ProductType.intraday,
                () => viewModel.setProductType(ProductType.intraday),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildOptionButton(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : null,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityInput(BuildContext context, TradingViewModel viewModel) {
    final hasError = viewModel.quantityError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quantity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            // Show wallet balance for buy orders
            if (isBuy)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Balance: ₹${viewModel.walletBalance.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            // Show available shares for sell orders
            if (!isBuy)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Available: ${viewModel.availableQuantity}',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? AppColors.loss : AppColors.borderLight,
              width: hasError ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: viewModel.decrementQuantity,
                icon: const Icon(Icons.remove),
              ),
              Expanded(
                child: TextField(
                  controller: viewModel.quantityController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: hasError ? AppColors.loss : null,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                  ),
                  onChanged: viewModel.updateQuantity,
                ),
              ),
              IconButton(
                onPressed: viewModel.incrementQuantity,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        // Show error message
        if (hasError) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.error_outline, color: AppColors.loss, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  viewModel.quantityError!,
                  style: TextStyle(
                    color: AppColors.loss,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          // Show Add Funds button for insufficient balance
          if (viewModel.hasInsufficientBalance) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.addFundsView);
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Funds'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
        // Quick select buttons for sell
        if (!isBuy && viewModel.availableQuantity > 0) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              _buildQuickSelectButton(context, viewModel, '25%', (viewModel.availableQuantity * 0.25).floor()),
              const SizedBox(width: 8),
              _buildQuickSelectButton(context, viewModel, '50%', (viewModel.availableQuantity * 0.5).floor()),
              const SizedBox(width: 8),
              _buildQuickSelectButton(context, viewModel, '75%', (viewModel.availableQuantity * 0.75).floor()),
              const SizedBox(width: 8),
              _buildQuickSelectButton(context, viewModel, 'All', viewModel.availableQuantity),
            ],
          ),
        ],
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildQuickSelectButton(BuildContext context, TradingViewModel viewModel, String label, int qty) {
    return Expanded(
      child: InkWell(
        onTap: () {
          viewModel.quantityController.text = qty.toString();
          viewModel.updateQuantity(qty.toString());
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceInput(BuildContext context, TradingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Limit Price',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text('₹', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: viewModel.priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0.00',
                  ),
                  onChanged: viewModel.updateLimitPrice,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildOrderSummary(BuildContext context, TradingViewModel viewModel, Color actionColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Quantity', '${viewModel.quantity} shares'),
          _buildSummaryRow(
            'Price',
            viewModel.orderType == OrderType.market
                ? 'Market Price'
                : Formatters.formatCurrency(viewModel.limitPrice),
          ),
          _buildSummaryRow('Estimated Value', Formatters.formatCurrency(viewModel.estimatedValue)),
          _buildSummaryRow('Brokerage & Taxes', Formatters.formatCurrency(viewModel.brokerage)),
          const Divider(),
          _buildSummaryRow(
            'Total ${isBuy ? 'Payable' : 'Receivable'}',
            Formatters.formatCurrency(viewModel.totalValue),
            isBold: true,
            valueColor: actionColor,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: valueColor,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, TradingViewModel viewModel, Color actionColor) {
    // Determine if button should be clickable for KYC message
    final bool canShowKycMessage = !viewModel.isUserVerified && viewModel.quantity > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: viewModel.isBusy
              ? null
              : (viewModel.canPlaceOrder
                  ? viewModel.placeOrder
                  : (canShowKycMessage ? viewModel.showKycPendingMessage : null)),
          style: ElevatedButton.styleFrom(
            backgroundColor: actionColor,
            disabledBackgroundColor: actionColor.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: viewModel.isBusy
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  '${isBuy ? 'BUY' : 'SELL'} ${viewModel.quantity > 0 ? viewModel.quantity : ''} ${viewModel.stock?.symbol ?? symbol}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  TradingViewModel viewModelBuilder(BuildContext context) =>
      TradingViewModel(symbol: symbol, isBuy: isBuy);

  @override
  void onViewModelReady(TradingViewModel viewModel) => viewModel.initialize();
}
