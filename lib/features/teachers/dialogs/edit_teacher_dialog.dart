import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/components/app_input.dart';
import 'package:lms_core_frontend/common/components/app_label.dart';
import 'package:lms_core_frontend/common/components/app_toast_component.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/teachers/teachers_service.dart';

Future<void> showEditTeacherDialog(
  BuildContext context, {
  required TeacherUser teacher,
  required TeachersService service,
  required VoidCallback onRefresh,
}) async {
  final nameController = TextEditingController(text: teacher.name);
  bool isLoading = false;
  String? apiError;
  String nameError = '';

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AppDialog(
        title: 'Редагувати викладача',
        description: 'Змініть інформацію про викладача.',
        confirmLabel: 'Зберегти',
        confirmIcon: LucideIcons.save,
        isLoading: isLoading,
        onConfirm: () async {
          final name = nameController.text.trim();
          if (name.isEmpty) {
            setDialogState(() => nameError = 'Ім\'я є обов\'язковим');
            return;
          }
          setDialogState(() { isLoading = true; apiError = null; nameError = ''; });
          try {
            await service.updateTeacher(teacher.id, name: name);
            if (ctx.mounted) {
              Navigator.of(ctx).pop();
              onRefresh();
              AppToast.success(
                ctx,
                title: 'Викладача оновлено',
                description: 'Інформацію успішно збережено.',
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
            const AppLabel(text: 'Повне ім\'я'),
            const SizedBox(height: 8),
            AppInput(
              controller: nameController,
              hintText: 'Іван Петренко',
              errorText: nameError.isEmpty ? null : nameError,
              onChanged: (_) {
                if (nameError.isNotEmpty) setDialogState(() => nameError = '');
              },
            ),
            if (apiError != null) ...[
              const SizedBox(height: 8),
              Text(apiError!, style: const TextStyle(fontSize: 13, color: AppColors.red600)),
            ],
          ],
        ),
      ),
    ),
  );
  nameController.dispose();
}

