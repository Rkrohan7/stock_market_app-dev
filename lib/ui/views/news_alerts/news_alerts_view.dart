import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../core/theme/app_colors.dart';
import 'news_alerts_viewmodel.dart';

class NewsAlertsView extends StackedView<NewsAlertsViewModel> {
  const NewsAlertsView({super.key});

  @override
  Widget builder(
      BuildContext context, NewsAlertsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Alerts'),
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
                  _buildCreateAlertSection(context, viewModel),
                  const SizedBox(height: 24),
                  _buildActiveAlertsSection(context, viewModel),
                ],
              ),
            ),
    );
  }

  Widget _buildCreateAlertSection(
      BuildContext context, NewsAlertsViewModel viewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create News Alert',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Keyword Input
            Text(
              'Keyword (optional)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'e.g., "dividend", "quarterly results"',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: viewModel.setKeyword,
            ),
            const SizedBox(height: 16),

            // Categories Selection
            Text(
              'Categories',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: viewModel.availableCategories
                  .where((c) => c != 'All')
                  .map((category) {
                final isSelected =
                    viewModel.selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) => viewModel.toggleCategory(category),
                  selectedColor: AppColors.primary,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Stock Symbols
            Text(
              'Related Stocks',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search stocks to add...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: viewModel.isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
              onChanged: viewModel.setSearchQuery,
            ),
            if (viewModel.searchResults.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 150),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewModel.searchResults.length,
                  itemBuilder: (context, index) {
                    final stock = viewModel.searchResults[index];
                    return ListTile(
                      dense: true,
                      title: Text(stock.symbol),
                      subtitle: Text(stock.name),
                      onTap: () => viewModel.addSymbol(stock),
                    );
                  },
                ),
              ),
            ],
            if (viewModel.selectedSymbols.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: viewModel.selectedSymbols.map((symbol) {
                  return Chip(
                    label: Text(symbol),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => viewModel.removeSymbol(symbol),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),

            // Breaking News Only Toggle
            SwitchListTile(
              title: const Text('Breaking News Only'),
              subtitle: const Text('Only notify for breaking news'),
              value: viewModel.breakingNewsOnly,
              onChanged: viewModel.toggleBreakingNewsOnly,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary;
                }
                return null;
              }),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),

            // Create Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: viewModel.hasValidInput ? viewModel.createAlert : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Create Alert'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveAlertsSection(
      BuildContext context, NewsAlertsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Alerts',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '${viewModel.alerts.length} alerts',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (viewModel.alerts.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.article_outlined,
                      size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'No news alerts',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create one to get notified about market news',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.alerts.length,
            itemBuilder: (context, index) {
              final alert = viewModel.alerts[index];
              return _buildAlertCard(context, viewModel, alert);
            },
          ),
      ],
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    NewsAlertsViewModel viewModel,
    alert,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                alert.breakingNewsOnly
                    ? Icons.flash_on
                    : Icons.article_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getAlertTitle(alert),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    alert.alertDescription,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Switch(
              value: alert.isActive,
              onChanged: (value) =>
                  viewModel.toggleAlertActive(alert.id, value),
              activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary;
                }
                return null;
              }),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => viewModel.deleteAlert(alert.id),
              color: Colors.red.shade400,
            ),
          ],
        ),
      ),
    );
  }

  String _getAlertTitle(dynamic alert) {
    if (alert.keyword != null && alert.keyword!.isNotEmpty) {
      return 'Keyword: "${alert.keyword}"';
    }
    if (alert.breakingNewsOnly) {
      return 'Breaking News';
    }
    if (alert.categories.isNotEmpty) {
      return alert.categories.join(', ');
    }
    if (alert.symbols.isNotEmpty) {
      return 'Stocks: ${alert.symbols.join(", ")}';
    }
    return 'News Alert';
  }

  @override
  NewsAlertsViewModel viewModelBuilder(BuildContext context) =>
      NewsAlertsViewModel();

  @override
  void onViewModelReady(NewsAlertsViewModel viewModel) {
    viewModel.initialize();
  }
}
