import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/journals/journals/journals_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../common/components/app_button.dart';
import '../../../../common/constants/colors.dart';
import '../dialogs/show_delete_journal_dialog.dart';
import '../journal_details_service.dart';
import 'journal_table.dart';

class JournalInfoCard extends StatelessWidget {
  const JournalInfoCard({
    super.key,
    required this.journal,
    required this.service,
    required this.onRefresh,
  });

  final JournalDetails journal;
  final JournalsService service;
  final VoidCallback onRefresh;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.bookOpen, size: 20, color: Colors.black),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text:
                        '${journal.groupName} - ${journal.subject}. Викладач: ',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: journal.teacherName,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Клацніть на комірку, щоб редагувати оцінку або відвідування',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          JournalTable(journal: journal),
          const SizedBox(height: 32),
          Row(
            children: [
              AppButton(
                variant: ButtonVariant.black,
                size: ButtonSize.lg,
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.save, size: 16),
                    SizedBox(width: 8),
                    Text('Зберегти оцінки'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AppButton(
                variant: ButtonVariant.destructive,
                size: ButtonSize.lg,
                onPressed: () => showDeleteJournalDetailsDialog(
                  context,
                  journal: journal,
                  service: service,
                  onDeleted: onRefresh,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.trash2, size: 16),
                    SizedBox(width: 8),
                    Text('Видалити журнал'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
