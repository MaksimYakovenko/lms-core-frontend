import 'package:flutter/material.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_stat_card.dart';
import 'package:lms_core_frontend/common/components/app_table.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// ── Models ────────────────────────────────────────────────────────────────────

class _Teacher {
  final int id;
  final String name;
  const _Teacher(this.id, this.name);
}

class _Subject {
  final int id;
  final String name;
  const _Subject(this.id, this.name);
}

class _Group {
  final int id;
  final String name;
  const _Group(this.id, this.name);
}

class _Journal {
  final int id;
  final _Group group;
  final _Subject subject;
  final _Teacher teacher;

  const _Journal({
    required this.id,
    required this.group,
    required this.subject,
    required this.teacher,
  });
}

// ── Mock data ─────────────────────────────────────────────────────────────────

const _teacher = _Teacher(1, 'Teacher Teacher');

final _mockJournals = [
  _Journal(id: 1, group: _Group(15, 'Середня освіта'), subject: _Subject(1, 'Історія України'), teacher: _teacher),
  _Journal(id: 2, group: _Group(15, 'Середня освіта'), subject: _Subject(2, 'Історія: Україна і світ'), teacher: _teacher),
  _Journal(id: 3, group: _Group(16, 'Старша школа'), subject: _Subject(3, 'Алгебра'), teacher: _teacher),
  _Journal(id: 4, group: _Group(16, 'Старша школа'), subject: _Subject(4, 'Англійська мова'), teacher: _teacher),
  _Journal(id: 5, group: _Group(16, 'Старша школа'), subject: _Subject(5, 'Біологія та екологія'), teacher: _teacher),
  _Journal(id: 6, group: _Group(15, 'Середня освіта'), subject: _Subject(6, 'Всесвітня історія'), teacher: _teacher),
  _Journal(id: 7, group: _Group(16, 'Старша школа'), subject: _Subject(7, 'Географія'), teacher: _teacher),
  _Journal(id: 8, group: _Group(16, 'Старша школа'), subject: _Subject(8, 'Геометрія'), teacher: _teacher),
  _Journal(id: 9, group: _Group(15, 'Середня освіта'), subject: _Subject(9, 'Громадянська освіта'), teacher: _teacher),
  _Journal(id: 10, group: _Group(16, 'Старша школа'), subject: _Subject(10, 'Громадянська освіта (інтегрований курс)'), teacher: _teacher),
  _Journal(id: 11, group: _Group(16, 'Старша школа'), subject: _Subject(11, 'Зарубіжна література'), teacher: _teacher),
  _Journal(id: 12, group: _Group(16, 'Старша школа'), subject: _Subject(12, 'Захист України'), teacher: _teacher),
  _Journal(id: 13, group: _Group(16, 'Старша школа'), subject: _Subject(13, 'Математика'), teacher: _teacher),
];

const _classMapping = <String, List<String>>{
  'Історія України': ['7-А', '7-Б', '8-Б', '11-Б'],
  'Історія: Україна і світ': ['10-А', '11-А', '11-Б'],
  'Алгебра': ['10-А'],
  'Англійська мова': ['10-А'],
  'Біологія та екологія': ['10-А'],
  'Всесвітня історія': ['7-А', '7-Б', '8-Б', '11-Б'],
  'Географія': ['10-А'],
  'Геометрія': ['10-А'],
  'Громадянська освіта': ['7-А', '7-Б', '8-Б'],
  'Громадянська освіта (інтегрований курс)': ['10-А'],
  'Зарубіжна література': ['10-А'],
  'Захист України': ['10-А(1)', '10-А(2)'],
  'Математика': ['10-А'],
};

List<String> _classesFor(String subject) => _classMapping[subject] ?? ['10-А'];

// ── Screen ────────────────────────────────────────────────────────────────────

class JournalsScreen extends StatefulWidget {
  const JournalsScreen({super.key});

  @override
  State<JournalsScreen> createState() => _JournalsScreenState();
}

class _JournalsScreenState extends State<JournalsScreen> {
  int _page = 1;
  static const _perPage = 8;

  @override
  Widget build(BuildContext context) {
    final journals = _mockJournals;

    final rows = journals.map((j) {
      final classes = _classesFor(j.subject.name);

      return [
        Text(
          j.subject.name,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: classes.map((c) => _Badge(label: c)).toList(),
        ),
      ];
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Журнали',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Управління класними журналами та відвідуваністю',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                AppButton(
                  variant: ButtonVariant.black,
                  size: ButtonSize.defaultSize,
                  onPressed: () {},
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.circlePlus, size: 16),
                      SizedBox(width: 8),
                      Text('Створити журнал'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: AppStatCard(
                    isRight: true,
                    title: 'Всього журналів',
                    value: journals.length.toString(),
                    icon: LucideIcons.bookOpen,
                    iconBgColor: const Color(0xFFE0E7FF),
                    iconColor: const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: AppStatCard(
                    isRight: true,
                    title: 'Активні класи',
                    value: '24',
                    icon: LucideIcons.fileText,
                    iconBgColor: Color(0xFFDCFCE7),
                    iconColor: Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: AppStatCard(
                    isRight: true,
                    title: 'Останні перегляди',
                    value: '15',
                    icon: LucideIcons.eye,
                    iconBgColor: Color(0xFFF3E8FF),
                    iconColor: Color(0xFF9333EA),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                AppButton(
                  variant: ButtonVariant.outline,
                  size: ButtonSize.defaultSize,
                  onPressed: () {},
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.eye, size: 16),
                      SizedBox(width: 8),
                      Text('Відвідуваність'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AppButton(
                  variant: ButtonVariant.outline,
                  size: ButtonSize.defaultSize,
                  onPressed: () {},
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.fileText, size: 16),
                      SizedBox(width: 8),
                      Text('Зведені звіти'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: const Text(
                'Оберіть журнал:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            AppTable(
              columns: const [
                AppTableColumn(label: 'Предмет', width: FlexColumnWidth(4)),
                AppTableColumn(label: 'Клас', width: FlexColumnWidth(4)),
              ],
              rows: rows,
              totalCount: journals.length,
              currentPage: _page,
              itemsPerPage: _perPage,
              onPageChange: (p) => setState(() => _page = p),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Badge widget ─────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}