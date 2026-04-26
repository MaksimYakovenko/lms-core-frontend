import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/subjects/dialogs/create_subject_dialog.dart';
import 'package:lms_core_frontend/features/subjects/subjects_service.dart';
import 'package:lms_core_frontend/common/components/app_card.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_table.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/features/subjects/widgets/subject_action_menu.dart';
import 'package:lms_core_frontend/features/subjects/widgets/subject_search_field.dart';
import 'package:lms_core_frontend/features/subjects/widgets/subjects_error_body.dart';

const _kColumns = [
  AppTableColumn(label: 'ID', width: FlexColumnWidth(0.6)),
  AppTableColumn(label: 'Назва', width: FlexColumnWidth(4.0)),
  AppTableColumn(label: 'Дії', width: FlexColumnWidth(0.8), center: true),
];

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  static const _itemsPerPage = 8;

  final _service = SubjectsService();

  List<Subject> _subjects = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  String _search = '';
  final _searchController = TextEditingController();

  List<Subject> get _filtered {
    if (_search.isEmpty) return _subjects;
    final q = _search.toLowerCase();
    return _subjects.where((s) => s.name.toLowerCase().contains(q)).toList();
  }

  List<Subject> get _paginated {
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
      final data = await _service.getSubjects();
      setState(() => _subjects = data);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<List<Widget>> _buildRows(List<Subject> page) {
    return page.map((s) => [
      Text('${s.id}', style: const TextStyle(fontSize: 14, color: AppColors.gray900)),
      Text(
        s.name.isEmpty ? '—' : s.name,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.gray900),
      ),
      SubjectActionMenu(subject: s, onRefresh: _load, service: _service),
    ] as List<Widget>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AppCard(
        children: [
          AppCardHeader(
            title: const AppCardTitle(text: 'Предмети'),
            description: const AppCardDescription(text: 'Керування навчальними предметами'),
          ),
          AppCardContent(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 320,
                  child: SubjectSearchField(
                    controller: _searchController,
                    onChanged: (val) => setState(() { _search = val; _currentPage = 1; }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: AppButton(
                    variant: ButtonVariant.outline,
                    size: ButtonSize.lg,
                    onPressed: () => showCreateSubjectDialog(
                      context,
                      service: _service,
                      onRefresh: _load,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.bookOpen, size: 20, color: AppColors.gray900),
                        SizedBox(width: 6),
                        Text('Створити предмет'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppCardContent(
            isLast: true,
            child: _error != null
                ? SubjectsErrorBody(error: _error!, onRetry: _load)
                : AppTable(
              columns: _kColumns,
              rows: _isLoading ? [] : _buildRows(_paginated),
              totalCount: _filtered.length,
              currentPage: _currentPage,
              itemsPerPage: _itemsPerPage,
              isLoading: _isLoading,
              emptyText: 'Предметів не знайдено',
              onPageChange: (p) => setState(() => _currentPage = p),
            ),
          ),
        ],
      ),
    );
  }
}
