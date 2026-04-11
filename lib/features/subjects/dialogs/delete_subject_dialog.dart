import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/components/app_toast_component.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/subjects/subjects_service.dart';

Future<void> showDeleteSubjectDialog(
    BuildContext context, {
      required Subject subject,
      required SubjectsService service,
      required VoidCallback onRefresh,
    }) async {
  bool isLoading = false;
  String? apiError;

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AppDialog(
        title: 'Видалити предмет',
        description: 'Ця дія незворотна. Предмет буде видалено назавжди.',
        confirmLabel: 'Видалити',
        confirmIcon: LucideIcons.trash2,
        isLoading: isLoading,
        onConfirm: isLoading
            ? null
            : () async {
                setDialogState(() { isLoading = true; apiError = null; });
                try {
                  await service.deleteSubject(subject.id);
                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                    onRefresh();
                    AppToast.success(ctx, title: 'Предмет видалено', description: '${subject.name} успішно видалено.');
                  }
                } catch (e) {
                  setDialogState(() { apiError = e.toString().replaceFirst('Exception: ', ''); isLoading = false; });
                }
              },
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: AppColors.gray700, height: 1.5),
                children: [
                  const TextSpan(text: 'Ви впевнені, що хочете видалити '),
                  TextSpan(
                    text: 'предмет ',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.gray900),
                  ),
                  TextSpan(
                    text: subject.name,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.gray900),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
            if (apiError != null) ...[
              const SizedBox(height: 10),
              Text(apiError!, style: const TextStyle(fontSize: 13, color: AppColors.red600)),
            ],
          ],
        ),
      ),
    ),
  );
}
