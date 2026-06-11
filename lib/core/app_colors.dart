// AppColors — Màu sắc tập trung, dùng thay vì magic strings
// Sử dụng: import '../core/app_colors.dart';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Không cho khởi tạo

  // ── Brand Colors ──────────────────────────────────────────
  static const primary    = Color(0xFF667EEA); // Tím xanh chủ đạo
  static const primaryDark = Color(0xFF764BA2); // Tím đậm (gradient end)

  // ── Semantic Colors ───────────────────────────────────────
  static const success    = Color(0xFF43E97B); // Xanh lá (hoàn thành)
  static const successEnd = Color(0xFF38F9D7); // Xanh lá nhạt (gradient end)
  static const danger     = Colors.red;
  static const warning    = Color(0xFFE97B43); // Cam (Advanced)

  // ── Level Colors ──────────────────────────────────────────
  static const beginner    = Color(0xFF43E97B); // Xanh lá
  static const intermediate = Color(0xFF667EEA); // Tím xanh
  static const advanced    = Color(0xFFE97B43); // Cam đỏ

  // ── Background Tints (Light Mode) ─────────────────────────
  static const primaryTint = Color(0xFFF0EEFF); // Nền icon bài học
  static const primaryContainer = Color(0xFFF5F5FF); // Nền input

  // ── Gradient presets ──────────────────────────────────────
  static const mainGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const successGradient = LinearGradient(
    colors: [success, successEnd],
  );

  // ── Opacity helpers ───────────────────────────────────────
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);
}
