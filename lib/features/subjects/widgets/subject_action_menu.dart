import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/subjects/subjects_service.dart';
import 'package:lms_core_frontend/features/subjects/dialogs/edit_subject_dialog.dart';
import 'package:lms_core_frontend/features/subjects/dialogs/delete_subject_dialog.dart';

enum SubjectAction { edit, delete }

class SubjectActionMenu extends StatelessWidget {
  const SubjectActionMenu({
    super.key,
    required this.subject,
    required this.onRefresh,
    required this.service,
  });

  final Subject subject;
  final VoidCallback onRefresh;
  final SubjectsService service;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SubjectAction>(
      icon: const Icon(LucideIcons.ellipsisVertical, size: 16, color: AppColors.gray700),
      iconSize: 16,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.gray200),
      ),
      elevation: 4,
      onSelected: (action) {
        if (action == SubjectAction.edit) {
          showEditSubjectDialog(context, subject: subject, service: service, onRefresh: onRefresh);
        }
        if (action == SubjectAction.delete) {
          showDeleteSubjectDialog(context, subject: subject, service: service, onRefresh: onRefresh);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: SubjectAction.edit,
          child: _MenuItem(icon: LucideIcons.pencil, label: 'Редагувати'),
        ),
        PopupMenuItem(
          value: SubjectAction.delete,
          child: _MenuItem(icon: LucideIcons.trash2, label: 'Видалити', color: AppColors.red600),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.icon, required this.label, this.color = AppColors.gray900});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 14, color: color)),
      ],
    );
  }
}

