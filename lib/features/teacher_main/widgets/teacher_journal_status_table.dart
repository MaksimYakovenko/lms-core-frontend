import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../common/components/app_button.dart';
import '../../../common/constants/colors.dart';
import '../../../config/routers/view_identifiers.dart';
import '../../journals/journal_details/journal_details_service.dart';
import '../../journals/journals/journals_service.dart';

class TeacherJournalStatusTable extends StatefulWidget {
  const TeacherJournalStatusTable({super.key});

  @override
  State<TeacherJournalStatusTable> createState() => _TeacherJournalStatusTableState();
}

class _TeacherJournalStatusTableState extends State<TeacherJournalStatusTable> {
  final _service = JournalsService();
  late Future<List<Journal>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getTeacherJournals();
  }

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Мої журнали',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Управління класними журналами та відвідуваністю',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                AppButton(
                  variant: ButtonVariant.outline,
                  size: ButtonSize.defaultSize,
                  onPressed: () => context.go('/journals'),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.calendar, size: 16, color: AppColors.textPrimary),
                      SizedBox(width: 6),
                      Text('Всі журнали'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          FutureBuilder<List<Journal>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Помилка: ${snapshot.error}',
                    style: const TextStyle(color: AppColors.red600, fontSize: 14),
                  ),
                );
              }

              final journals = snapshot.data ?? [];

              if (journals.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: const [
                        Icon(LucideIcons.bookX, size: 36, color: AppColors.gray400),
                        SizedBox(height: 12),
                        Text(
                          'Журналів ще немає',
                          style: TextStyle(fontSize: 14, color: AppColors.gray400),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final rows = <_JournalRow>[];
              for (final j in journals) {
                for (final g in j.groups) {
                  rows.add(_JournalRow(
                    journalId: g.journalId,
                    group: '${g.name} (курс ${g.courseNumber})',
                    subject: j.subject,
                    lastUpdated: g.lastUpdated,
                  ));
                }
              }

              return Column(
                children: [
                  Container(
                    color: const Color(0xFFF9FAFB),
                    child: Row(
                      children: const [
                        _HeadCell('Група', flex: 2),
                        _HeadCell('Предмет', flex: 2),
                        _HeadCell('Середній бал', flex: 2),
                        _HeadCell('Відвідуваність', flex: 2),
                        _HeadCell('Останнє оновлення', flex: 2),
                        _HeadCell('', flex: 1),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  ...rows.map((r) => _TableRow(r: r)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _JournalRow {
  final int journalId;
  final String group;
  final String subject;
  final DateTime? lastUpdated;

  const _JournalRow({
    required this.journalId,
    required this.group,
    required this.subject,
    this.lastUpdated,
  });
}

String _formatDate(DateTime date) {
  final d = date.toLocal();
  return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

class _TableRow extends StatefulWidget {
  const _TableRow({required this.r});
  final _JournalRow r;

  @override
  State<_TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<_TableRow> {
  final _detailsService = JournalDetailsService();
  late Future<({String avgScore, String attendance})> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _loadStats();
  }

  Future<({String avgScore, String attendance})> _loadStats() async {
    final details = await _detailsService.getJournalById(widget.r.journalId);
    int scoreSum = 0, scoreCount = 0, totalEntries = 0, absentCount = 0;
    for (final student in details.students) {
      for (final grade in student.grades) {
        if (grade.value == null) continue;
        final v = grade.value!.trim();
        totalEntries++;
        if (v == 'ХВ' || v == 'П/П') {
          absentCount++;
        } else {
          final score = int.tryParse(v);
          if (score != null) { scoreSum += score; scoreCount++; }
        }
      }
    }
    final avgScore = scoreCount > 0 ? (scoreSum / scoreCount).toStringAsFixed(1) : '—';
    final attendance = totalEntries > 0
        ? '${((1 - absentCount / totalEntries) * 100).toStringAsFixed(0)}%'
        : '—';
    return (avgScore: avgScore, attendance: attendance);
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _DataCell(
              child: Text(r.group,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            ),
          ),
          Expanded(
            flex: 2,
            child: _DataCell(
              child: Text(r.subject,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ),
          ),
          Expanded(
            flex: 2,
            child: _DataCell(
              child: FutureBuilder(
                future: _statsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(width: 12, height: 12,
                        child: CircularProgressIndicator(strokeWidth: 1.5));
                  }
                  final avg = snapshot.data?.avgScore ?? '—';
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.star, size: 13,
                          color: avg == '—' ? AppColors.gray400 : const Color(0xFFD97706)),
                      const SizedBox(width: 4),
                      Text(avg,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: avg == '—' ? AppColors.gray400 : AppColors.textPrimary)),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _DataCell(
              child: FutureBuilder(
                future: _statsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(width: 12, height: 12,
                        child: CircularProgressIndicator(strokeWidth: 1.5));
                  }
                  final att = snapshot.data?.attendance ?? '—';
                  final pct = att == '—' ? null : int.tryParse(att.replaceAll('%', ''));
                  final color = pct == null
                      ? AppColors.gray400
                      : pct >= 75 ? const Color(0xFF16A34A)
                      : pct >= 50 ? const Color(0xFFD97706)
                      : AppColors.red600;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.userCheck, size: 13, color: color),
                      const SizedBox(width: 4),
                      Text(att,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _DataCell(
              child: r.lastUpdated != null
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.clock, size: 13, color: AppColors.gray400),
                  const SizedBox(width: 5),
                  Text(_formatDate(r.lastUpdated!),
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ],
              )
                  : const Text('—', style: TextStyle(fontSize: 13, color: AppColors.gray400)),
            ),
          ),
          Expanded(
            flex: 1,
            child: _DataCell(
              child: AppButton(
                variant: ButtonVariant.outline,
                size: ButtonSize.sm,
                onPressed: () => context.goNamed(
                  ViewIdentifiers.journalDetails.name,
                  pathParameters: {'id': r.journalId.toString()},
                ),
                child: const Text('Відкрити', style: TextStyle(fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeadCell extends StatelessWidget {
  const _HeadCell(this.text, {required this.flex});
  final String text;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  const _DataCell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: child,
    );
  }
}

