import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/common/market_index_card.dart';
import '../../widgets/common/stock_card.dart';
import '../../widgets/common/section_header.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: viewModel.refreshData,
                child: CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      floating: true,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.greeting,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            viewModel.userName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      actions: [
                        IconButton(
                          onPressed: viewModel.openSearch,
                          icon: const Icon(AppIcons.search),
                        ),
                        IconButton(
                          onPressed: viewModel.openNotifications,
                          icon: Badge(
                            isLabelVisible: viewModel.hasNotifications,
                            child: const Icon(AppIcons.notification),
                          ),
                        ),
                      ],
                    ),

                    // Content
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Market Indices
                          _buildMarketIndices(context, viewModel),
                          const SizedBox(height: 24),

                          // Portfolio Summary
                          _buildPortfolioSummary(context, viewModel),
                          const SizedBox(height: 24),

                          // Quick Actions
                          _buildQuickActions(context, viewModel),
                          const SizedBox(height: 24),

                          // Top Gainers
                          SectionHeader(
                            title: AppLocalizations.of(context)!.topGainers,
                            onViewAll: () => viewModel.navigateToMarket('gainers'),
                          ),
                          const SizedBox(height: 12),
                          _buildStockList(viewModel.topGainers, viewModel),
                          const SizedBox(height: 24),

                          // Top Losers
                          SectionHeader(
                            title: AppLocalizations.of(context)!.topLosers,
                            onViewAll: () => viewModel.navigateToMarket('losers'),
                          ),
                          const SizedBox(height: 12),
                          _buildStockList(viewModel.topLosers, viewModel),
                          const SizedBox(height: 24),

                          // Most Active
                          SectionHeader(
                            title: AppLocalizations.of(context)!.mostActive,
                            onViewAll: () => viewModel.navigateToMarket('active'),
                          ),
                          const SizedBox(height: 12),
                          _buildStockList(viewModel.mostActive, viewModel),
                          const SizedBox(height: 100),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomNav(context, viewModel),
    );
  }

  Widget _buildMarketIndices(BuildContext context, HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              viewModel.isMarketOpen ? Icons.circle : Icons.circle_outlined,
              size: 10,
              color: viewModel.isMarketOpen ? AppColors.profit : AppColors.loss,
            ),
            const SizedBox(width: 6),
            Text(
              viewModel.marketStatus,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: viewModel.isMarketOpen ? AppColors.profit : AppColors.loss,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ).animate().fadeIn(),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.indices.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final marketIndex = viewModel.indices[index];
              return MarketIndexCard(
                name: marketIndex.name,
                value: marketIndex.value,
                change: marketIndex.change,
                changePercent: marketIndex.changePercent,
              ).animate().fadeIn(delay: Duration(milliseconds: index * 100));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioSummary(BuildContext context, HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.portfolioValue,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      viewModel.todayPnLPercent >= 0
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${viewModel.todayPnLPercent >= 0 ? '+' : ''}${viewModel.todayPnLPercent.toStringAsFixed(2)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '₹${viewModel.portfolioValue.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPnLItem(
                  AppLocalizations.of(context)!.todayPnL,
                  viewModel.todayPnL,
                  viewModel.todayPnLPercent,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white24,
              ),
              Expanded(
                child: _buildPnLItem(
                  AppLocalizations.of(context)!.totalPnL,
                  viewModel.totalPnL,
                  viewModel.totalPnLPercent,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildPnLItem(String label, double value, double percent) {
    final isPositive = value >= 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${isPositive ? '+' : ''}₹${value.abs().toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, HomeViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    final actions = [
      {'icon': AppIcons.buy, 'label': l10n.buy, 'onTap': viewModel.openBuy},
      {'icon': AppIcons.sell, 'label': l10n.sell, 'onTap': viewModel.openSell},
      {'icon': AppIcons.portfolio, 'label': l10n.portfolio, 'onTap': viewModel.openPortfolio},
      {'icon': Icons.account_balance_wallet, 'label': l10n.funds, 'onTap': viewModel.openFunds},
      {'icon': AppIcons.watchlist, 'label': l10n.watchlist, 'onTap': viewModel.openWatchlist},
      {'icon': AppIcons.news, 'label': l10n.news, 'onTap': viewModel.openNews},
      {'icon': AppIcons.education, 'label': l10n.learn, 'onTap': viewModel.openEducation},
      {'icon': AppIcons.ai, 'label': l10n.aiTips, 'onTap': viewModel.openAiSuggestions},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _QuickActionButton(
          icon: action['icon'] as IconData,
          label: action['label'] as String,
          onTap: action['onTap'] as VoidCallback,
        ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
      },
    );
  }

  Widget _buildStockList(List stocks, HomeViewModel viewModel) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stocks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final stock = stocks[index];
          return StockCard(
            symbol: stock.symbol,
            name: stock.name,
            price: stock.currentPrice,
            change: stock.change,
            changePercent: stock.changePercent,
            onTap: () => viewModel.openStockDetails(stock.symbol),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, HomeViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: AppIcons.home,
                label: l10n.home,
                isSelected: viewModel.currentIndex == 0,
                onTap: () => viewModel.setIndex(0),
              ),
              _NavItem(
                icon: AppIcons.market,
                label: l10n.market,
                isSelected: viewModel.currentIndex == 1,
                onTap: () => viewModel.setIndex(1),
              ),
              _NavItem(
                icon: AppIcons.portfolio,
                label: l10n.portfolio,
                isSelected: viewModel.currentIndex == 2,
                onTap: () => viewModel.setIndex(2),
              ),
              _NavItem(
                icon: AppIcons.watchlist,
                label: l10n.watchlist,
                isSelected: viewModel.currentIndex == 3,
                onTap: () => viewModel.setIndex(3),
              ),
              _NavItem(
                icon: AppIcons.profile,
                label: l10n.profile,
                isSelected: viewModel.currentIndex == 4,
                onTap: () => viewModel.setIndex(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.initialize();
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondaryLight,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondaryLight,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
