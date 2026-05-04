import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/classrooms/widgets/classroom_action_menu.dart';
import 'package:lms_core_frontend/features/classrooms/widgets/classroom_error_body.dart';
import 'package:lms_core_frontend/features/classrooms/widgets/classroom_search_field.dart';
import 'package:lms_core_frontend/common/components/app_card.dart';
import 'package:lms_core_frontend/common/components/app_table.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../common/components/app_button.dart';
import 'classrooms_service.dart';
import 'dialogs/create_classroom_dialog.dart';

const _kColumns = [
  AppTableColumn(label: 'ID', width: FlexColumnWidth(0.5)),
  AppTableColumn(
    label: 'Назва аудиторії',
    width: FlexColumnWidth(1.3),
    center: true,
  ),
  AppTableColumn(label: 'Дії', width: FlexColumnWidth(0.6), right: true),
];

class ClassroomsScreen extends StatefulWidget {
  const ClassroomsScreen({super.key});

  @override
  State<ClassroomsScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomsScreen> {
  static const _itemsPerPage = 8;

  final _classroomService = ClassroomsService();

  late List<Classroom> _classrooms = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  String _search = '';
  final _searchController = TextEditingController();

  List<Classroom> get _filtered {
    if (_search.isEmpty) return _classrooms;
    final q = _search.toLowerCase();
    return _classrooms.where((a) => a.name.toLowerCase().contains(q)).toList();
  }

  List<Classroom> get _paginated {
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
      final results = await Future.wait([_classroomService.getClassrooms()]);
      final classrooms = results[0];
      setState(() {
        _classrooms = classrooms;
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<List<Widget>> _buildRows(List<Classroom> page) {
    return page
        .map<List<Widget>>(
          (a) => [
            Text(
              '${a.id}',
              style: const TextStyle(fontSize: 14, color: AppColors.gray900),
            ),
            Text(
              a.name,
              style: const TextStyle(fontSize: 14, color: AppColors.gray700),
            ),
            ClassroomActionMenu(
              classroom: a,
              onRefresh: _load,
              service: _classroomService,
            ),
          ],
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: AppCard(
          children: [
            AppCardHeader(
              title: const AppCardTitle(text: 'Аудиторії'),
              description: const AppCardDescription(
                text: 'Керування данними про аудиторії',
              ),
            ),
            AppCardContent(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 320,
                    child: ClassroomSearchField(
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
                          () => showCreateClassroomDialog(
                            context,
                            service: _classroomService,
                            onRefresh: _load,
                          ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.folderPlus,
                            size: 20,
                            color: AppColors.gray900,
                          ),
                          SizedBox(width: 6),
                          Text('Створити аудиторію'),
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
                      ? ClassroomErrorBody(error: _error!, onRetry: _load)
                      : AppTable(
                        columns: _kColumns,
                        rows: _isLoading ? [] : _buildRows(_paginated),
                        totalCount: _filtered.length,
                        currentPage: _currentPage,
                        itemsPerPage: _itemsPerPage,
                        isLoading: _isLoading,
                        emptyText: 'Аудиторії не знайдено',
                        emptyIcon: LucideIcons.building2,
                        onPageChange: (p) => setState(() => _currentPage = p),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
