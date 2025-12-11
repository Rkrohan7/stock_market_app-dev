import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/common/stock_card.dart';
import 'market_viewmodel.dart';

class MarketView extends StackedView<MarketViewModel> {
  const MarketView({super.key});

  @override
  Widget builder(BuildContext context, MarketViewModel viewModel, Widget? child) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Market'),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondaryLight,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Gainers'),
              Tab(text: 'Losers'),
              Tab(text: 'Active'),
            ],
            onTap: (index) => viewModel.setTabIndex(index),
          ),
        ),
        body: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildStockList(viewModel.allStocks, viewModel),
                  _buildStockList(viewModel.topGainers, viewModel),
                  _buildStockList(viewModel.topLosers, viewModel),
                  _buildStockList(viewModel.mostActive, viewModel),
                ],
              ),
      ),
    );
  }

  Widget _buildStockList(List stocks, MarketViewModel viewModel) {
    if (stocks.isEmpty) {
      return const Center(child: Text('No stocks found'));
    }

    return RefreshIndicator(
      onRefresh: viewModel.refreshData,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: stocks.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 76,
          color: AppColors.borderLight.withValues(alpha: 0.5),
        ),
        itemBuilder: (context, index) {
          final stock = stocks[index];
          return StockListItem(
            symbol: stock.symbol,
            name: stock.name,
            price: stock.currentPrice,
            change: stock.change,
            changePercent: stock.changePercent,
            onTap: () => viewModel.openStockDetails(stock.symbol),
          ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
        },
      ),
    );
  }

  @override
  MarketViewModel viewModelBuilder(BuildContext context) => MarketViewModel();

  @override
  void onViewModelReady(MarketViewModel viewModel) => viewModel.initialize();
}
