import 'package:flutter/material.dart';
import 'package:lms_core_frontend/common/components/_components.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../common/constants/colors.dart';
import '../../lessons/dialogs/create_lesson_dialog.dart';
import '../journal_details_service.dart';
import '../utils/excel_download_helper.dart';

class JournalFilters extends StatelessWidget {
  JournalFilters({
    super.key,
    required this.journal,
    this.onRefresh,
  });

  final JournalDetails journal;
  final VoidCallback? onRefresh;
  final _service = JournalDetailsService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              hint: const Text(
                'Оберіть студента',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray400,
                ),
              ),
              decoration: _inputDecoration(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.gray900,
              ),
              items: _items(),
              onChanged: (val) {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              hint: const Text(
                'Оберіть предмет',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray400,
                ),
              ),
              decoration: _inputDecoration(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.gray900,
              ),
              items: _items(),
              onChanged: (val) {},
            ),
          ),
          const SizedBox(width: 12),
          AppButton(
            variant: ButtonVariant.outline,
            size: ButtonSize.lg,
            onPressed: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.slidersHorizontal,
                  size: 20,
                  color: AppColors.gray900,
                ),
                SizedBox(width: 6),
                Text('Фільтри'),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppButton(
            variant: ButtonVariant.outline,
            size: ButtonSize.lg,
            onPressed: () => showCreateLessonDialog(
              context,
              journalId: journal.id,
              onRefresh: onRefresh ?? () {},
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.calendarPlus,
                  size: 20,
                  color: AppColors.gray900,
                ),
                SizedBox(width: 6),
                Text('Додати пару'),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppButton(
            variant: ButtonVariant.black,
            size: ButtonSize.lg,
            onPressed: () async {
              final bytes = await _service.exportToExcel(journal.id);
              ExcelDownloadHelper.download(
                bytes: bytes,
                fileName: 'journal_${journal.id}.xlsx',
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.download, size: 16),
                SizedBox(width: 8),
                Text('Експорт'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
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
    );
  }

  List<DropdownMenuItem<String>> _items() {
    return ['ПІ-21', 'ПІ-22', 'КН-11']
        .map(
          (g) => DropdownMenuItem<String>(
        value: g,
        child: Text(g),
      ),
    )
        .toList();
  }
}