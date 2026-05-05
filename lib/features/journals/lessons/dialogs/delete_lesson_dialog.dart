import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/journals/lessons/lessons_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/components/app_toast_component.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';

Future<void> showDeleteLessonDialog(
    BuildContext context, {
      required int journalId,
      required int lessonId,
      required LessonsService service,
      required VoidCallback onRefresh,
      VoidCallback? onDeleted,
    }) async {
  bool isLoading = false;
  String? apiError;

  await showDialog(
    context: context,
    builder:
        (ctx) => StatefulBuilder(
      builder:
          (ctx, setDialogState) => AppDialog(
        title: 'Видалити пару',
        description:
        'Ця дія незворотна. Пара буде видалена назавжди.',
        confirmLabel: 'Видалити',
        confirmIcon: LucideIcons.trash2,
        isLoading: isLoading,
        onConfirm: () async {
          setDialogState(() {
            isLoading = true;
            apiError = null;
          });
          try {
            await service.deleteLesson(journalId, lessonId);
            if (ctx.mounted) {
              Navigator.of(ctx).pop();
              onDeleted?.call();
              onRefresh();
              AppToast.success(
                ctx,
                title: 'Пару видалено',
                description: 'Пара успішно видалена.',
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
                    text: 'Ви впевнені, що хочете видалити пару?',
                  ),
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
