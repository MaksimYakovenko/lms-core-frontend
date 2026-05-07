import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../common/constants/colors.dart';
import '../journal_details_service.dart';
import '../../lessons/dialogs/edit_lesson_dialog.dart';
import '../dialogs/set_grade_dialog.dart';
import 'score_cell.dart';

class JournalTable extends StatelessWidget {
  const JournalTable({
    super.key,
    required this.journal,
    this.onRefresh,
  });

  final JournalDetails journal;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final lessons = journal.lessons;
    final students = journal.students;
    final service = JournalDetailsService();

    if (students.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.usersRound,
              size: 40,
              color: AppColors.gray400,
            ),
            SizedBox(height: 12),
            Text(
              'Немає даних про студентів',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    const double indexW = 50;
    const double nameW = 230;
    const double cellW = 74;
    const double rowH = 48;
    const double headerH = 60;

    final header = Container(
      color: AppColors.background1,
      child: Row(
        children: [
          _cell(
            width: indexW,
            height: headerH,
            borderRight: true,
            child: const Text(
              '#',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          _cell(
            width: nameW,
            height: headerH,
            borderRight: true,
            child: const Text(
              'ПІБ студента',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          for (final lesson in lessons)
            GestureDetector(
              onTap: () => showEditLessonDialog(
                context,
                journalId: journal.id,
                lessonId: lesson.id,
                onRefresh: onRefresh ?? () {},
                initialLessonType: lesson.lessonType,
                initialDate: lesson.date,
                initialLessonNumber: lesson.orderIndex,
                initialTitle: lesson.title,
                initialDescription: lesson.description,
                initialClassroomId: lesson.classroomId,
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _cell(
                  width: cellW,
                  height: headerH,
                  borderLeft: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _monthLabel(lesson.date),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (lesson.typeLabel != null && lesson.typeLabel!.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: lesson.typeBadgeBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            lesson.typeLabel!,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: lesson.typeBadgeText,
                            ),
                          ),
                        ),
                      Text(
                        '${lesson.date.day}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFDB2777),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    final rows = <Widget>[];

    for (int i = 0; i < students.length; i++) {
      final student = students[i];

      rows.add(
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.divider),
            ),
          ),
          child: Row(
            children: [
              _cell(
                width: indexW,
                height: rowH,
                borderRight: true,
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              _cell(
                width: nameW,
                height: rowH,
                borderRight: true,
                child: Text(
                  student.fullName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFDB2777),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for (final lesson in lessons)
                GestureDetector(
                  onTap: () => showSetGradeDialog(
                    context,
                    journalId: journal.id,
                    lessonId: lesson.id,
                    studentId: student.id,
                    studentName: student.fullName,
                    lessonLabel:
                        '${lesson.typeLabel ?? lesson.lessonType ?? ''} ${lesson.date.day}.${lesson.date.month.toString().padLeft(2, '0')}',
                    service: service,
                    onRefresh: onRefresh ?? () {},
                    currentValue: student.gradeFor(lesson.id),
                    gradeId: student.gradeObjectFor(lesson.id)?.id,
                  ),
                  child: ScoreCell(
                    value: student.gradeFor(lesson.id),
                    width: cellW,
                    height: rowH,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.divider,
          ),
          ...rows,
        ],
      ),
    );
  }

  static Widget _cell({
    required double width,
    required double height,
    required Widget child,
    bool borderRight = false,
    bool borderLeft = false,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border(
          right: borderRight
              ? const BorderSide(color: AppColors.divider)
              : BorderSide.none,
          left: borderLeft
              ? const BorderSide(color: AppColors.divider)
              : BorderSide.none,
        ),
      ),
      child: child,
    );
  }

  static String _monthLabel(DateTime date) {
    const months = [
      'Січ.',
      'Лют.',
      'Бер.',
      'Квіт.',
      'Трав.',
      'Черв.',
      'Лип.',
      'Серп.',
      'Вер.',
      'Жовт.',
      'Лист.',
      'Груд.',
    ];

    return months[date.month - 1];
  }
}