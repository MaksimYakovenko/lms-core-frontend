import 'package:flutter/material.dart';

class GradeStyle {
  static Color background(String raw) {
    final v = int.tryParse(raw);

    if (v == null) return const Color(0xFFFEF3C7);
    if (v >= 90) return const Color(0xFFDCFCE7);
    if (v >= 75) return const Color(0xFFDBEAFE);
    if (v >= 60) return const Color(0xFFFEF9C3);

    return const Color(0xFFFFE4E6);
  }

  static Color text(String raw) {
    final v = int.tryParse(raw);

    if (v == null) return const Color(0xFF92400E);
    if (v >= 90) return const Color(0xFF166534);
    if (v >= 75) return const Color(0xFF1E40AF);
    if (v >= 60) return const Color(0xFF854D0E);

    return const Color(0xFF9F1239);
  }
}