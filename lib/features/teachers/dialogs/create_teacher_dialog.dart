import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/components/app_toast_component.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/teachers/teachers_service.dart';
import 'package:lms_core_frontend/features/teachers/utils/teachers_validators.dart';

Future<void> showCreateTeacherDialog(
  BuildContext context, {
  required TeachersService service,
  required VoidCallback onRefresh,
}) async {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? apiError;
  bool isLoading = false;

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => Form(
        key: formKey,
        child: AppDialog(
          title: 'Створити викладача',
          description: 'Введіть адресу електронної пошти нового викладача.',
          confirmLabel: 'Створити викладача',
          confirmIcon: LucideIcons.circleCheck,
          isLoading: isLoading,
          onConfirm: () async {
            if (!(formKey.currentState?.validate() ?? false)) return;
            setDialogState(() { isLoading = true; apiError = null; });
            try {
              await service.createTeacher(emailController.text.trim());
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                onRefresh();
                AppToast.success(
                  ctx,
                  title: 'Викладача створено',
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
                label: 'Email',
                controller: emailController,
                hintText: 'teacher@example.com',
                keyboardType: TextInputType.emailAddress,
                validator: validateTeacherEmail,
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
  emailController.dispose();
}

