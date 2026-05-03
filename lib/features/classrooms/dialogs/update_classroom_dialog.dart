import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/classrooms/classrooms_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';

Future<void> showEditClassroomDialog(
    BuildContext context, {
      required Classroom classroom,
      required ClassroomsService service,
      required VoidCallback onRefresh,
    }) {
  return showDialog(
    context: context,
    builder: (_) => _EditClassroomDialog(classroom: classroom, service: service, onRefresh: onRefresh),
  );
}

class _EditClassroomDialog extends StatefulWidget {
  const _EditClassroomDialog({
    required this.classroom,
    required this.service,
    required this.onRefresh,
  });

  final Classroom classroom;
  final ClassroomsService service;
  final VoidCallback onRefresh;

  @override
  State<_EditClassroomDialog> createState() => _EditClassroomDialogState();
}

class _EditClassroomDialogState extends State<_EditClassroomDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.classroom.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await widget.service.updateClassroom(
        widget.classroom.id,
        name: _nameController.text.trim(),
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
      title: 'Редагувати номер аудиторії',
      description: "Змініть номер аудиторії",
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDialogField(
              label: "Номер",
              controller: _nameController,
              hintText: '101',
              validator: (v) {
                if (v == null || v.trim().isEmpty) return "Введіть номер аудиторії";
                return null;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                style: const TextStyle(fontSize: 13, color: AppColors.red600),
              ),
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
              Icon(LucideIcons.pencil, size: 15),
              SizedBox(width: 6),
              Text('Зберегти'),
            ],
          ),
        ),
      ],
    );
  }
}

