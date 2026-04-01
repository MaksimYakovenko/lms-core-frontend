import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/students/students_service.dart';
import 'package:lms_core_frontend/common/components/app_card.dart';
import 'package:lms_core_frontend/common/components/app_table.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/students/widgets/student_role_badge.dart';
import 'package:lms_core_frontend/features/students/widgets/student_last_login_cell.dart';
import 'package:lms_core_frontend/features/students/widgets/student_action_menu.dart';
import 'package:lms_core_frontend/features/students/widgets/student_search_field.dart';
import 'package:lms_core_frontend/features/students/widgets/student_error_body.dart';

const _kColumns = [
  AppTableColumn(label: 'ID', width: FlexColumnWidth(0.6)),
  AppTableColumn(label: 'Ім\'я', width: FlexColumnWidth(2.0)),
  AppTableColumn(label: 'Пошта', width: FlexColumnWidth(2.5)),
  AppTableColumn(label: 'Роль', width: FlexColumnWidth(1.0), center: true),
  AppTableColumn(label: 'Останній вхід', width: FlexColumnWidth(2.0), center: true),
  AppTableColumn(label: 'Дії', width: FlexColumnWidth(0.8), right: true),
];

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  static const _itemsPerPage = 8;

  final _service = StudentsService();

  List<StudentUser> _students = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  String _search = '';
  final _searchController = TextEditingController();

  List<StudentUser> get _filtered {
    if (_search.isEmpty) return _students;
    final q = _search.toLowerCase();
    return _students
        .where((a) => a.name.toLowerCase().contains(q) || a.email.toLowerCase().contains(q))
        .toList();
  }

  List<StudentUser> get _paginated {
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
    setState(() { _isLoading = true; _error = null; });
    try {
      final data = await _service.getStudents();
      setState(() => _students = data);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<List<Widget>> _buildRows(List<StudentUser> page) {
    return page.map((a) => [
      Text('${a.id}', style: const TextStyle(fontSize: 14, color: AppColors.gray900)),
      Text(
        a.name.isEmpty ? '—' : a.name,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.gray900),
      ),
      Text(a.email, style: const TextStyle(fontSize: 14, color: AppColors.gray700)),
      StudentRoleBadge(role: a.role),
      StudentLastLoginCell(lastLogin: a.lastLogin),
      StudentActionMenu(student: a, onRefresh: _load, service: _service),
    ] as List<Widget>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AppCard(
        children: [
          AppCardHeader(
            title: const AppCardTitle(text: 'Студенти'),
            description: const AppCardDescription(text: 'Керування обліковими записами студентів'),
          ),
          AppCardContent(
            child: SizedBox(
              width: 320,
              child: StudentSearchField(
                controller: _searchController,
                onChanged: (val) => setState(() { _search = val; _currentPage = 1; }),
              ),
            ),
          ),
          AppCardContent(
            isLast: true,
            child: _error != null
                ? StudentErrorBody(error: _error!, onRetry: _load)
                : AppTable(
                    columns: _kColumns,
                    rows: _isLoading ? [] : _buildRows(_paginated),
                    totalCount: _filtered.length,
                    currentPage: _currentPage,
                    itemsPerPage: _itemsPerPage,
                    isLoading: _isLoading,
                    emptyText: 'Студентів не знайдено',
                    onPageChange: (p) => setState(() => _currentPage = p),
                  ),
          ),
        ],
      ),
    );
  }
}

