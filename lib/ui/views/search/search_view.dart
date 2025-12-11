import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/stock_model.dart';
import 'search_viewmodel.dart';

class SearchView extends StackedView<SearchViewModel> {
  const SearchView({super.key});

  @override
  Widget builder(BuildContext context, SearchViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: viewModel.searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search stocks...',
            border: InputBorder.none,
            suffixIcon: viewModel.searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: viewModel.clearSearch,
                  )
                : null,
          ),
          onChanged: viewModel.search,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: viewModel.goBack,
        ),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.searchController.text.isEmpty
              ? _buildDefaultContent(context, viewModel)
              : _buildSearchResults(context, viewModel),
    );
  }

  Widget _buildDefaultContent(BuildContext context, SearchViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // Clear all recent searches
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: viewModel.recentSearches.map((symbol) {
                return InkWell(
                  onTap: () => viewModel.openStockDetails(symbol),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          symbol,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => viewModel.removeFromRecentSearches(symbol),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
          Text(
            'Trending Stocks',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...viewModel.trendingStocks.asMap().entries.map((entry) {
            final index = entry.key;
            final stock = entry.value;
            return _buildStockItem(context, stock, viewModel, index);
          }),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, SearchViewModel viewModel) {
    if (viewModel.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No stocks found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with a different keyword',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: viewModel.searchResults.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 76,
        color: AppColors.borderLight.withValues(alpha: 0.5),
      ),
      itemBuilder: (context, index) {
        final stock = viewModel.searchResults[index];
        return _buildStockItem(context, stock, viewModel, index);
      },
    );
  }

  Widget _buildStockItem(
    BuildContext context,
    StockModel stock,
    SearchViewModel viewModel,
    int index,
  ) {
    final isProfit = stock.change >= 0;
    final color = isProfit ? AppColors.profit : AppColors.loss;

    return InkWell(
      onTap: () => viewModel.openStockDetails(stock.symbol),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
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
                  stock.symbol[0],
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
                    stock.symbol,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    stock.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryLight,
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
                Text(
                  Formatters.formatCurrency(stock.currentPrice),
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
                      '${isProfit ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
                      style: TextStyle(color: color, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
  }

  @override
  SearchViewModel viewModelBuilder(BuildContext context) => SearchViewModel();

  @override
  void onViewModelReady(SearchViewModel viewModel) => viewModel.initialize();
}
