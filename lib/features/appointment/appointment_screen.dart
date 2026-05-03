import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/appointment/appointment_service.dart';
import 'package:lms_core_frontend/features/appointment/widgets/appoinment_error_body.dart';
import 'package:lms_core_frontend/features/appointment/widgets/appointment_search_field.dart';
import 'package:lms_core_frontend/features/groups/groups_service.dart';
import 'package:lms_core_frontend/features/subjects/subjects_service.dart';
import 'package:lms_core_frontend/common/components/app_card.dart';
import 'package:lms_core_frontend/common/components/app_table.dart';

import '../../common/constants/colors.dart';

const _kColumns = [
  AppTableColumn(label: 'ID', width: FlexColumnWidth(0.4)),
  AppTableColumn(label: 'Ім\'я викладача', width: FlexColumnWidth(1.8)),
  AppTableColumn(label: 'Групи', width: FlexColumnWidth(2.0)),
  AppTableColumn(label: 'Предмети', width: FlexColumnWidth(2.0)),
];

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  static const _itemsPerPage = 8;

  final _appointmentService = AppointmentService();
  final _groupService = GroupsService();
  final _subjectService = SubjectsService();

  List<Appointment> _appointments = [];
  Map<int, Group> _groupsMap = {};
  Map<int, Subject> _subjectsMap = {};
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  String _search = '';
  final _searchController = TextEditingController();

  List<Appointment> get _filtered {
    if (_search.isEmpty) return _appointments;
    final q = _search.toLowerCase();
    return _appointments
        .where((a) => a.name.toLowerCase().contains(q))
        .toList();
  }

  List<Appointment> get _paginated {
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
      final appointments = await _appointmentService.getAppointments();
      final groups = await _groupService.getGroups();
      final subjects = await _subjectService.getSubjects();

      setState(() {
        _appointments = appointments;
        _groupsMap = {for (var g in groups) g.id: g};
        _subjectsMap = {for (var s in subjects) s.id: s};
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
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

  String _formatSubjectsList(List<int> subjectIds) {
    if (subjectIds.isEmpty) return '—';
    return subjectIds
        .map((id) {
          final subject = _subjectsMap[id];
          return subject != null ? subject.name : 'ID $id';
        })
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final tableRows =
        _paginated.map((appointment) {
          return [
            Text(appointment.id.toString()),
            Text(appointment.name),
            _buildGroupCells(appointment.groupIds),
            Text(_formatSubjectsList(appointment.subjectIds)),
          ];
        }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AppCard(
        children: [
          AppCardHeader(
            title: const AppCardTitle(text: 'Призначення'),
            description: const AppCardDescription(
              text: 'Повний список призначень викладачів до груп та предметів',
            ),
          ),
          AppCardContent(
            child: SizedBox(
              width: 320,
              child: AppointmentSearchField(
                controller: _searchController,
                onChanged:
                    (val) => setState(() {
                      _search = val;
                      _currentPage = 1;
                    }),
              ),
            ),
          ),
          AppCardContent(
            isLast: true,
            child:
                _error != null
                    ? AppointmentErrorBody(error: _error!, onRetry: _load)
                    : AppTable(
                      columns: _kColumns,
                      rows: _isLoading ? [] : tableRows,
                      totalCount: _filtered.length,
                      currentPage: _currentPage,
                      itemsPerPage: _itemsPerPage,
                      isLoading: _isLoading,
                      emptyText: 'Немає призначень',
                      onPageChange: (p) => setState(() => _currentPage = p),
                    ),
          ),
        ],
      ),
    );
  }
}
