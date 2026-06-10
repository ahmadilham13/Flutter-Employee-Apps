import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF6366F1); // Elegant Indigo
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFFEEF2F6);
  static const Color accent = Color(0xFF3B82F6); // Bright Blue

  // Neutral colors
  static const Color background = Color(0xFF0F172A); // Premium Slate/Dark background
  static const Color surface = Color(0xFF1E293B); // Dark slate card/surface background
  static const Color textPrimary = Color(0xFFF8FAFC); // Off white
  static const Color textSecondary = Color(0xFF94A3B8); // Slate grey text
  static const Color textMuted = Color(0xFF64748B);

  // Status colors
  static const Color success = Color(0xFF10B981); // Emerald green
  static const Color error = Color(0xFFEF4444); // Crimson red
  static const Color warning = Color(0xFFF59E0B); // Amber yellow

  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF8B5CF6)], // Indigo to Purple
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient accentGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)], // Blue to Cyan
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
