import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/groups/groups_service.dart';

Future<void> showCreateGroupDialog(
  BuildContext context, {
  required GroupsService service,
  required VoidCallback onRefresh,
}) {
  return showDialog(
    context: context,
    builder: (_) => _CreateGroupDialog(service: service, onRefresh: onRefresh),
  );
}

class _CreateGroupDialog extends StatefulWidget {
  const _CreateGroupDialog({required this.service, required this.onRefresh});

  final GroupsService service;
  final VoidCallback onRefresh;

  @override
  State<_CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<_CreateGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _courseNumberController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _courseNumberController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() { _isLoading = true; _error = null; });

    try {
      await widget.service.createGroup(
        _nameController.text.trim(),
        int.parse(_courseNumberController.text.trim()),
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
      title: 'Створити групу',
      description: 'Введіть дані нової групи',
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDialogField(
              label: 'Назва',
              controller: _nameController,
              hintText: 'Наприклад: Група А',
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Введіть назву групи';
                return null;
              },
            ),
            const SizedBox(height: 14),
            AppDialogField(
              label: 'Номер курсу',
              controller: _courseNumberController,
              hintText: '1',
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Введіть номер курсу';
                final n = int.tryParse(v.trim());
                if (n == null || n < 1) return 'Введіть коректний номер курсу';
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
