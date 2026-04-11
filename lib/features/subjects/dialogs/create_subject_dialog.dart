import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/subjects/subjects_service.dart';

Future<void> showCreateSubjectDialog(
    BuildContext context, {
      required SubjectsService service,
      required VoidCallback onRefresh,
    }) {
  return showDialog(
    context: context,
    builder: (_) => _CreateSubjectDialog(service: service, onRefresh: onRefresh),
  );
}

class _CreateSubjectDialog extends StatefulWidget {
  const _CreateSubjectDialog({required this.service, required this.onRefresh});

  final SubjectsService service;
  final VoidCallback onRefresh;

  @override
  State<_CreateSubjectDialog> createState() => _CreateSubjectDialogState();
}

class _CreateSubjectDialogState extends State<_CreateSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() { _isLoading = true; _error = null; });

    try {
      await widget.service.createSubject(
        _nameController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop();
        widget.onRefresh();
      }
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Створити предмет',
      description: 'Введіть назву нового предмету',
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDialogField(
              label: 'Назва',
              controller: _nameController,
              hintText: 'Наприклад: Математика',
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Введіть назву предмету';
                return null;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(fontSize: 13, color: AppColors.red600)),
            ],
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: ButtonVariant.outline,
          size: ButtonSize.lg,
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        const SizedBox(width: 8),
        AppButton(
          variant: ButtonVariant.primary,
          size: ButtonSize.lg,
          isLoading: _isLoading,
          onPressed: _isLoading ? null : _submit,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.folderPlus, size: 15),
              SizedBox(width: 6),
              Text('Створити'),
            ],
          ),
        ),
      ],
    );
  }
}
