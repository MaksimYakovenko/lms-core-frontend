import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/groups/groups_service.dart';
import 'package:lms_core_frontend/common/components/app_card.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_table.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/features/groups/widgets/group_search_field.dart';
import 'package:lms_core_frontend/features/groups/widgets/group_error_body.dart';
import 'package:lms_core_frontend/features/groups/widgets/group_action_menu.dart';
import 'package:lms_core_frontend/features/groups/dialogs/create_group_dialog.dart';

const _kColumns = [
  AppTableColumn(label: 'ID', width: FlexColumnWidth(0.6)),
  AppTableColumn(label: 'Назва', width: FlexColumnWidth(4.0)),
  AppTableColumn(label: 'Курс', width: FlexColumnWidth(10.8), center: true),
  AppTableColumn(label: 'Дії', width: FlexColumnWidth(0.8), center: true),
];

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  static const _itemsPerPage = 8;

  final _service = GroupsService();

  List<Group> _groups = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  String _search = '';
  final _searchController = TextEditingController();

  List<Group> get _filtered {
    if (_search.isEmpty) return _groups;
    final q = _search.toLowerCase();
    return _groups
        .where((g) =>
            g.name.toLowerCase().contains(q) ||
            g.id.toString().contains(q))
        .toList();
  }

  List<Group> get _paginated {
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
      final data = await _service.getGroups();
      setState(() => _groups = data);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<List<Widget>> _buildRows(List<Group> page) {
    return page.map((g) => [
      Text('${g.id}', style: const TextStyle(fontSize: 14, color: AppColors.gray900)),
      Text(
        g.name.isEmpty ? '—' : g.name,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.gray900),
      ),
      Text('${g.courseNumber}', style: const TextStyle(fontSize: 14, color: AppColors.gray700)),
      GroupActionMenu(group: g, onRefresh: _load, service: _service),
    ] as List<Widget>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AppCard(
        children: [
          AppCardHeader(
            title: const AppCardTitle(text: 'Групи'),
            description: const AppCardDescription(text: 'Керування навчальними групами'),
          ),
          AppCardContent(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 320,
                  child: GroupSearchField(
                    controller: _searchController,
                    onChanged: (val) => setState(() { _search = val; _currentPage = 1; }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: AppButton(
                    variant: ButtonVariant.outline,
                    size: ButtonSize.lg,
                    onPressed: () => showCreateGroupDialog(context, service: _service, onRefresh: _load),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.folderPlus, size: 20, color: AppColors.gray900),
                        SizedBox(width: 6),
                        Text('Створити групу'),
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
                ? GroupErrorBody(error: _error!, onRetry: _load)
                : AppTable(
                    columns: _kColumns,
                    rows: _isLoading ? [] : _buildRows(_paginated),
                    totalCount: _filtered.length,
                    currentPage: _currentPage,
                    itemsPerPage: _itemsPerPage,
                    isLoading: _isLoading,
                    emptyText: 'Груп не знайдено',
                    onPageChange: (p) => setState(() => _currentPage = p),
                  ),
          ),
        ],
      ),
    );
  }
}
