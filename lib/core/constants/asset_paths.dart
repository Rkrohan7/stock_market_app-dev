import 'package:flutter/material.dart';

/// App Icons - Using Material Icons instead of custom assets
/// This eliminates the need for external image/icon files
class AppIcons {
  AppIcons._();

  // Navigation Icons
  static const IconData home = Icons.home_rounded;
  static const IconData market = Icons.candlestick_chart_rounded;
  static const IconData portfolio = Icons.pie_chart_rounded;
  static const IconData watchlist = Icons.bookmark_rounded;
  static const IconData profile = Icons.person_rounded;

  // Action Icons
  static const IconData search = Icons.search_rounded;
  static const IconData notification = Icons.notifications_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData buy = Icons.trending_up_rounded;
  static const IconData sell = Icons.trending_down_rounded;
  static const IconData chart = Icons.show_chart_rounded;
  static const IconData news = Icons.newspaper_rounded;
  static const IconData education = Icons.school_rounded;
  static const IconData ai = Icons.auto_awesome_rounded;

  // Market Icons
  static const IconData nifty = Icons.trending_up_rounded;
  static const IconData sensex = Icons.insert_chart_rounded;
  static const IconData gainers = Icons.arrow_upward_rounded;
  static const IconData losers = Icons.arrow_downward_rounded;
  static const IconData volume = Icons.bar_chart_rounded;

  // Trading Icons
  static const IconData intraday = Icons.access_time_rounded;
  static const IconData delivery = Icons.calendar_today_rounded;
  static const IconData limit = Icons.horizontal_rule_rounded;
  static const IconData stopLoss = Icons.block_rounded;
  static const IconData marketOrder = Icons.flash_on_rounded;

  // Status Icons
  static const IconData success = Icons.check_circle_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData warning = Icons.warning_rounded;
  static const IconData info = Icons.info_rounded;
  static const IconData pending = Icons.hourglass_empty_rounded;

  // KYC Icons
  static const IconData verified = Icons.verified_rounded;
  static const IconData document = Icons.description_rounded;
  static const IconData camera = Icons.camera_alt_rounded;
  static const IconData upload = Icons.upload_rounded;

  // Auth Icons
  static const IconData phone = Icons.phone_rounded;
  static const IconData email = Icons.email_rounded;
  static const IconData lock = Icons.lock_rounded;
  static const IconData fingerprint = Icons.fingerprint_rounded;
  static const IconData face = Icons.face_rounded;

  // Others
  static const IconData add = Icons.add_rounded;
  static const IconData remove = Icons.remove_rounded;
  static const IconData delete = Icons.delete_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData share = Icons.share_rounded;
  static const IconData filter = Icons.filter_list_rounded;
  static const IconData sort = Icons.sort_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData arrowBack = Icons.arrow_back_rounded;
  static const IconData arrowForward = Icons.arrow_forward_rounded;
  static const IconData arrowUp = Icons.arrow_upward_rounded;
  static const IconData arrowDown = Icons.arrow_downward_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData menu = Icons.menu_rounded;
  static const IconData moreVert = Icons.more_vert_rounded;
  static const IconData moreHoriz = Icons.more_horiz_rounded;
  static const IconData star = Icons.star_rounded;
  static const IconData starBorder = Icons.star_border_rounded;
  static const IconData favorite = Icons.favorite_rounded;
  static const IconData favoriteBorder = Icons.favorite_border_rounded;
  static const IconData history = Icons.history_rounded;
  static const IconData logout = Icons.logout_rounded;
  static const IconData darkMode = Icons.dark_mode_rounded;
  static const IconData lightMode = Icons.light_mode_rounded;
  static const IconData language = Icons.language_rounded;
  static const IconData help = Icons.help_rounded;
  static const IconData about = Icons.info_outline_rounded;
  static const IconData privacy = Icons.privacy_tip_rounded;
  static const IconData terms = Icons.article_rounded;
  static const IconData support = Icons.support_agent_rounded;
  static const IconData wallet = Icons.account_balance_wallet_rounded;
  static const IconData bank = Icons.account_balance_rounded;
  static const IconData money = Icons.attach_money_rounded;
  static const IconData rupee = Icons.currency_rupee_rounded;
  static const IconData percent = Icons.percent_rounded;
  static const IconData analytics = Icons.analytics_rounded;
  static const IconData insights = Icons.insights_rounded;
  static const IconData timeline = Icons.timeline_rounded;
  static const IconData alarm = Icons.alarm_rounded;
  static const IconData quiz = Icons.quiz_rounded;
  static const IconData play = Icons.play_circle_rounded;
  static const IconData pause = Icons.pause_circle_rounded;
  static const IconData video = Icons.videocam_rounded;
  static const IconData article = Icons.article_rounded;
  static const IconData book = Icons.menu_book_rounded;
  static const IconData trophy = Icons.emoji_events_rounded;
  static const IconData badge = Icons.workspace_premium_rounded;
  static const IconData risk = Icons.warning_amber_rounded;
  static const IconData shield = Icons.shield_rounded;
  static const IconData rocket = Icons.rocket_launch_rounded;
  static const IconData target = Icons.gps_fixed_rounded;
  static const IconData bulb = Icons.lightbulb_rounded;
  static const IconData brain = Icons.psychology_rounded;
}

/// Network Image URLs for placeholder images
class NetworkImages {
  NetworkImages._();

  // Placeholder URLs using picsum.photos or similar free services
  static const String logoPlaceholder = 'https://ui-avatars.com/api/?name=Stock+Market&background=6C5CE7&color=fff&size=200';
  static const String avatarPlaceholder = 'https://ui-avatars.com/api/?name=User&background=6C5CE7&color=fff&size=100';

  // Stock company logos (using ui-avatars as placeholder)
  static String companyLogo(String symbol) =>
    'https://ui-avatars.com/api/?name=$symbol&background=random&color=fff&size=100';
}
