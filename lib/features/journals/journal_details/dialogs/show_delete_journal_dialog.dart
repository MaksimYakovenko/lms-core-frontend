import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_core_frontend/features/journals/journals/journals_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../common/components/app_dialog.dart';
import '../../../../common/components/app_toast_component.dart';
import '../../../../common/constants/colors.dart';
import '../journal_details_service.dart';

Future<void> showDeleteJournalDetailsDialog(
    BuildContext context, {
      required JournalDetails journal,
      required JournalsService service,
      required VoidCallback onDeleted,
    }) async {
  bool isLoading = false;
  String? apiError;

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AppDialog(
        title: 'Видалити журнал',
        description: 'Ця дія незворотна. Журнал буде видалено назавжди.',
        confirmLabel: 'Видалити',
        confirmIcon: LucideIcons.trash2,
        isLoading: isLoading,
        onConfirm: () async {
          setDialogState(() {
            isLoading = true;
            apiError = null;
          });

          try {
            await service.deleteJournal(journal.id);

            if (ctx.mounted) {
              Navigator.of(ctx).pop();
              context.go('/journals');
              onDeleted();

              AppToast.success(
                context,
                title: 'Журнал видалено',
                description:
                'Журнал ${journal.groupName} - ${journal.subject} успішно видалено.',
              );
            }
          } catch (e) {
            setDialogState(() {
              apiError = e.toString().replaceFirst('Exception: ', '');
              isLoading = false;
            });
          }
        },
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.gray700,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'Ви впевнені, що хочете видалити журнал групи ',
                  ),
                  TextSpan(
                    text: '${journal.groupName} - ${journal.subject}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray900,
                    ),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
            if (apiError != null) ...[
              const SizedBox(height: 8),
              Text(
                apiError!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.red600,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}