import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/education_model.dart';
import 'blog_detail_viewmodel.dart';

class BlogDetailView extends StackedView<BlogDetailViewModel> {
  final BlogModel blog;

  const BlogDetailView({super.key, required this.blog});

  @override
  Widget builder(BuildContext context, BlogDetailViewModel viewModel, Widget? child) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, viewModel),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMetaInfo(context),
                  const SizedBox(height: 16),
                  _buildTitle(context),
                  const SizedBox(height: 12),
                  _buildAuthorRow(context),
                  const SizedBox(height: 16),
                  _buildTags(context),
                  const SizedBox(height: 24),
                  _buildContent(context),
                  const SizedBox(height: 32),
                  _buildEngagementStats(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, BlogDetailViewModel viewModel) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: _getGradientForLevel(blog.level),
          ),
          child: Center(
            child: Icon(
              _getIconForCategory(blog.category),
              size: 80,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: () => viewModel.toggleBookmark(),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => viewModel.shareBlog(),
        ),
      ],
    );
  }

  Widget _buildMetaInfo(BuildContext context) {
    return Row(
      children: [
        _buildLevelBadge(blog.level),
        const SizedBox(width: 8),
        _buildCategoryBadge(blog.category),
        const Spacer(),
        Icon(
          Icons.access_time,
          size: 14,
          color: AppColors.textSecondaryLight,
        ),
        const SizedBox(width: 4),
        Text(
          blog.formattedReadTime,
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: 12,
          ),
        ),
      ],
    ).animate().fadeIn();
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      blog.title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildAuthorRow(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            blog.author.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blog.author,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              DateFormat('MMM d, yyyy').format(blog.publishedAt),
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 150.ms);
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: blog.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '#$tag',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildContent(BuildContext context) {
    return _MarkdownContent(content: blog.content)
        .animate()
        .fadeIn(delay: 250.ms);
  }

  Widget _buildEngagementStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.visibility_outlined,
            _formatCount(blog.viewCount),
            'Views',
          ),
          _buildStatItem(
            Icons.favorite_outline,
            _formatCount(blog.likeCount),
            'Likes',
          ),
          _buildStatItem(
            Icons.access_time,
            '${blog.readTimeMinutes}',
            'Min Read',
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelBadge(String level) {
    Color color;
    switch (level) {
      case 'Beginner':
        color = AppColors.profit;
        break;
      case 'Intermediate':
        color = AppColors.warning;
        break;
      case 'Advanced':
        color = AppColors.loss;
        break;
      default:
        color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        level,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  LinearGradient _getGradientForLevel(String level) {
    switch (level) {
      case 'Beginner':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.profit, AppColors.profit.withValues(alpha: 0.7)],
        );
      case 'Intermediate':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.warning, AppColors.warning.withValues(alpha: 0.7)],
        );
      case 'Advanced':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.loss, AppColors.loss.withValues(alpha: 0.7)],
        );
      default:
        return AppColors.primaryGradient;
    }
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'basics':
        return Icons.school_rounded;
      case 'technical analysis':
        return Icons.analytics_rounded;
      case 'fundamental analysis':
        return Icons.account_balance_rounded;
      case 'options':
        return Icons.swap_horiz_rounded;
      case 'risk management':
        return Icons.shield_rounded;
      case 'trading strategies':
        return Icons.trending_up_rounded;
      case 'psychology':
        return Icons.psychology_rounded;
      case 'investing':
        return Icons.savings_rounded;
      case 'advanced trading':
        return Icons.computer_rounded;
      default:
        return Icons.article_rounded;
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  BlogDetailViewModel viewModelBuilder(BuildContext context) =>
      BlogDetailViewModel(blog: blog);
}

// Simple Markdown-like content renderer
class _MarkdownContent extends StatelessWidget {
  final String content;

  const _MarkdownContent({required this.content});

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.startsWith('# ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            line.substring(2),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ));
      } else if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            line.substring(3),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ));
      } else if (line.startsWith('### ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Text(
            line.substring(4),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ));
      } else if (line.startsWith('**') && line.endsWith('**')) {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            line.replaceAll('**', ''),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
      } else if (line.startsWith('- ') || line.startsWith('* ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Text(_parseInlineFormatting(line.substring(2)))),
            ],
          ),
        ));
      } else if (RegExp(r'^\d+\. ').hasMatch(line)) {
        final match = RegExp(r'^(\d+)\. (.*)').firstMatch(line);
        if (match != null) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${match.group(1)}. ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                    child: Text(_parseInlineFormatting(match.group(2) ?? ''))),
              ],
            ),
          ));
        }
      } else if (line.startsWith('```')) {
        // Code block start/end - skip rendering the backticks
        continue;
      } else if (line.startsWith('|')) {
        // Table row
        final cells = line
            .split('|')
            .where((c) => c.trim().isNotEmpty)
            .map((c) => c.trim())
            .toList();
        if (cells.isNotEmpty && !cells.every((c) => c.contains('-'))) {
          widgets.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: cells
                  .map((cell) => Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.borderLight.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            cell,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: i == 0 ||
                                      (i > 0 &&
                                          lines[i - 1].contains('|') &&
                                          lines[i - 1]
                                              .split('|')
                                              .every((c) => c.contains('-')))
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ));
        }
      } else if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
      } else {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            _parseInlineFormatting(line),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  String _parseInlineFormatting(String text) {
    // Remove markdown bold/italic for now (simple implementation)
    return text
        .replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'\1')
        .replaceAll(RegExp(r'\*(.+?)\*'), r'\1')
        .replaceAll(RegExp(r'`(.+?)`'), r'\1');
  }
}
