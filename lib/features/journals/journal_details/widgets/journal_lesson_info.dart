import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../common/constants/colors.dart';
import '../journal_details_service.dart';
import '../../lessons/dialogs/edit_lesson_dialog.dart';

class JournalLessonInfo extends StatelessWidget {
  const JournalLessonInfo({
    super.key,
    required this.journal,
    required this.onRefresh,
  });

  final JournalDetails journal;
  final VoidCallback onRefresh;

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  String _lessonTypeLabel(String? type) {
    switch (type) {
      case 'LECTURE': return 'Лекція';
      case 'SEMINAR': return 'Семінар';
      case 'PRACTICE': return 'Практика';
      case 'CREDIT': return 'Залік';
      case 'EXAM': return 'Екзамен';
      case 'LAB': return 'Лабораторна';
      case 'MODULE': return 'МКР';
      case 'COLLOQUIUM': return 'Колоквіум';
      default: return type ?? '—';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessons = journal.lessons;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                const Icon(LucideIcons.bookOpen, size: 20, color: AppColors.textPrimary),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Теми доданих пар та їх опис',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          if (lessons.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    const Icon(LucideIcons.bookX, size: 36, color: AppColors.gray400),
                    const SizedBox(height: 12),
                    Text(
                      'Пари ще не додані',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      showCheckboxColumn: false,
                      headingRowColor: WidgetStateProperty.all(AppColors.background2),
                      headingRowHeight: 44,
                      dataRowMinHeight: 48,
                      dataRowMaxHeight: 72,
                      dividerThickness: 1,
                      border: TableBorder(
                        horizontalInside: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
                      ),
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Тема пари',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Опис пари',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Тип пари',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Дата',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                        ),
                        DataColumn(
                          numeric: true,
                          label: Text(
                            '№ пари',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                      rows: lessons.map((lesson) {
                        return DataRow(
                          onSelectChanged: (_) => showEditLessonDialog(
                            context,
                            journalId: journal.id,
                            lessonId: lesson.id,
                            onRefresh: onRefresh,
                            initialLessonType: lesson.lessonType,
                            initialDate: lesson.date,
                            initialLessonNumber: lesson.orderIndex,
                            initialTitle: lesson.title,
                            initialDescription: lesson.description,
                            initialClassroomId: lesson.classroomId,
                          ),
                          cells: [
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 260),
                                child: Text(
                                  lesson.title?.isNotEmpty == true ? lesson.title! : '—',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: lesson.title?.isNotEmpty == true ? AppColors.textPrimary : AppColors.gray400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 300),
                                child: Text(
                                  lesson.description?.isNotEmpty == true ? lesson.description! : '—',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: lesson.description?.isNotEmpty == true ? AppColors.textSecondary : AppColors.gray400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 300),
                                child: Text(
                                  _lessonTypeLabel(lesson.lessonType).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: lesson.lessonType?.isNotEmpty == true ? AppColors.textSecondary : AppColors.gray400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(LucideIcons.clock, size: 14, color: AppColors.gray400),
                                  const SizedBox(width: 6),
                                  Text(
                                    _formatDate(lesson.date),
                                    style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              lesson.orderIndex != null
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.gray200,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${lesson.orderIndex}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.gray700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : const Text('—', style: TextStyle(color: AppColors.gray400)),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
