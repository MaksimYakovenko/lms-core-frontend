import 'package:flutter/material.dart';

import '../../../../common/constants/colors.dart';

class ScoreCell extends StatefulWidget {
  const ScoreCell({
    super.key,
    required this.value,
    required this.width,
    required this.height,
  });

  final String? value;
  final double width;
  final double height;

  @override
  State<ScoreCell> createState() => _ScoreCellState();
}

class _ScoreCellState extends State<ScoreCell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = _bgColor(widget.value);
    final hoverBg = Color.lerp(bg, Colors.black, 0.07)!;
    final textColor = _textColor(widget.value);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _hovered ? hoverBg : bg,
          border: const Border(
            left: BorderSide(color: AppColors.divider),
          ),
        ),
        child: widget.value != null
            ? Text(
                widget.value!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              )
            : null,
      ),
    );
  }

  static Color _bgColor(String? value) {
    if (value == null) return const Color(0xFFF9FAFB);

    final v = value.trim();

    if (v == 'ХВ' || v == 'П/П') {
      return const Color(0xFFF3F4F6);
    }

    final score = int.tryParse(v);

    if (score == null) return const Color(0xFFF9FAFB);
    if (score >= 10) return const Color(0xFFF0FDF4);
    if (score >= 7) return const Color(0xFFFEFCE8);
    if (score >= 4) return const Color(0xFFFFF7ED);

    return const Color(0xFFFEF2F2);
  }

  static Color _textColor(String? value) {
    if (value == null) return AppColors.gray400;

    final v = value.trim();

    if (v == 'ХВ' || v == 'П/П') {
      return AppColors.gray900;
    }

    final score = int.tryParse(v);

    if (score == null) return AppColors.gray400;
    if (score >= 10) return const Color(0xFF16A34A);
    if (score >= 7) return const Color(0xFFCA8A04);
    if (score >= 4) return const Color(0xFFF97316);

    return AppColors.red600;
  }
}