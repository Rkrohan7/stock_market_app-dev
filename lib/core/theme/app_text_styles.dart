import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Headings
  static TextStyle h1({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.2,
      );

  static TextStyle h2({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.2,
      );

  static TextStyle h3({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.3,
      );

  static TextStyle h4({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.3,
      );

  static TextStyle h5({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.4,
      );

  static TextStyle h6({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.4,
      );

  // Body Text
  static TextStyle bodyLarge({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.5,
      );

  static TextStyle bodyMedium({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.5,
      );

  static TextStyle bodySmall({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        height: 1.5,
      );

  // Labels
  static TextStyle labelLarge({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        letterSpacing: 0.5,
      );

  static TextStyle labelMedium({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        letterSpacing: 0.5,
      );

  static TextStyle labelSmall({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color ?? (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
        letterSpacing: 0.5,
      );

  // Button Text
  static TextStyle button({Color? color}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
        letterSpacing: 1,
      );

  static TextStyle buttonSmall({Color? color}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
        letterSpacing: 0.5,
      );

  // Stock Price Text
  static TextStyle stockPrice({Color? color, bool isDark = false}) => GoogleFonts.spaceMono(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  static TextStyle stockPriceSmall({Color? color, bool isDark = false}) => GoogleFonts.spaceMono(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  static TextStyle stockChange({required bool isPositive}) => GoogleFonts.spaceMono(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isPositive ? AppColors.profit : AppColors.loss,
      );

  // Index Value
  static TextStyle indexValue({Color? color, bool isDark = false}) => GoogleFonts.spaceMono(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  // Caption
  static TextStyle caption({Color? color, bool isDark = false}) => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.normal,
        color: color ?? (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
      );
}
