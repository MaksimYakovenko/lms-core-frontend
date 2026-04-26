import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/teachers/teachers_service.dart';
import 'package:lms_core_frontend/features/teachers/dialogs/edit_teacher_dialog.dart';
import 'package:lms_core_frontend/features/teachers/dialogs/delete_teacher_dialog.dart';
import 'package:lms_core_frontend/features/teachers/dialogs/assign_to_group_dialog.dart';

import '../dialogs/assign_to_subject_dialog.dart';

enum TeacherAction { edit, delete, assignToGroup, assignToSubjects }

class TeacherActionMenu extends StatelessWidget {
  const TeacherActionMenu({
    super.key,
    required this.teacher,
    required this.onRefresh,
    required this.service,
  });

  final TeacherUser teacher;
  final VoidCallback onRefresh;
  final TeachersService service;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TeacherAction>(
      icon: const Icon(LucideIcons.ellipsisVertical, size: 16, color: AppColors.gray700),
      iconSize: 16,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.gray200),
      ),
      elevation: 4,
      onSelected: (action) {
        if (action == TeacherAction.edit) {
          showEditTeacherDialog(context, teacher: teacher, service: service, onRefresh: onRefresh);
        } else if (action == TeacherAction.delete) {
          showDeleteTeacherDialog(context, teacher: teacher, service: service, onRefresh: onRefresh);
        } else if (action == TeacherAction.assignToGroup) {
          showAssignToGroupDialog(context, teacher: teacher, service: service, onRefresh: onRefresh);
        } else if (action == TeacherAction.assignToSubjects) {
          showAssignToSubjectsDialog(context, teacher: teacher, service: service, onRefresh: onRefresh);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: TeacherAction.edit,
          child: _MenuItem(icon: LucideIcons.pencil, label: 'Редагувати'),
        ),
        PopupMenuItem(
          value: TeacherAction.assignToGroup,
          child: _MenuItem(icon: LucideIcons.users, label: 'Призначити групу'),
        ),
        PopupMenuItem(
          value: TeacherAction.assignToSubjects,
          child: _MenuItem(icon: LucideIcons.bookOpen, label: 'Призначити предмети'),
        ),
        PopupMenuItem(
          value: TeacherAction.delete,
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

