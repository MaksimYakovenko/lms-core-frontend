import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/components/app_label.dart';
import 'package:lms_core_frontend/common/components/app_toast_component.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/groups/groups_service.dart';
import 'package:lms_core_frontend/features/teachers/teachers_service.dart';

Future<void> showAssignToGroupDialog(
  BuildContext context, {
  required TeacherUser teacher,
  required TeachersService service,
  required VoidCallback onRefresh,
}) async {
  final groupsService = GroupsService();
  bool isLoading = false;
  bool isFetching = true;
  List<Group> groups = [];
  final Set<int> selectedGroupIds = {};
  String? apiError;
  String groupError = '';

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) {
        if (isFetching) {
          isFetching = false;
          groupsService.getGroups().then((list) {
            setDialogState(() => groups = list);
          }).catchError((e) {
            setDialogState(() =>
                apiError = e.toString().replaceFirst('Exception: ', ''));
          });
        }

        return AppDialog(
          title: 'Призначити групи',
          description: 'Оберіть одну або декілька груп для викладача ${teacher.name}.',
          confirmLabel: 'Призначити',
          confirmIcon: LucideIcons.users,
          isLoading: isLoading,
          onConfirm: () async {
            if (selectedGroupIds.isEmpty) {
              setDialogState(() => groupError = 'Оберіть хоча б одну групу');
              return;
            }
            setDialogState(() {
              isLoading = true;
              apiError = null;
              groupError = '';
            });
            try {
              await service.assignTeacherToGroups(
                teacher.id,
                selectedGroupIds.toList(),
              );
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                onRefresh();
                AppToast.success(
                  ctx,
                  title: 'Групи призначено',
                  description:
                      'Викладача "${teacher.name}" призначено до ${selectedGroupIds.length} груп(и).',
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
              const AppLabel(text: 'Групи'),
              const SizedBox(height: 8),
              if (groups.isEmpty && apiError == null)
                const Center(child: CircularProgressIndicator())
              else
                Container(
                  constraints: const BoxConstraints(maxHeight: 240),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: groupError.isNotEmpty
                          ? AppColors.red600
                          : AppColors.gray200,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: groups.length,
                    itemBuilder: (_, i) {
                      final group = groups[i];
                      final isSelected = selectedGroupIds.contains(group.id);
                      return CheckboxListTile(
                        dense: true,
                        value: isSelected,
                        title: Text(
                          '${group.name}  •  ${group.courseNumber} курс',
                          style: const TextStyle(fontSize: 14),
                        ),
                        onChanged: (checked) {
                          setDialogState(() {
                            if (checked == true) {
                              selectedGroupIds.add(group.id);
                            } else {
                              selectedGroupIds.remove(group.id);
                            }
                            groupError = '';
                          });
                        },
                      );
                    },
                  ),
                ),
              if (groupError.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(groupError,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.red600)),
              ],
              if (apiError != null) ...[
                const SizedBox(height: 8),
                Text(apiError!,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.red600)),
              ],
            ],
          ),
        );
      },
    ),
  );
}
