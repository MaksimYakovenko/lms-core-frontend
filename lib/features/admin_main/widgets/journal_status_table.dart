import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../common/components/app_button.dart';
import '../../../common/constants/colors.dart';
import '../../../config/routers/view_identifiers.dart';
import '../../journals/journals/journals_service.dart';

class JournalStatusTable extends StatefulWidget {
  const JournalStatusTable({super.key});

  @override
  State<JournalStatusTable> createState() => _JournalStatusTableState();
}

class _JournalStatusTableState extends State<JournalStatusTable> {
  final _service = JournalsService();
  late Future<List<Journal>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getJournals();
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
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Статус журналів',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Відстежуйте прогрес внесення оцінок',
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
                    teacherName: g.teacherName,
                    lastUpdated: g.lastUpdated,
                  ));
                }
              }

              return Column(
                children: [
                  // Header row
                  Container(
                    color: const Color(0xFFF9FAFB),
                    child: Row(
                      children: const [
                        _HeadCell('Група', flex: 2),
                        _HeadCell('Предмет', flex: 2),
                        _HeadCell('Викладач', flex: 2),
                        _HeadCell('Останнє оновлення', flex: 2),
                        _HeadCell('', flex: 1),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  // Data rows
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
  final String? teacherName;
  final DateTime? lastUpdated;

  const _JournalRow({
    required this.journalId,
    required this.group,
    required this.subject,
    this.teacherName,
    this.lastUpdated,
  });
}

String _formatDate(DateTime date) {
  final d = date.toLocal();
  return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.r});
  final _JournalRow r;

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                r.group,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _DataCell(
              child: Text(
                r.subject,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _DataCell(
              child: Text(
                r.teacherName ?? '—',
                style: TextStyle(
                  fontSize: 14,
                  color: r.teacherName != null ? AppColors.textSecondary : AppColors.gray400,
                ),
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
                        Text(
                          _formatDate(r.lastUpdated!),
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
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
                child: const Text('Переглянути', style: TextStyle(fontSize: 13)),
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

