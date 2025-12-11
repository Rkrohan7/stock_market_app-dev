import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/ai_model.dart';
import 'ai_suggestions_viewmodel.dart';

class AiSuggestionsView extends StackedView<AiSuggestionsViewModel> {
  const AiSuggestionsView({super.key});

  @override
  Widget builder(BuildContext context, AiSuggestionsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Insights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: viewModel.initialize,
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMarketSentiment(context, viewModel),
                  _buildFilterSection(context, viewModel),
                  _buildRecommendationsList(context, viewModel),
                ],
              ),
            ),
    );
  }

  Widget _buildMarketSentiment(BuildContext context, AiSuggestionsViewModel viewModel) {
    final sentiment = viewModel.marketSentiment;
    if (sentiment == null) return const SizedBox.shrink();

    Color sentimentColor;
    IconData sentimentIcon;
    switch (sentiment.sentiment) {
      case 'Bullish':
        sentimentColor = AppColors.profit;
        sentimentIcon = Icons.trending_up_rounded;
        break;
      case 'Bearish':
        sentimentColor = AppColors.loss;
        sentimentIcon = Icons.trending_down_rounded;
        break;
      default:
        sentimentColor = AppColors.warning;
        sentimentIcon = Icons.trending_flat_rounded;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            sentimentColor.withValues(alpha: 0.8),
            sentimentColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(sentimentIcon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Market Sentiment',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      sentiment.sentiment,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${sentiment.confidence}% confident',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            sentiment.summary,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildFilterSection(BuildContext context, AiSuggestionsViewModel viewModel) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: viewModel.filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = viewModel.filters[index];
          final isSelected = viewModel.selectedFilter == filter;

          Color filterColor;
          switch (filter) {
            case 'Buy':
              filterColor = AppColors.profit;
              break;
            case 'Sell':
              filterColor = AppColors.loss;
              break;
            case 'Hold':
              filterColor = AppColors.warning;
              break;
            default:
              filterColor = AppColors.primary;
          }

          return GestureDetector(
            onTap: () => viewModel.setFilter(filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? filterColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? filterColor : AppColors.borderLight,
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondaryLight,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendationsList(BuildContext context, AiSuggestionsViewModel viewModel) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.filteredRecommendations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final rec = viewModel.filteredRecommendations[index];
        return _buildRecommendationCard(context, rec, viewModel, index);
      },
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    StockRecommendation rec,
    AiSuggestionsViewModel viewModel,
    int index,
  ) {
    Color recColor;
    switch (rec.recommendation) {
      case 'Buy':
        recColor = AppColors.profit;
        break;
      case 'Sell':
        recColor = AppColors.loss;
        break;
      default:
        recColor = AppColors.warning;
    }

    return InkWell(
      onTap: () => viewModel.openStockDetails(rec.symbol),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: recColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: recColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      rec.symbol[0],
                      style: TextStyle(
                        color: recColor,
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
                        rec.symbol,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        rec.stockName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: recColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    rec.recommendation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              rec.reason,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetric('Target', '₹${rec.targetPrice.toStringAsFixed(0)}'),
                _buildMetric('Stop Loss', '₹${rec.stopLoss.toStringAsFixed(0)}'),
                _buildMetric('Potential', '${rec.expectedReturn.toStringAsFixed(1)}%'),
                _buildMetric('Risk', rec.riskLevel),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  AiSuggestionsViewModel viewModelBuilder(BuildContext context) => AiSuggestionsViewModel();

  @override
  void onViewModelReady(AiSuggestionsViewModel viewModel) => viewModel.initialize();
}
