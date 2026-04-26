import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_card.dart';
import 'package:lms_core_frontend/common/components/app_table.dart';

// ── Модель ───────────────────────────────────────────────────────────────────

enum StudentStatus { passed, failed, pending }

class StudentResult {
  final String id;
  final String name;
  final int math;
  final int english;
  final int science;

  const StudentResult({
    required this.id,
    required this.name,
    required this.math,
    required this.english,
    required this.science,
  });

  int get total => math + english + science;
  double get average => total / 3;

  StudentStatus get status {
    if (average >= 60) return StudentStatus.passed;
    if (average >= 40) return StudentStatus.pending;
    return StudentStatus.failed;
  }
}

// ── Токени ───────────────────────────────────────────────────────────────────

const _kGray100 = Color(0xFFF3F4F6);
const _kGray200 = Color(0xFFE5E7EB);
const _kGray700 = Color(0xFF374151);
const _kGray900 = Color(0xFF111827);
const _kBlue600 = Color(0xFF2563EB);
const _kGreen100 = Color(0xFFDCFCE7);
const _kGreen700 = Color(0xFF15803D);
const _kYellow100 = Color(0xFFFEF9C3);
const _kYellow700 = Color(0xFFA16207);
const _kRed100 = Color(0xFFFFE4E6);
const _kRed600 = Color(0xFFDC2626);
const _kRed700 = Color(0xFFB91C1C);

// ── Тестові дані ─────────────────────────────────────────────────────────────

final _mockStudents = List.generate(23, (i) {
  final idx = i + 1;
  return StudentResult(
    id: 'STU-${idx.toString().padLeft(3, '0')}',
    name: [
      'Alice Johnson', 'Bob Smith', 'Carol White', 'David Brown',
      'Eva Green', 'Frank Lee', 'Grace Kim', 'Henry Davis',
      'Irene Clark', 'Jack Wilson', 'Karen Hall', 'Leo Young',
      'Mia Turner', 'Nick Adams', 'Olivia Scott', 'Paul Baker',
      'Quinn Nelson', 'Rachel Carter', 'Sam Mitchell', 'Tina Roberts',
      'Uma Collins', 'Victor Hughes', 'Wendy Stewart',
    ][i],
    math: 50 + (idx * 17) % 51,
    english: 45 + (idx * 13) % 56,
    science: 40 + (idx * 19) % 61,
  );
});

// ── Колонки ──────────────────────────────────────────────────────────────────

const _kColumns = [
  AppTableColumn(label: 'ID Студента', width: FlexColumnWidth(1.4)),
  AppTableColumn(label: 'Ім\'я студента', width: FlexColumnWidth(2.0)),
  AppTableColumn(label: 'Математика', width: FlexColumnWidth(1.0), center: true),
  AppTableColumn(label: 'Англійська', width: FlexColumnWidth(1.0), center: true),
  AppTableColumn(label: 'Природознавство', width: FlexColumnWidth(1.0), center: true),
  AppTableColumn(label: 'Сума', width: FlexColumnWidth(0.9), center: true),
  AppTableColumn(label: 'Середнє', width: FlexColumnWidth(1.0), center: true),
  AppTableColumn(label: 'Місце', width: FlexColumnWidth(1.0), center: true),
  AppTableColumn(label: 'Статус', width: FlexColumnWidth(1.2), center: true),
  AppTableColumn(label: 'Дії', width: FlexColumnWidth(0.8), right: true),
];

// ── ResultsScreen ────────────────────────────────────────────────────────────

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  static const _itemsPerPage = 8;
  int _currentPage = 1;

  List<StudentResult> get _sorted {
    final list = List<StudentResult>.from(_mockStudents);
    list.sort((a, b) => b.average.compareTo(a.average));
    return list;
  }

  List<StudentResult> get _paginated {
    final all = _sorted;
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, all.length);
    return all.sublist(start, end);
  }

  List<List<Widget>> _buildRows(
    List<StudentResult> paginated,
    List<StudentResult> all,
  ) {
    return paginated.map((s) {
      final position = all.indexOf(s) + 1;
      return [
        Text(s.id,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: _kBlue600, fontSize: 14)),
        Text(s.name,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14, color: _kGray900)),
        _GradeBadge(grade: s.math),
        _GradeBadge(grade: s.english),
        _GradeBadge(grade: s.science),
        Text('${s.total}',
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14, color: _kGray900)),
        Text('${s.average.toStringAsFixed(1)}%',
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14, color: _kGray900)),
        _PositionBadge(position: position),
        _StatusCell(status: s.status),
        _ActionsMenu(student: s),
      ];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final all = _sorted;
    final paginated = _paginated;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: AppCard(
          children: [
            AppCardHeader(
              title: const AppCardTitle(text: 'Результати студентів'),
              description: const AppCardDescription(
                text: 'Огляд успішності',
              ),
            ),
            AppCardContent(
              isLast: true,
              child: AppTable(
                columns: _kColumns,
                rows: _buildRows(paginated, all),
                totalCount: all.length,
                currentPage: _currentPage,
                itemsPerPage: _itemsPerPage,
                onPageChange: (page) => setState(() => _currentPage = page),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── GradeBadge ───────────────────────────────────────────────────────────────

class _GradeBadge extends StatelessWidget {
  const _GradeBadge({required this.grade});

  final int grade;

  Color get _bg => grade >= 70 ? _kGreen100 : (grade >= 50 ? _kYellow100 : _kRed100);
  Color get _fg => grade >= 70 ? _kGreen700 : (grade >= 50 ? _kYellow700 : _kRed700);
  Color get _border => grade >= 70
      ? const Color(0xFFBBF7D0)
      : (grade >= 50 ? const Color(0xFFFDE68A) : const Color(0xFFFECACA));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _bg,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('$grade',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: _fg)),
    );
  }
}

// ── PositionBadge ────────────────────────────────────────────────────────────

class _PositionBadge extends StatelessWidget {
  const _PositionBadge({required this.position});

  final int position;

  String get _suffix {
    if (position == 1) return 'st';
    if (position == 2) return 'nd';
    if (position == 3) return 'rd';
    return 'th';
  }

  @override
  Widget build(BuildContext context) {
    final isTop3 = position <= 3;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isTop3 ? _kGray900 : _kGray100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$position$_suffix',
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isTop3 ? Colors.white : _kGray700),
      ),
    );
  }
}

// ── StatusCell ───────────────────────────────────────────────────────────────

class _StatusCell extends StatelessWidget {
  const _StatusCell({required this.status});

  final StudentStatus status;

  IconData get _icon => switch (status) {
        StudentStatus.passed => LucideIcons.circleCheck,
        StudentStatus.failed => LucideIcons.circleX,
        StudentStatus.pending => LucideIcons.clock,
      };

  Color get _color => switch (status) {
        StudentStatus.passed => _kGreen700,
        StudentStatus.failed => _kRed600,
        StudentStatus.pending => _kYellow700,
      };

  String get _label => switch (status) {
        StudentStatus.passed => 'Здав',
        StudentStatus.failed => 'Не здав',
        StudentStatus.pending => 'Очікується',
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_icon, size: 15, color: _color),
        const SizedBox(width: 5),
        Text(_label,
            style: TextStyle(
                fontSize: 13, color: _color, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ── ActionsMenu ──────────────────────────────────────────────────────────────

class _ActionsMenu extends StatelessWidget {
  const _ActionsMenu({required this.student});

  final StudentResult student;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_Action>(
      icon: const Icon(LucideIcons.ellipsisVertical, size: 16, color: _kGray700),
      iconSize: 16,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: _kGray200),
      ),
      elevation: 4,
      onSelected: (action) => _onAction(context, action),
      itemBuilder: (_) => const [
        PopupMenuItem(
            value: _Action.edit,
            child: _MenuItem(icon: LucideIcons.pencil, label: 'Редагувати результати')),
        PopupMenuItem(
            value: _Action.download,
            child: _MenuItem(
                icon: LucideIcons.download, label: 'Завантажити звіт')),
        PopupMenuItem(
            value: _Action.delete,
            child: _MenuItem(
                icon: LucideIcons.trash2, label: 'Видалити', color: _kRed600)),
      ],
    );
  }

  void _onAction(BuildContext context, _Action action) {
    final msg = switch (action) {
      _Action.edit => 'Edit: ${student.name}',
      _Action.download => 'Download: ${student.name}',
      _Action.delete => 'Delete: ${student.name}',
    };
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 1)));
  }
}

enum _Action { edit, download, delete }

class _MenuItem extends StatelessWidget {
  const _MenuItem(
      {required this.icon, required this.label, this.color = _kGray900});

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
