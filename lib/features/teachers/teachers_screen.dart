import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/teachers/teachers_service.dart';
import 'package:lms_core_frontend/common/components/app_card.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_table.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/teachers/widgets/teacher_status_badge.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/features/teachers/widgets/teacher_role_badge.dart';
import 'package:lms_core_frontend/features/teachers/widgets/teacher_last_login_cell.dart';
import 'package:lms_core_frontend/features/teachers/widgets/teacher_action_menu.dart';
import 'package:lms_core_frontend/features/teachers/widgets/teachers_search_field.dart';
import 'package:lms_core_frontend/features/teachers/widgets/teachers_error_body.dart';
import 'package:lms_core_frontend/features/teachers/dialogs/create_teacher_dialog.dart';

import '../groups/groups_service.dart';

const _kColumns = [
  AppTableColumn(label: 'ID', width: FlexColumnWidth(0.4)),
  AppTableColumn(label: 'Ім\'я', width: FlexColumnWidth(1.6)),
  AppTableColumn(label: 'Пошта', width: FlexColumnWidth(2.2)),
  AppTableColumn(label: 'Роль', width: FlexColumnWidth(0.9), center: true),
  AppTableColumn(label: 'Групи', width: FlexColumnWidth(1.2)),
  AppTableColumn(label: 'Статус', width: FlexColumnWidth(1.3), center: true),
  AppTableColumn(
    label: 'Останній вхід',
    width: FlexColumnWidth(1.6),
    center: true,
  ),
  AppTableColumn(label: 'Дії', width: FlexColumnWidth(0.5), center: true),
];

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  static const _itemsPerPage = 8;

  final _service = TeachersService();
  final _groupService = GroupsService();
  Map<int, Group> _groupsMap = {};
  List<TeacherUser> _teachers = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  String _search = '';
  final _searchController = TextEditingController();

  List<TeacherUser> get _filtered {
    if (_search.isEmpty) return _teachers;
    final q = _search.toLowerCase();
    return _teachers
        .where(
          (a) =>
      a.name.toLowerCase().contains(q) ||
          a.email.toLowerCase().contains(q),
    )
        .toList();
  }

  List<TeacherUser> get _paginated {
    final all = _filtered;
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, all.length);
    return all.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _service.getTeachers();
      final groups = await _groupService.getGroups();
      setState(() {
        _teachers = data;
        _groupsMap = {for (var g in groups) g.id: g};
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<List<Widget>> _buildRows(List<TeacherUser> page) {
    return page
        .map(
          (a) => [
        Text(
          '${a.id}',
          style: const TextStyle(fontSize: 14, color: AppColors.gray900),
        ),
        Text(
          a.name.isEmpty ? '—' : a.name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.gray900,
          ),
        ),
        Text(
          a.email,
          style: const TextStyle(fontSize: 14, color: AppColors.gray700),
        ),
        TeacherRoleBadge(role: a.role),
        _buildGroupCells(a.groupIds),
        TeacherStatusBadge(status: TeacherStatus.fromString(a.status)),
        TeacherLastLoginCell(lastLogin: a.lastLogin),
        TeacherActionMenu(teacher: a, onRefresh: _load, service: _service),
      ],
    )
        .toList();
  }

  Widget _buildGroupCells(List<int> groupIds) {
    if (groupIds.isEmpty) {
      return const Text(
        '—',
        style: TextStyle(fontSize: 14, color: AppColors.gray400),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: groupIds.map((groupId) {
        final group = _groupsMap[groupId];

        if (group == null) {
          return Text(
            'ID $groupId',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: AppColors.gray400),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                group.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Курс ${group.courseNumber}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.gray400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AppCard(
        children: [
          AppCardHeader(
            title: const AppCardTitle(text: 'Викладачі'),
            description: const AppCardDescription(
              text: 'Керування обліковими записами викладачів',
            ),
          ),
          AppCardContent(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 320,
                  child: TeacherSearchField(
                    controller: _searchController,
                    onChanged:
                        (val) => setState(() {
                      _search = val;
                      _currentPage = 1;
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: AppButton(
                    variant: ButtonVariant.outline,
                    size: ButtonSize.lg,
                    onPressed:
                        () => showCreateTeacherDialog(
                      context,
                      service: _service,
                      onRefresh: _load,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.userRoundPlus,
                          size: 20,
                          color: AppColors.gray900,
                        ),
                        SizedBox(width: 6),
                        Text('Створити викладача'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppCardContent(
            isLast: true,
            child:
            _error != null
                ? TeacherErrorBody(error: _error!, onRetry: _load)
                : AppTable(
              columns: _kColumns,
              rows: _isLoading ? [] : _buildRows(_paginated),
              totalCount: _filtered.length,
              currentPage: _currentPage,
              itemsPerPage: _itemsPerPage,
              isLoading: _isLoading,
              emptyText: 'Викладачів не знайдено',
              onPageChange: (p) => setState(() => _currentPage = p),
            ),
          ),
        ],
      ),
    );
  }
}
