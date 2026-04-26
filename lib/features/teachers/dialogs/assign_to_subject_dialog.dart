import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/subjects/subjects_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/components/app_label.dart';
import 'package:lms_core_frontend/common/components/app_toast_component.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/teachers/teachers_service.dart';

Future<void> showAssignToSubjectsDialog(
    BuildContext context, {
      required TeacherUser teacher,
      required TeachersService service,
      required VoidCallback onRefresh,
    }) async {
  final subjectsService = SubjectsService();
  bool isLoading = false;
  bool isFetching = true;
  List<Subject> subjects = [];
  final Set<int> selectedSubjectIds = {};
  String? apiError;
  String subjectError = '';

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) {
        if (isFetching) {
          isFetching = false;
          subjectsService.getSubjects().then((list) {
            setDialogState(() => subjects = list);
          }).catchError((e) {
            setDialogState(() =>
            apiError = e.toString().replaceFirst('Exception: ', ''));
          });
        }

        return AppDialog(
          title: 'Призначити предмети',
          description: 'Оберіть один або декілька предметів для викладача ${teacher.name}.',
          confirmLabel: 'Призначити',
          confirmIcon: LucideIcons.users,
          isLoading: isLoading,
          onConfirm: () async {
            if (selectedSubjectIds.isEmpty) {
              setDialogState(() => subjectError = 'Оберіть хоча б один предмет');
              return;
            }
            setDialogState(() {
              isLoading = true;
              apiError = null;
              subjectError = '';
            });
            try {
              await service.assignTeacherToSubjects(
                teacher.id,
                selectedSubjectIds.toList(),
              );
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                onRefresh();
                AppToast.success(
                  ctx,
                  title: 'Предмети призначено',
                  description:
                  'Викладача "${teacher.name}" призначено до ${selectedSubjectIds.length} предмета(ів).',
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
              const AppLabel(text: 'Предмети'),
              const SizedBox(height: 8),
              if (subjects.isEmpty && apiError == null)
                const Center(child: CircularProgressIndicator())
              else
                Container(
                  constraints: const BoxConstraints(maxHeight: 240),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: subjectError.isNotEmpty
                          ? AppColors.red600
                          : AppColors.gray200,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: subjects.length,
                    itemBuilder: (_, i) {
                      final subject = subjects[i];
                      final isSelected = selectedSubjectIds.contains(subject.id);
                      return CheckboxListTile(
                        dense: true,
                        value: isSelected,
                        title: Text(
                          subject.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                        activeColor: AppColors.textPrimary,
                        onChanged: (checked) {
                          setDialogState(() {
                            if (checked == true) {
                              selectedSubjectIds.add(subject.id);
                            } else {
                              selectedSubjectIds.remove(subject.id);
                            }
                            subjectError = '';
                          });
                        },
                      );
                    },
                  ),
                ),
              if (subjectError.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(subjectError,
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
