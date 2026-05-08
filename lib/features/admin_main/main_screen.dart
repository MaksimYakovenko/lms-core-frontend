import 'package:flutter/material.dart';
import 'package:lms_core_frontend/common/components/app_stat_card.dart';
import 'package:lms_core_frontend/features/admin_main/widgets/journal_status_table.dart';
import 'package:lms_core_frontend/features/admin_main/widgets/quick_actions.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/features/admin_main/main_service.dart';
import 'package:go_router/go_router.dart';
import '../../common/constants/colors.dart';
import '../classrooms/classrooms_service.dart';
import '../classrooms/dialogs/create_classroom_dialog.dart';
import '../groups/groups_service.dart';
import '../groups/dialogs/create_group_dialog.dart';
import '../journals/journals/journals_service.dart';
import '../journals/journals/dialogs/create_journal_dialog.dart';
import '../subjects/subjects_service.dart';
import '../subjects/dialogs/create_subject_dialog.dart';
import '../teachers/teachers_service.dart';
import '../teachers/dialogs/create_teacher_dialog.dart';
import '../../config/routers/view_identifiers.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  final AdminMainService _service = AdminMainService();
  final _teachersService = TeachersService();
  final _groupsService = GroupsService();
  final _subjectsService = SubjectsService();
  final _classroomsService = ClassroomsService();
  final _journalsService = JournalsService();

  bool _isLoading = true;
  Map<String, int> _totals = {
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
      final totals = await _service.fetchTotals(context);
      setState(() {
        _totals = totals!;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Панель адміністратора',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Управління університетською системою: викладачі, студенти, групи та предмети',
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
                    title: 'Викладачі',
                    value: _totals['total_teachers']!.toString(),
                    icon: LucideIcons.graduationCap,
                    iconBgColor: const Color(0xFFE0E7FF),
                    iconColor: const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AppStatCard(
                    title: 'Студенти',
                    value: _totals['total_students']!.toString(),
                    icon: LucideIcons.users,
                    iconBgColor: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AppStatCard(
                    title: 'Групи',
                    value: _totals['total_groups']!.toString(),
                    icon: LucideIcons.layers,
                    iconBgColor: const Color(0xFFF3E8FF),
                    iconColor: const Color(0xFF9333EA),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AppStatCard(
                    title: 'Предмети',
                    value: _totals['total_subjects']!.toString(),
                    icon: LucideIcons.bookOpen,
                    iconBgColor: const Color(0xFFFFEDD5),
                    iconColor: const Color(0xFFEA580C),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background1,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Швидкі дії',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = (constraints.maxWidth - 5 * 12) / 6;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        QuickActionButton(
                          icon: LucideIcons.graduationCap,
                          label: 'Додати викладача',
                          width: itemWidth,
                          onTap: () => showCreateTeacherDialog(
                            context,
                            service: _teachersService,
                            onRefresh: _load,
                          ),
                        ),
                        QuickActionButton(
                          icon: LucideIcons.userPlus,
                          label: 'Додати студента',
                          width: itemWidth,
                          onTap: () => context.go(ViewIdentifiers.students.path),
                        ),
                        QuickActionButton(
                          icon: LucideIcons.users,
                          label: 'Створити групу',
                          width: itemWidth,
                          onTap: () => showCreateGroupDialog(
                            context,
                            service: _groupsService,
                            onRefresh: _load,
                          ),
                        ),
                        QuickActionButton(
                          icon: LucideIcons.bookOpen,
                          label: 'Додати предмет',
                          width: itemWidth,
                          onTap: () => showCreateSubjectDialog(
                            context,
                            service: _subjectsService,
                            onRefresh: _load,
                          ),
                        ),
                        QuickActionButton(
                          icon: LucideIcons.building2,
                          label: 'Додати аудиторію',
                          width: itemWidth,
                          onTap: () => showCreateClassroomDialog(
                            context,
                            service: _classroomsService,
                            onRefresh: _load,
                          ),
                        ),
                        QuickActionButton(
                          icon: LucideIcons.bookMarked,
                          label: 'Створити журнал',
                          width: itemWidth,
                          onTap: () => createJournalDialog(
                            context,
                            service: _journalsService,
                            onRefresh: _load,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const JournalStatusTable(),
        ],
      ),
    );
  }
}
