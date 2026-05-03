import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/classrooms/dialogs/update_classroom_dialog.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import '../classrooms_service.dart';
import '../dialogs/delete_classroom_dialog.dart';

enum ClassroomAction { edit, delete }

class ClassroomActionMenu extends StatelessWidget {
  const ClassroomActionMenu({
    super.key,
    required this.classroom,
    required this.onRefresh,
    required this.service,
  });

  final Classroom classroom;
  final VoidCallback onRefresh;
  final ClassroomsService service;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ClassroomAction>(
      icon: const Icon(LucideIcons.ellipsisVertical, size: 16, color: AppColors.gray700),
      iconSize: 16,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.gray200),
      ),
      elevation: 4,
      onSelected: (action) {
        if (action == ClassroomAction.edit) {
          showEditClassroomDialog(context, classroom: classroom, service: service, onRefresh: onRefresh,);
        }
        if (action == ClassroomAction.delete) {
          showDeleteClassroomDialog(context, classroom: classroom, service: service, onRefresh: onRefresh);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: ClassroomAction.edit,
          child: _MenuItem(icon: LucideIcons.pencil, label: 'Редагувати'),
        ),
        PopupMenuItem(
          value: ClassroomAction.delete,
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

