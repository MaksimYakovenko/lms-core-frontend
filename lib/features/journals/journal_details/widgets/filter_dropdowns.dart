import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../common/constants/colors.dart';

class JournalFilters extends StatelessWidget {
  const JournalFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background1,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Фільтри',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Обирайте студента, групу, предмет',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: const [
                Expanded(child: _FilterDropdown(label: 'Студент')),
                SizedBox(width: 16),
                Expanded(child: _FilterDropdown(label: 'Група')),
                SizedBox(width: 16),
                Expanded(child: _FilterDropdown(label: 'Предмет')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          hint: const Text(
            'Оберіть...',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray400,
            ),
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: AppColors.inputFocusBorder,
                width: 1.5,
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.gray900,
          ),
          items: ['ПІ-21', 'ПІ-22', 'КН-11']
              .map(
                (g) => DropdownMenuItem(
              value: g,
              child: Text(g),
            ),
          )
              .toList(),
          onChanged: (val) {},
        ),
      ],
    );
  }
}