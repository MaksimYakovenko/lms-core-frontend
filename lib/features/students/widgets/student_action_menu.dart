import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/students/students_service.dart';
import 'package:lms_core_frontend/features/students/dialogs/delete_student_dialog.dart';
import 'package:lms_core_frontend/features/students/dialogs/edit_student_dialog.dart';

enum StudentAction { edit, delete }

class StudentActionMenu extends StatelessWidget {
  const StudentActionMenu({
    super.key,
    required this.student,
    required this.onRefresh,
    required this.service,
  });

  final StudentUser student;
  final VoidCallback onRefresh;
  final StudentsService service;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<StudentAction>(
      icon: const Icon(LucideIcons.ellipsisVertical, size: 16, color: AppColors.gray700),
      iconSize: 16,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.gray200),
      ),
      elevation: 4,
      onSelected: (action) {
        if (action == StudentAction.edit) {
          showEditStudentDialog(context, student: student, service: service, onRefresh: onRefresh);
        }
        if (action == StudentAction.delete) {
          showDeleteStudentDialog(context, student: student, service: service, onRefresh: onRefresh);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: StudentAction.edit,
          child: _MenuItem(icon: LucideIcons.pencil, label: 'Редагувати'),
        ),
        PopupMenuItem(
          value: StudentAction.delete,
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

