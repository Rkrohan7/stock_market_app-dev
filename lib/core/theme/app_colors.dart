import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF9B8FF2);
  static const Color primaryDark = Color(0xFF4A3FCF);

  // Secondary Colors
  static const Color secondary = Color(0xFF00D9FF);
  static const Color secondaryLight = Color(0xFF5CE1FF);
  static const Color secondaryDark = Color(0xFF00A8C7);

  // Accent Colors
  static const Color accent = Color(0xFFFFD93D);
  static const Color accentLight = Color(0xFFFFE57D);
  static const Color accentDark = Color(0xFFE5C235);

  // Stock Colors
  static const Color profit = Color(0xFF00C853);
  static const Color profitLight = Color(0xFF69F0AE);
  static const Color profitDark = Color(0xFF00962B);
  static const Color loss = Color(0xFFFF5252);
  static const Color lossLight = Color(0xFFFF8A80);
  static const Color lossDark = Color(0xFFD50000);
  static const Color neutral = Color(0xFF9E9E9E);

  // Background Colors - Light Theme
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Background Colors - Dark Theme
  static const Color backgroundDark = Color(0xFF0D0D1A);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color cardDark = Color(0xFF16213E);

  // Text Colors - Light Theme
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B6B80);
  static const Color textTertiaryLight = Color(0xFF9E9EB0);

  // Text Colors - Dark Theme
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0C0);
  static const Color textTertiaryDark = Color(0xFF6B6B80);

  // Border Colors
  static const Color borderLight = Color(0xFFE8E8F0);
  static const Color borderDark = Color(0xFF2A2A40);

  // Chart Colors
  static const Color chartLine1 = Color(0xFF6C5CE7);
  static const Color chartLine2 = Color(0xFF00D9FF);
  static const Color chartLine3 = Color(0xFFFFD93D);
  static const Color chartLine4 = Color(0xFFFF6B6B);
  static const Color chartArea = Color(0x206C5CE7);
  static const Color candleUp = Color(0xFF00C853);
  static const Color candleDown = Color(0xFFFF5252);

  // Indicator Colors
  static const Color rsiColor = Color(0xFFE040FB);
  static const Color macdColor = Color(0xFF00BCD4);
  static const Color emaColor = Color(0xFFFFAB00);
  static const Color smaColor = Color(0xFF7C4DFF);
  static const Color volumeColor = Color(0xFF546E7A);

  // Status Colors
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF00B0FF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient profitGradient = LinearGradient(
    colors: [profit, profitLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lossGradient = LinearGradient(
    colors: [loss, lossLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x20FFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
