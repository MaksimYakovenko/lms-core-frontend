import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../journal_details_service.dart';
import 'stat_card.dart';

class QuickStats extends StatelessWidget {
  const QuickStats({
    super.key,
    required this.journal,
  });

  final JournalDetails journal;

  @override
  Widget build(BuildContext context) {
    final students = journal.students;
    final totalStudents = students.length;

    int scoreSum = 0;
    int scoreCount = 0;
    int totalEntries = 0;
    int absentCount = 0;

    for (final student in students) {
      for (final grade in student.grades) {
        if (grade.value == null) continue;

        final v = grade.value!.trim();
        totalEntries++;

        if (v == 'ХВ' || v == 'П/П') {
          absentCount++;
        } else {
          final score = int.tryParse(v);

          if (score != null) {
            scoreSum += score;
            scoreCount++;
          }
        }
      }
    }

    final avgScore = scoreCount > 0
        ? (scoreSum / scoreCount).toStringAsFixed(1)
        : '—';

    final attendance = totalEntries > 0
        ? '${((1 - absentCount / totalEntries) * 100).toStringAsFixed(0)}%'
        : '—';

    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Всього студентів',
            value: '$totalStudents',
            bgColor: const Color(0xFFDBEAFE),
            iconColor: const Color(0xFF2563EB),
            icon: LucideIcons.bookOpen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            label: 'Середній бал',
            value: avgScore,
            bgColor: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF16A34A),
            icon: LucideIcons.chartBar,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            label: 'Відвідуваність',
            value: attendance,
            bgColor: const Color(0xFFF3E8FF),
            iconColor: const Color(0xFF9333EA),
            icon: LucideIcons.calendarCheck,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            label: 'Оцінки внесені',
            value: '$scoreCount',
            bgColor: const Color(0xFFFFEDD5),
            iconColor: const Color(0xFFEA580C),
            icon: LucideIcons.clipboardList,
          ),
        ),
      ],
    );
  }
}