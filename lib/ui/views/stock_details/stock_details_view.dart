import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:candlesticks/candlesticks.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import 'stock_details_viewmodel.dart';

class StockDetailsView extends StackedView<StockDetailsViewModel> {
  final String symbol;

  const StockDetailsView({super.key, required this.symbol});

  @override
  Widget builder(BuildContext context, StockDetailsViewModel viewModel, Widget? child) {
    return Scaffold(
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.stock == null
              ? _buildErrorState(context, viewModel)
              : CustomScrollView(
                  slivers: [
                    _buildAppBar(context, viewModel),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPriceSection(context, viewModel),
                            const SizedBox(height: 24),
                            _buildChart(context, viewModel),
                            const SizedBox(height: 24),
                            _buildStockInfo(context, viewModel),
                            const SizedBox(height: 24),
                            _buildAboutSection(context, viewModel),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: viewModel.stock != null
          ? _buildBottomBar(context, viewModel)
          : null,
    );
  }

  Widget _buildAppBar(BuildContext context, StockDetailsViewModel viewModel) {
    return SliverAppBar(
      pinned: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(viewModel.stock!.symbol),
          Text(
            viewModel.stock!.name,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            viewModel.isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
            color: viewModel.isInWatchlist ? AppColors.primary : null,
          ),
          onPressed: viewModel.toggleWatchlist,
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, StockDetailsViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          const Text('Stock not found'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: viewModel.goBack,
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context, StockDetailsViewModel viewModel) {
    final stock = viewModel.stock!;
    final isProfit = stock.change >= 0;
    final color = isProfit ? AppColors.profit : AppColors.loss;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Formatters.formatCurrency(stock.currentPrice),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                    color: color,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${isProfit ? '+' : ''}${stock.change.toStringAsFixed(2)}',
                    style: TextStyle(color: color, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    ' (${isProfit ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%)',
                    style: TextStyle(color: color),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Today',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    ).animate().fadeIn();
  }

  Widget _buildChart(BuildContext context, StockDetailsViewModel viewModel) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: viewModel.isLoadingCandles
            ? const Center(child: CircularProgressIndicator())
            : viewModel.candles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.candlestick_chart_outlined,
                          size: 48,
                          color: AppColors.textSecondaryLight,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No chart data available',
                          style: TextStyle(color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  )
                : Candlesticks(
                    candles: viewModel.candles,
                    onLoadMoreCandles: () async {},
                    actions: [
                      ToolBarAction(
                        onPressed: () => viewModel.setTimeframe('1D'),
                        child: Text(
                          '1D',
                          style: TextStyle(
                            color: viewModel.selectedTimeframe == '1D'
                                ? AppColors.primary
                                : (isDarkMode ? Colors.white70 : Colors.black54),
                            fontWeight: viewModel.selectedTimeframe == '1D'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      ToolBarAction(
                        onPressed: () => viewModel.setTimeframe('1W'),
                        child: Text(
                          '1W',
                          style: TextStyle(
                            color: viewModel.selectedTimeframe == '1W'
                                ? AppColors.primary
                                : (isDarkMode ? Colors.white70 : Colors.black54),
                            fontWeight: viewModel.selectedTimeframe == '1W'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      ToolBarAction(
                        onPressed: () => viewModel.setTimeframe('1M'),
                        child: Text(
                          '1M',
                          style: TextStyle(
                            color: viewModel.selectedTimeframe == '1M'
                                ? AppColors.primary
                                : (isDarkMode ? Colors.white70 : Colors.black54),
                            fontWeight: viewModel.selectedTimeframe == '1M'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      ToolBarAction(
                        onPressed: () => viewModel.setTimeframe('3M'),
                        child: Text(
                          '3M',
                          style: TextStyle(
                            color: viewModel.selectedTimeframe == '3M'
                                ? AppColors.primary
                                : (isDarkMode ? Colors.white70 : Colors.black54),
                            fontWeight: viewModel.selectedTimeframe == '3M'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      ToolBarAction(
                        onPressed: () => viewModel.setTimeframe('1Y'),
                        child: Text(
                          '1Y',
                          style: TextStyle(
                            color: viewModel.selectedTimeframe == '1Y'
                                ? AppColors.primary
                                : (isDarkMode ? Colors.white70 : Colors.black54),
                            fontWeight: viewModel.selectedTimeframe == '1Y'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildStockInfo(BuildContext context, StockDetailsViewModel viewModel) {
    final stock = viewModel.stock!;

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
            'Stock Statistics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatItem('Open', Formatters.formatCurrency(stock.open))),
              Expanded(child: _buildStatItem('High', Formatters.formatCurrency(stock.high))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatItem('Low', Formatters.formatCurrency(stock.low))),
              Expanded(child: _buildStatItem('Prev Close', Formatters.formatCurrency(stock.previousClose))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatItem('Volume', Formatters.formatVolume(stock.volume))),
              Expanded(child: _buildStatItem('52W High', Formatters.formatCurrency(stock.high52Week))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatItem('52W Low', Formatters.formatCurrency(stock.low52Week))),
              Expanded(child: _buildStatItem('Market Cap', Formatters.formatMarketCap(stock.marketCap))),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, StockDetailsViewModel viewModel) {
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
            'About ${viewModel.stock!.symbol}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            viewModel.stock!.description.isEmpty
                ? 'No description available.'
                : viewModel.stock!.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(Icons.category_outlined, viewModel.stock!.sector.isEmpty ? 'N/A' : viewModel.stock!.sector),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.business_outlined, viewModel.stock!.industry.isEmpty ? 'N/A' : viewModel.stock!.industry),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, StockDetailsViewModel viewModel) {
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
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: viewModel.openSellView,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.loss),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'SELL',
                  style: TextStyle(
                    color: AppColors.loss,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: viewModel.openBuyView,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.profit,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'BUY',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  StockDetailsViewModel viewModelBuilder(BuildContext context) =>
      StockDetailsViewModel(symbol: symbol);

  @override
  void onViewModelReady(StockDetailsViewModel viewModel) => viewModel.initialize();
}
