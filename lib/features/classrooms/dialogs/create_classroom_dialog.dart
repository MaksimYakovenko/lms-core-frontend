import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/classrooms/classrooms_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/components/app_toast_component.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';

Future<void> showCreateClassroomDialog(
    BuildContext context, {
      required ClassroomsService service,
      required VoidCallback onRefresh,
    }) async {
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? apiError;
  bool isLoading = false;

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => Form(
        key: formKey,
        child: AppDialog(
          title: 'Створити аудиторію',
          description: 'Введіть номер нової аудиторії.',
          confirmLabel: 'Створити аудиторію',
          confirmIcon: LucideIcons.circleCheck,
          isLoading: isLoading,
          onConfirm: () async {
            if (!(formKey.currentState?.validate() ?? false)) return;
            setDialogState(() { isLoading = true; apiError = null; });
            try {
              await service.createClassroom(nameController.text.trim());
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                onRefresh();
                AppToast.success(
                  ctx,
                  title: 'Аудиторію створено',
                  description: 'Новий обліковий запис успішно додано.',
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
              AppDialogField(
                label: 'Номер аудиторії',
                controller: nameController,
                hintText: '101',
              ),
              if (apiError != null) ...[
                const SizedBox(height: 8),
                Text(apiError!, style: const TextStyle(fontSize: 13, color: AppColors.red600)),
              ],
            ],
          ),
        ),
      ),
    ),
  );
  nameController.dispose();
}

