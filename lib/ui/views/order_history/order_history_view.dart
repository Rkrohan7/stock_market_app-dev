import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/enums/enums.dart';
import '../../../data/models/order_model.dart';
import 'order_history_viewmodel.dart';

class OrderHistoryView extends StackedView<OrderHistoryViewModel> {
  const OrderHistoryView({super.key});

  @override
  Widget builder(
    BuildContext context,
    OrderHistoryViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: viewModel.goBack,
        ),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: viewModel.refreshData,
              child: Column(
                children: [
                  _buildFilterChips(context, viewModel),
                  Expanded(
                    child: viewModel.orders.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: viewModel.orders.length,
                            itemBuilder: (context, index) {
                              final order = viewModel.orders[index];
                              return _buildOrderCard(
                                context,
                                viewModel,
                                order,
                                index,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFilterChips(
    BuildContext context,
    OrderHistoryViewModel viewModel,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: viewModel.filters.map((filter) {
            final isSelected = viewModel.selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (_) => viewModel.setFilter(filter),
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
                backgroundColor: Theme.of(context).cardColor,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textPrimaryLight,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your order history will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    OrderHistoryViewModel viewModel,
    OrderModel order,
    int index,
  ) {
    final isBuy = order.orderSide == OrderSide.buy;
    final actionColor = isBuy ? AppColors.profit : AppColors.loss;
    final statusColor = _getStatusColor(order.status);

    return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => viewModel.openStockDetails(order.symbol),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: actionColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            order.symbol[0],
                            style: TextStyle(
                              color: actionColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  order.symbol,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: actionColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    isBuy ? 'BUY' : 'SELL',
                                    style: TextStyle(
                                      color: actionColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              order.stockName,
                              style: TextStyle(
                                color: AppColors.textSecondaryLight,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              order.status.name.toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem('Qty', '${order.quantity}'),
                      _buildDetailItem(
                        'Price',
                        Formatters.formatCurrency(order.price),
                      ),
                      _buildDetailItem(
                        'Total',
                        Formatters.formatCurrency(order.totalValue),
                      ),
                      _buildDetailItem(
                        'Type',
                        order.orderType.name.toUpperCase(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatters.formatDateTime(order.createdAt),
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 11,
                        ),
                      ),
                      if (order.status == OrderStatus.pending)
                        TextButton(
                          onPressed: () => viewModel.cancelOrder(order),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.loss,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 50 * index))
        .slideX(begin: 0.1, end: 0);
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.executed:
        return AppColors.profit;
      case OrderStatus.cancelled:
        return AppColors.loss;
      case OrderStatus.rejected:
        return AppColors.error;
      case OrderStatus.partiallyFilled:
        return Colors.blue;
    }
  }

  @override
  OrderHistoryViewModel viewModelBuilder(BuildContext context) =>
      OrderHistoryViewModel();

  @override
  void onViewModelReady(OrderHistoryViewModel viewModel) =>
      viewModel.initialize();
}
