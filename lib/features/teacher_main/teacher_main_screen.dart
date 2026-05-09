import 'package:flutter/material.dart';
import 'package:lms_core_frontend/common/components/app_stat_card.dart';
import 'package:lms_core_frontend/features/teacher_main/teacher_main_service.dart';
import 'package:lms_core_frontend/features/teacher_main/widgets/teacher_journal_status_table.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../common/constants/colors.dart';

class TeacherMainScreen extends StatefulWidget {
  const TeacherMainScreen({super.key});

  @override
  State<TeacherMainScreen> createState() => _TeacherMainScreenState();
}

class _TeacherMainScreenState extends State<TeacherMainScreen> {
  final TeacherMainService _service = TeacherMainService();

  bool _isLoading = true;
  String _displayName = '';
  final Map<String, int> _totals = {
    'total_teachers': 0,
    'total_students': 0,
    'total_groups': 0,
    'total_subjects': 0,
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final name = await _service.fetchDisplayName(context);
      setState(() {
        _displayName = name!;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isLoading
              ? const SizedBox(
            height: 28,
            width: 200,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: Color(0xFF2563EB),
              backgroundColor: Color(0xFFE0E7FF),
            ),
          )
              : Text(
            'Вітаємо, $_displayName 👋!',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Панель викладача надає швидкий доступ до основних функцій та статистики вашого навчального процесу',
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 36),

          if (_isLoading)
            Row(
              children:
              List.generate(
                4,
                    (i) => [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.background1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (i < 3) const SizedBox(width: 24),
                ],
              ).expand((e) => e).toList(),
            )
          else
            Row(
              children: [
                Expanded(
                  child: AppStatCard(
                    title: 'Мої групи',
                    value: _totals['total_teachers']!.toString(),
                    icon: LucideIcons.graduationCap,
                    iconBgColor: const Color(0xFFE0E7FF),
                    iconColor: const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AppStatCard(
                    title: 'Пар сьогодні',
                    value: _totals['total_students']!.toString(),
                    icon: LucideIcons.calendar,
                    iconBgColor: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AppStatCard(
                    title: 'Оцінок внесено',
                    value: _totals['total_groups']!.toString(),
                    icon: LucideIcons.chartArea,
                    iconBgColor: const Color(0xFFF3E8FF),
                    iconColor: const Color(0xFF9333EA),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AppStatCard(
                    title: 'Середній бал',
                    value: _totals['total_subjects']!.toString(),
                    icon: LucideIcons.bookOpen,
                    iconBgColor: const Color(0xFFFFEDD5),
                    iconColor: const Color(0xFFEA580C),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          TeacherJournalStatusTable(),
        ],
      ),
    );
  }
}
