import 'package:flutter/material.dart';

import '../../../../common/constants/colors.dart';

class JournalLegend extends StatelessWidget {
  const JournalLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Легенда',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _LegendItem(
                bg: Color(0xFFF0FDF4),
                border: Color(0xFFBBF7D0),
                label: 'Відмінно (10-12)',
                text: '10',
                textColor: Color(0xFF16A34A),
              ),
              _LegendItem(
                bg: Color(0xFFFEFCE8),
                border: Color(0xFFFEF08A),
                label: 'Добре (7-9)',
                text: '7',
                textColor: Color(0xFFCA8A04),
              ),
              _LegendItem(
                bg: Color(0xFFFFF7ED),
                border: Color(0xFFFDBA74),
                label: 'Задовільно (4-6)',
                text: '5',
                textColor: Color(0xFFF97316),
              ),
              _LegendItem(
                bg: Color(0xFFFEF2F2),
                border: Color(0xFFFCA5A5),
                label: 'Незадовільно (1-3)',
                text: '2',
                textColor: Color(0xFFDC2626),
              ),
              _LegendItem(
                bg: Color(0xFFF3F4F6),
                border: Color(0xFFD1D5DB),
                label: 'Відсутній',
                text: 'ХВ',
                textColor: AppColors.gray900,
              ),
              _LegendItem(
                bg: Color(0xFFF3F4F6),
                border: Color(0xFFD1D5DB),
                label: 'Пропуск',
                text: 'П/П',
                textColor: AppColors.gray900,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.bg,
    required this.border,
    required this.label,
    required this.text,
    required this.textColor,
  });

  final Color bg;
  final Color border;
  final String label;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}