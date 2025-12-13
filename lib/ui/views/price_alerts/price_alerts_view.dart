import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../core/enums/enums.dart';
import '../../../core/theme/app_colors.dart';
import 'price_alerts_viewmodel.dart';

class PriceAlertsView extends StackedView<PriceAlertsViewModel> {
  const PriceAlertsView({super.key});

  @override
  Widget builder(
      BuildContext context, PriceAlertsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Alerts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: viewModel.goBack,
        ),
        actions: [
          if (viewModel.triggeredAlerts.isNotEmpty)
            TextButton(
              onPressed: viewModel.clearTriggeredAlerts,
              child: const Text('Clear Triggered'),
            ),
        ],
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
                  if (viewModel.triggeredAlerts.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildTriggeredAlertsSection(context, viewModel),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildCreateAlertSection(
      BuildContext context, PriceAlertsViewModel viewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Alert',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Stock Search
            if (viewModel.selectedStock == null) ...[
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a stock...',
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
                  constraints: const BoxConstraints(maxHeight: 200),
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
                        title: Text(stock.symbol),
                        subtitle: Text(stock.name),
                        trailing: Text(
                          '₹${stock.currentPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () => viewModel.selectStock(stock),
                      );
                    },
                  ),
                ),
              ],
            ] else ...[
              // Selected Stock Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.selectedStock!.symbol,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            viewModel.selectedStock!.name,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${viewModel.selectedStock!.currentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: viewModel.clearSelectedStock,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Alert Type Selection
              Text(
                'Alert Type',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AlertType.values.map((type) {
                  final isSelected = viewModel.selectedAlertType == type;
                  return ChoiceChip(
                    label: Text(type.displayName),
                    selected: isSelected,
                    onSelected: (_) => viewModel.setAlertType(type),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Target Value Input
              Text(
                viewModel.getAlertTypeDescription(viewModel.selectedAlertType),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  prefixText: viewModel.selectedAlertType == AlertType.percentageChange
                      ? ''
                      : '₹ ',
                  suffixText: viewModel.selectedAlertType == AlertType.percentageChange
                      ? '%'
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    viewModel.setTargetValue(parsed);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.createAlert,
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
          ],
        ),
      ),
    );
  }

  Widget _buildActiveAlertsSection(
      BuildContext context, PriceAlertsViewModel viewModel) {
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
              '${viewModel.activeAlerts.length} alerts',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (viewModel.activeAlerts.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'No active alerts',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.activeAlerts.length,
            itemBuilder: (context, index) {
              final alert = viewModel.activeAlerts[index];
              return _buildAlertCard(context, viewModel, alert);
            },
          ),
      ],
    );
  }

  Widget _buildTriggeredAlertsSection(
      BuildContext context, PriceAlertsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Triggered Alerts',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '${viewModel.triggeredAlerts.length} alerts',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: viewModel.triggeredAlerts.length,
          itemBuilder: (context, index) {
            final alert = viewModel.triggeredAlerts[index];
            return _buildAlertCard(context, viewModel, alert, isTriggered: true);
          },
        ),
      ],
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    PriceAlertsViewModel viewModel,
    alert, {
    bool isTriggered = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isTriggered
                    ? Colors.orange.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isTriggered
                    ? Icons.notifications_active
                    : Icons.notifications_outlined,
                color: isTriggered ? Colors.orange : AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.stockName,
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
                  ),
                  if (isTriggered && alert.triggeredAt != null)
                    Text(
                      'Triggered at ₹${alert.currentValue?.toStringAsFixed(2) ?? 'N/A'}',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            if (!isTriggered)
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

  @override
  PriceAlertsViewModel viewModelBuilder(BuildContext context) =>
      PriceAlertsViewModel();

  @override
  void onViewModelReady(PriceAlertsViewModel viewModel) {
    viewModel.initialize();
  }
}
