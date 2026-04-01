import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/students/students_service.dart';
import 'package:lms_core_frontend/features/groups/groups_service.dart';

Future<void> showAssignGroupDialog(
  BuildContext context, {
  required StudentUser student,
  required StudentsService service,
  required VoidCallback onRefresh,
}) {
  return showDialog(
    context: context,
    builder: (_) => _AssignGroupDialog(student: student, service: service, onRefresh: onRefresh),
  );
}

class _AssignGroupDialog extends StatefulWidget {
  const _AssignGroupDialog({
    required this.student,
    required this.service,
    required this.onRefresh,
  });

  final StudentUser student;
  final StudentsService service;
  final VoidCallback onRefresh;

  @override
  State<_AssignGroupDialog> createState() => _AssignGroupDialogState();
}

class _AssignGroupDialogState extends State<_AssignGroupDialog> {
  final _groupsService = GroupsService();

  List<Group> _groups = [];
  Group? _selectedGroup;

  bool _isLoadingGroups = true;
  bool _isSubmitting = false;
  String? _loadError;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final groups = await _groupsService.getGroups();
      if (mounted) setState(() { _groups = groups; _isLoadingGroups = false; });
    } catch (e) {
      if (mounted) setState(() {
        _loadError = e.toString().replaceFirst('Exception: ', '');
        _isLoadingGroups = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedGroup == null) return;

    setState(() { _isSubmitting = true; _submitError = null; });

    try {
      await widget.service.assignToGroup(widget.student.id, _selectedGroup!.id);
      if (mounted) {
        Navigator.of(context).pop();
        widget.onRefresh();
      }
    } catch (e) {
      setState(() => _submitError = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Призначити групу',
      description: 'Оберіть групу для студента ${widget.student.name.isEmpty ? widget.student.email : widget.student.name}',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Група',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.gray900,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          if (_isLoadingGroups)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (_loadError != null)
            Text(_loadError!, style: const TextStyle(fontSize: 13, color: AppColors.red600))
          else
            DropdownButtonFormField<Group>(
              value: _selectedGroup,
              hint: const Text(
                'Оберіть групу...',
                style: TextStyle(fontSize: 14, color: AppColors.gray400),
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: AppColors.gray200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: AppColors.gray200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: AppColors.inputFocusBorder, width: 1.5),
                ),
              ),
              style: const TextStyle(fontSize: 14, color: AppColors.gray900),
              items: _groups.map((g) => DropdownMenuItem(
                value: g,
                child: Text('${g.name} (курс ${g.courseNumber})'),
              )).toList(),
              onChanged: (g) => setState(() => _selectedGroup = g),
            ),
          if (_submitError != null) ...[
            const SizedBox(height: 10),
            Text(_submitError!, style: const TextStyle(fontSize: 13, color: AppColors.red600)),
          ],
        ],
      ),
      actions: [
        AppButton(
          variant: ButtonVariant.outline,
          size: ButtonSize.lg,
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        const SizedBox(width: 8),
        AppButton(
          variant: ButtonVariant.primary,
          size: ButtonSize.lg,
          isLoading: _isSubmitting,
          onPressed: (_isSubmitting || _selectedGroup == null) ? null : _submit,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.userRoundCheck, size: 15),
              SizedBox(width: 6),
              Text('Призначити'),
            ],
          ),
        ),
      ],
    );
  }
}

