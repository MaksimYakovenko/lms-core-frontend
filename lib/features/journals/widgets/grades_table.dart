import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/journals/widgets/student_grade_row.dart';

import '../journals_service.dart';

class GradesTable extends StatelessWidget {
  const GradesTable({
    super.key,
    required this.journal,
  });

  final JournalDetails journal;

  static const double _colWidth = 64;
  static const double _nameColWidth = 200;
  static const double _indexColWidth = 44;
  static const double _rowHeight = 40;
  static const double _monthRowHeight = 28;
  static const double _tagRowHeight = 44;

  static const _monthNames = [
    '',
    'Січ',
    'Лют',
    'Бер',
    'Квіт',
    'Трав',
    'Черв',
    'Лип',
    'Серп',
    'Вер',
    'Жовт',
    'Лист',
    'Груд',
  ];

  @override
  Widget build(BuildContext context) {
    final lessons = journal.lessons;
    final students = journal.students;
    final monthGroups = _groupLessonsByMonth(lessons);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MonthHeaderRow(
                groups: monthGroups,
                colWidth: _colWidth,
                nameColWidth: _nameColWidth,
                indexColWidth: _indexColWidth,
                monthRowHeight: _monthRowHeight,
                monthNames: _monthNames,
              ),
              _LessonTagRow(
                lessons: lessons,
                colWidth: _colWidth,
                nameColWidth: _nameColWidth,
                indexColWidth: _indexColWidth,
                tagRowHeight: _tagRowHeight,
              ),
              ...students.asMap().entries.map(
                    (e) => StudentGradeRow(
                  index: e.key + 1,
                  student: e.value,
                  lessons: lessons,
                  colWidth: _colWidth,
                  nameColWidth: _nameColWidth,
                  indexColWidth: _indexColWidth,
                  rowHeight: _rowHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<(int month, List<JournalLesson>)> _groupLessonsByMonth(
      List<JournalLesson> lessons,
      ) {
    final List<(int month, List<JournalLesson>)> groups = [];

    for (final lesson in lessons) {
      final month = lesson.date.month;

      if (groups.isEmpty || groups.last.$1 != month) {
        groups.add((month, [lesson]));
      } else {
        groups.last.$2.add(lesson);
      }
    }

    return groups;
  }
}

class _MonthHeaderRow extends StatelessWidget {
  const _MonthHeaderRow({
    required this.groups,
    required this.colWidth,
    required this.nameColWidth,
    required this.indexColWidth,
    required this.monthRowHeight,
    required this.monthNames,
  });

  final List<(int month, List<JournalLesson>)> groups;
  final double colWidth;
  final double nameColWidth;
  final double indexColWidth;
  final double monthRowHeight;
  final List<String> monthNames;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: monthRowHeight,
      color: const Color(0xFF1F2937),
      child: Row(
        children: [
          _TableCell(
            width: indexColWidth,
            bg: const Color(0xFF1F2937),
            borderColor: const Color(0xFF374151),
            child: const Center(
              child: Text(
                '#',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFD1D5DB),
                ),
              ),
            ),
          ),
          _TableCell(
            width: nameColWidth,
            bg: const Color(0xFF1F2937),
            borderColor: const Color(0xFF374151),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'ПІБ студента',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFD1D5DB),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          ...groups.map(
                (g) => _TableCell(
              width: g.$2.length * colWidth,
              bg: const Color(0xFF1F2937),
              borderColor: const Color(0xFF374151),
              isLast: g == groups.last,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF374151),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    monthNames[g.$1],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFD1D5DB),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonTagRow extends StatelessWidget {
  const _LessonTagRow({
    required this.lessons,
    required this.colWidth,
    required this.nameColWidth,
    required this.indexColWidth,
    required this.tagRowHeight,
  });

  final List<JournalLesson> lessons;
  final double colWidth;
  final double nameColWidth;
  final double indexColWidth;
  final double tagRowHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: tagRowHeight,
      decoration: const BoxDecoration(
        color: Color(0xFF374151),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF4B5563),
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: [
          _TableCell(
            width: indexColWidth,
            bg: const Color(0xFF374151),
            borderColor: const Color(0xFF4B5563),
            child: const SizedBox(),
          ),
          _TableCell(
            width: nameColWidth,
            bg: const Color(0xFF374151),
            borderColor: const Color(0xFF4B5563),
            child: const SizedBox(),
          ),
          ...lessons.asMap().entries.map(
                (e) {
              final date = e.value.date;
              final dateStr =
                  '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';

              return _TableCell(
                width: colWidth,
                bg: const Color(0xFF374151),
                borderColor: const Color(0xFF4B5563),
                isLast: e.key == lessons.length - 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B5563),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        e.value.groupTag ?? '',
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFFE5E7EB),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.width,
    required this.child,
    this.bg = Colors.white,
    this.borderColor = const Color(0xFFE5E7EB),
    this.isLast = false,
  });

  final double width;
  final Widget child;
  final Color bg;
  final Color borderColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: isLast
          ? BoxDecoration(color: bg)
          : BoxDecoration(
        color: bg,
        border: Border(
          right: BorderSide(color: borderColor),
        ),
      ),
      child: child,
    );
  }
}