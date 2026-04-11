import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/subjects/subjects_service.dart';

Future<void> showEditSubjectDialog(
  BuildContext context, {
  required Subject subject,
  required SubjectsService service,
  required VoidCallback onRefresh,
}) async {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: subject.name);
  bool isLoading = false;
  String? apiError;

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AppDialog(
        title: 'Редагувати предмет',
        description: 'Оновіть дані предмету',
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppDialogField(
                label: 'Назва',
                controller: nameController,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Введіть назву предмету';
                  return null;
                },
              ),
              if (apiError != null) ...[
                const SizedBox(height: 10),
                Text(apiError!, style: const TextStyle(fontSize: 13, color: AppColors.red600)),
              ],
            ],
          ),
        ),
        actions: [
          AppButton(
            variant: ButtonVariant.outline,
            size: ButtonSize.lg,
            onPressed: isLoading ? null : () => Navigator.of(ctx).pop(),
            child: const Text('Скасувати'),
          ),
          const SizedBox(width: 8),
          AppButton(
            variant: ButtonVariant.primary,
            size: ButtonSize.lg,
            isLoading: isLoading,
            onPressed: isLoading
                ? null
                : () async {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    setDialogState(() { isLoading = true; apiError = null; });
                    try {
                      await service.updateSubject(subject.id, name: nameController.text.trim());
                      if (ctx.mounted) {
                        Navigator.of(ctx).pop();
                        onRefresh();
                      }
                    } catch (e) {
                      setDialogState(() { apiError = e.toString().replaceFirst('Exception: ', ''); isLoading = false; });
                    }
                  },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.save, size: 15),
                SizedBox(width: 6),
                Text('Зберегти'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
