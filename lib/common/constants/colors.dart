import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Backgrounds ───────────────────────────────────────────────────────────
  // main app background (changed to #F9FAFB as requested)
  static const background1 = Color(0xFFF9FAFB);
  static const background2 = Color(0xFFF0FDF4);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const textPrimary   = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted     = Color(0xFF4B5563);

  // ── Accent ────────────────────────────────────────────────────────────────
  static const accent = Color(0xFF16A34A);

  // ── Info box ──────────────────────────────────────────────────────────────
  static const infoBg     = Color(0xFFEFF6FF);
  static const infoBorder = Color(0xFFDBEAFE);

  // ── Divider / Border ──────────────────────────────────────────────────────
  static const divider = Color(0xFFE5E7EB);

  // ── Sidebar ───────────────────────────────────────────────────────────────
  static const sidebarBg       = Color(0xFF0F172A);
  static const sidebarActive   = Color(0xFF1E293B);
  static const sidebarBorder   = Color(0xFF334155);
  static const sidebarText     = Colors.white;
  static const sidebarTextMuted = Color(0xFFCBD5E1);
  static const sidebarSubtitle = Color(0xFF94A3B8);

  // ── Gray palette ──────────────────────────────────────────────────────────
  static const gray200 = Color(0xFFE5E7EB);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray700 = Color(0xFF374151);
  static const gray900 = Color(0xFF111827);

  // ── Status ────────────────────────────────────────────────────────────────
  static const green700 = Color(0xFF15803D);
  static const red600   = Color(0xFFDC2626);

  // ── Role badge ────────────────────────────────────────────────────────────
  static const roleBadgeBg     = Color(0xFFEFF6FF);
  static const roleBadgeBorder = Color(0xFFBFDBFE);
  static const roleBadgeText   = Color(0xFF1D4ED8);

  // ── User Status ───────────────────────────────────────────────────────────────

  // ── Input focus border ────────────────────────────────────────────────────
  static const inputFocusBorder = Color(0xFF93C5FD);
}

