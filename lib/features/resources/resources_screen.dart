import 'package:flutter/material.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/journals/journals_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JournalDetailsScreen extends StatefulWidget {
  const JournalDetailsScreen({super.key, required this.journalId});

  final String journalId;

  @override
  State<JournalDetailsScreen> createState() => _JournalDetailsScreenState();
}

class _JournalDetailsScreenState extends State<JournalDetailsScreen> {
  final _service = JournalsService();
  late Future<JournalDetails> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getJournalById(int.parse(widget.journalId));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JournalDetails>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(
            child: Text(
              'Помилка: ${snap.error}',
              style: const TextStyle(color: AppColors.red600),
            ),
          );
        }
        final journal = snap.data!;
        return _JournalView(journal: journal);
      },
    );
  }
}

class _JournalView extends StatefulWidget {
  const _JournalView({required this.journal});

  final JournalDetails journal;

  @override
  State<_JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<_JournalView> {
  String _filter = 'Всі уроки';

  static const _ukMonths = [
    '',
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

  List<JournalLesson> get _visibleLessons {
    if (_filter == 'Всі уроки') return widget.journal.lessons;
    return widget.journal.lessons.where((l) => l.groupTag == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final journal = widget.journal;
    final lessons = _visibleLessons;

    // group lessons by month
    final Map<int, List<JournalLesson>> byMonth = {};
    for (final l in lessons) {
      byMonth.putIfAbsent(l.date.month, () => []).add(l);
    }
    final months = byMonth.keys.toList()..sort();

    // unique group tags for filter dropdown
    final tags = {
      'Всі уроки',
      ...journal.lessons
          .map((l) => l.groupTag ?? '')
          .where((t) => t.isNotEmpty),
    };

    const double indexW = 36;
    const double nameW = 180;
    const double cellW = 44;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            children: [
              // Back
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    LucideIcons.arrowLeft,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  children: [
                    const TextSpan(text: 'Журнал оцінок для '),
                    TextSpan(
                      text: journal.groupName,
                      style: const TextStyle(color: Color(0xFFEF4444)),
                    ),
                    TextSpan(text: ' [${journal.subject}]'),
                  ],
                ),
              ),
              const Spacer(),
              // Teacher info
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFE5E7EB),
                    child: Icon(
                      LucideIcons.user,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'викладач:',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    journal.teacherName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Toolbar ─────────────────────────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(
            children: [
              // Filter dropdown
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.gray400, width: 1.5),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _filter,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    items:
                    tags
                        .map(
                          (t) => DropdownMenuItem(value: t, child: Text(t)),
                    )
                        .toList(),
                    onChanged: (v) => setState(() => _filter = v!),
                  ),
                ),
              ),
              const Spacer(),
              // Action buttons
              _ToolbarButton(
                icon: LucideIcons.layoutGrid,
                label: 'Індекс НУШ',
                onTap: () {},
              ),
              const SizedBox(width: 16),
              _ToolbarButton(
                icon: LucideIcons.circlePlus,
                label: 'Додати стовпець',
                onTap: () {},
              ),
              const SizedBox(width: 16),
              _ToolbarButton(
                icon: LucideIcons.folderPlus,
                label: 'Додати підгрупу',
                onTap: () {},
              ),
            ],
          ),
        ),

        const Divider(height: 1, color: AppColors.divider),
        Expanded(
          child:
          lessons.isEmpty
              ? const Center(
            child: Text(
              'Уроків не знайдено',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          )
              : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month header row
                  _MonthHeaderRow(
                    months: months,
                    byMonth: byMonth,
                    indexW: indexW,
                    nameW: nameW,
                    cellW: cellW,
                    ukMonths: _ukMonths,
                  ),
                  // Group tag + date header row
                  _LessonHeaderRow(
                    lessons: lessons,
                    indexW: indexW,
                    nameW: nameW,
                    cellW: cellW,
                  ),
                  // Student rows
                  ...journal.students.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final student = entry.value;
                    return _StudentRow(
                      index: idx + 1,
                      student: student,
                      lessons: lessons,
                      indexW: indexW,
                      nameW: nameW,
                      cellW: cellW,
                      isEven: idx.isEven,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Toolbar button ───────────────────────────────────────────────────────────

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthHeaderRow extends StatelessWidget {
  const _MonthHeaderRow({
    required this.months,
    required this.byMonth,
    required this.indexW,
    required this.nameW,
    required this.cellW,
    required this.ukMonths,
  });

  final List<int> months;
  final Map<int, List<JournalLesson>> byMonth;
  final double indexW, nameW, cellW;
  final List<String> ukMonths;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: indexW + nameW),
          ...months.map((m) {
            final count = byMonth[m]!.length;
            return Container(
              width: cellW * count,
              padding: const EdgeInsets.symmetric(vertical: 6),
              alignment: Alignment.centerLeft,
              child: Text(
                ukMonths[m],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LessonHeaderRow extends StatelessWidget {
  const _LessonHeaderRow({
    required this.lessons,
    required this.indexW,
    required this.nameW,
    required this.cellW,
  });

  final List<JournalLesson> lessons;
  final double indexW, nameW, cellW;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Group tag row
        Row(
          children: [
            // "#" header
            Container(
              width: indexW,
              height: 28,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                border: Border(bottom: BorderSide(color: AppColors.divider)),
              ),
              child: const Text(
                '#',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // "ПІБ учня" header
            Container(
              width: nameW,
              height: 28,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                border: Border(bottom: BorderSide(color: AppColors.divider)),
              ),
              child: const Text(
                'ПІБ учня',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Group tag chips
            ...lessons.map(
                  (l) => Container(
                width: cellW,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  border: Border(bottom: BorderSide(color: AppColors.divider)),
                ),
                child:
                l.groupTag != null
                    ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l.groupTag!,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
        // Date row
        Row(
          children: [
            SizedBox(width: indexW + nameW),
            ...lessons.map(
                  (l) => Container(
                width: cellW,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  border: Border(bottom: BorderSide(color: AppColors.divider)),
                ),
                child: Text(
                  '${l.date.day}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({
    required this.index,
    required this.student,
    required this.lessons,
    required this.indexW,
    required this.nameW,
    required this.cellW,
    required this.isEven,
  });

  final int index;
  final JournalStudent student;
  final List<JournalLesson> lessons;
  final double indexW, nameW, cellW;
  final bool isEven;

  @override
  Widget build(BuildContext context) {
    final bg = isEven ? Colors.white : const Color(0xFFFAFAFA);

    return Row(
      children: [
        // Index
        Container(
          width: indexW,
          height: 36,
          alignment: Alignment.center,
          color: bg,
          child: Text(
            '$index',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        // Name
        Container(
          width: nameW,
          height: 36,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: bg,
            border: const Border(right: BorderSide(color: AppColors.divider)),
          ),
          child: Text(
            student.fullName,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFEF4444),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Grades
        ...lessons.map((l) {
          final val = student.gradeFor(l.id);
          return Container(
            width: cellW,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              border: const Border(
                right: BorderSide(color: AppColors.divider, width: 0.5),
              ),
            ),
            child:
            val == null
                ? const SizedBox.shrink()
                : Text(
              val,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _gradeColor(val),
              ),
            ),
          );
        }),
      ],
    );
  }

  Color _gradeColor(String val) {
    final n = int.tryParse(val);
    if (n == null) {
      // ХВ, п/п тощо
      return AppColors.textPrimary;
    }
    if (n >= 10) return const Color(0xFF16A34A);
    if (n >= 7) return const Color(0xFFCA8A04);
    return const Color(0xFFEF4444);
  }
}
