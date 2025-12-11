import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/watchlist_model.dart';
import 'watchlist_viewmodel.dart';

class WatchlistView extends StackedView<WatchlistViewModel> {
  const WatchlistView({super.key});

  @override
  Widget builder(BuildContext context, WatchlistViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: [
          if (viewModel.watchlistItems.isNotEmpty)
            IconButton(
              icon: Icon(viewModel.isEditing ? Icons.check : Icons.edit_outlined),
              onPressed: viewModel.toggleEditMode,
            ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: viewModel.openSearch,
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.watchlistItems.isEmpty
              ? _buildEmptyState(context, viewModel)
              : RefreshIndicator(
                  onRefresh: viewModel.refreshData,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: viewModel.watchlistItems.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: 76,
                      color: AppColors.borderLight.withValues(alpha: 0.5),
                    ),
                    itemBuilder: (context, index) {
                      final item = viewModel.watchlistItems[index];
                      return _buildWatchlistItem(context, item, viewModel, index);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WatchlistViewModel viewModel) {
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
                Icons.bookmark_border_rounded,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Watchlist is Empty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add stocks to your watchlist to track them easily',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: viewModel.openSearch,
              icon: const Icon(Icons.search_rounded),
              label: const Text('Search Stocks'),
            ),
          ],
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildWatchlistItem(
    BuildContext context,
    WatchlistItem item,
    WatchlistViewModel viewModel,
    int index,
  ) {
    final isProfit = item.change >= 0;
    final color = isProfit ? AppColors.profit : AppColors.loss;

    return InkWell(
      onTap: () => viewModel.openStockDetails(item.symbol),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (viewModel.isEditing) ...[
              IconButton(
                icon: const Icon(Icons.remove_circle, color: AppColors.error),
                onPressed: () => viewModel.removeFromWatchlist(item.symbol),
              ),
              const SizedBox(width: 8),
            ],
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  item.symbol[0],
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
                    item.symbol,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.name,
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
                  Formatters.formatCurrency(item.currentPrice),
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
                      '${isProfit ? '+' : ''}${item.changePercent.toStringAsFixed(2)}%',
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
  WatchlistViewModel viewModelBuilder(BuildContext context) => WatchlistViewModel();

  @override
  void onViewModelReady(WatchlistViewModel viewModel) => viewModel.initialize();
}
