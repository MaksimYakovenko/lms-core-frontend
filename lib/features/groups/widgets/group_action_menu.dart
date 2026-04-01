import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/groups/groups_service.dart';
import 'package:lms_core_frontend/features/groups/dialogs/edit_group_dialog.dart';
import 'package:lms_core_frontend/features/groups/dialogs/delete_group_dialog.dart';

enum GroupAction { edit, delete }

class GroupActionMenu extends StatelessWidget {
  const GroupActionMenu({
    super.key,
    required this.group,
    required this.onRefresh,
    required this.service,
  });

  final Group group;
  final VoidCallback onRefresh;
  final GroupsService service;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<GroupAction>(
      icon: const Icon(LucideIcons.ellipsisVertical, size: 16, color: AppColors.gray700),
      iconSize: 16,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.gray200),
      ),
      elevation: 4,
      onSelected: (action) {
        if (action == GroupAction.edit) {
          showEditGroupDialog(context, group: group, service: service, onRefresh: onRefresh);
        }
        if (action == GroupAction.delete) {
          showDeleteGroupDialog(context, group: group, service: service, onRefresh: onRefresh);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: GroupAction.edit,
          child: _MenuItem(icon: LucideIcons.pencil, label: 'Редагувати'),
        ),
        PopupMenuItem(
          value: GroupAction.delete,
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

