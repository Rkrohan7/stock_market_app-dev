import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import 'portfolio_viewmodel.dart';

class PortfolioView extends StackedView<PortfolioViewModel> {
  const PortfolioView({super.key});

  @override
  Widget builder(BuildContext context, PortfolioViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: viewModel.openOrderHistory,
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.holdings.isEmpty
              ? _buildEmptyState(context, viewModel)
              : RefreshIndicator(
                  onRefresh: viewModel.refreshData,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryCard(context, viewModel),
                        const SizedBox(height: 24),
                        _buildPortfolioChart(context, viewModel),
                        const SizedBox(height: 24),
                        _buildHoldingsList(context, viewModel),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context, PortfolioViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.pie_chart_outline_rounded,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Holdings Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start building your portfolio by buying your first stock',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: viewModel.startInvesting,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Start Investing'),
            ),
          ],
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildSummaryCard(BuildContext context, PortfolioViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Value',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            Formatters.formatCurrency(viewModel.currentValue),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryItem('Invested', viewModel.totalInvestment),
              const SizedBox(width: 24),
              _buildSummaryItem(
                'P&L',
                viewModel.totalPnL,
                isProfit: viewModel.totalPnL >= 0,
              ),
              const SizedBox(width: 24),
              _buildSummaryItem(
                'Returns',
                viewModel.totalPnLPercent,
                isPercent: true,
                isProfit: viewModel.totalPnLPercent >= 0,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildSummaryItem(
    String label,
    double value, {
    bool isPercent = false,
    bool? isProfit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          isPercent
              ? '${value >= 0 ? '+' : ''}${value.toStringAsFixed(2)}%'
              : Formatters.formatCurrency(value),
          style: TextStyle(
            color: isProfit == null
                ? Colors.white
                : (isProfit ? Colors.greenAccent : Colors.redAccent),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioChart(BuildContext context, PortfolioViewModel viewModel) {
    // If no chart data, show placeholder
    if (viewModel.chartData.isEmpty) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'No portfolio data yet',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 14,
            ),
          ),
        ),
      ).animate().fadeIn(delay: 200.ms);
    }

    // Calculate min and max Y values for better chart display
    final yValues = viewModel.chartData.map((spot) => spot.y).toList();
    final minY = yValues.reduce((a, b) => a < b ? a : b);
    final maxY = yValues.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1; // 10% padding

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          minY: minY - padding,
          maxY: maxY + padding,
          minX: 0,
          maxX: viewModel.chartData.length.toDouble() - 1,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: viewModel.chartData,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildHoldingsList(BuildContext context, PortfolioViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Holdings (${viewModel.holdings.length})',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...viewModel.holdings.asMap().entries.map((entry) {
          final index = entry.key;
          final holding = entry.value;
          return _buildHoldingItem(context, holding, viewModel)
              .animate()
              .fadeIn(delay: Duration(milliseconds: index * 50));
        }),
      ],
    );
  }

  Widget _buildHoldingItem(BuildContext context, dynamic holding, PortfolioViewModel viewModel) {
    final isProfit = holding.profitLoss >= 0;
    final color = isProfit ? AppColors.profit : AppColors.loss;

    return InkWell(
      onTap: () => viewModel.openStockDetails(holding.symbol),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      holding.symbol[0],
                      style: TextStyle(
                        color: AppColors.primary,
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
                      Text(
                        holding.symbol,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${holding.quantity} shares',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.formatCurrency(holding.currentValue),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                          color: color,
                          size: 12,
                        ),
                        Text(
                          '${isProfit ? '+' : ''}${holding.profitLossPercent.toStringAsFixed(2)}%',
                          style: TextStyle(color: color, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHoldingDetail('Avg. Cost', Formatters.formatCurrency(holding.averagePrice)),
                _buildHoldingDetail('LTP', Formatters.formatCurrency(holding.currentPrice)),
                _buildHoldingDetail(
                  'P&L',
                  '${isProfit ? '+' : ''}${Formatters.formatCurrency(holding.profitLoss)}',
                  valueColor: color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoldingDetail(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  @override
  PortfolioViewModel viewModelBuilder(BuildContext context) => PortfolioViewModel();

  @override
  void onViewModelReady(PortfolioViewModel viewModel) => viewModel.initialize();
}
