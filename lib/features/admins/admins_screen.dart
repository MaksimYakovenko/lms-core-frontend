import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/admins/admins_service.dart';
import 'package:lms_core_frontend/common/components/app_card.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_table.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/admins/widgets/admin_status_badge.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/features/admins/widgets/admin_role_badge.dart';
import 'package:lms_core_frontend/features/admins/widgets/admin_last_login_cell.dart';
import 'package:lms_core_frontend/features/admins/widgets/admin_action_menu.dart';
import 'package:lms_core_frontend/features/admins/widgets/admin_search_field.dart';
import 'package:lms_core_frontend/features/admins/widgets/admin_error_body.dart';
import 'package:lms_core_frontend/features/admins/dialogs/create_admin_dialog.dart';

const _kColumns = [
  AppTableColumn(label: 'ID', width: FlexColumnWidth(0.6)),
  AppTableColumn(label: 'Ім\'я', width: FlexColumnWidth(2.0)),
  AppTableColumn(label: 'Пошта', width: FlexColumnWidth(2.5)),
  AppTableColumn(label: 'Роль', width: FlexColumnWidth(1.0), center: true),
  AppTableColumn(label: 'Статус', width: FlexColumnWidth(1.2), center: true),
  AppTableColumn(
    label: 'Останній вхід',
    width: FlexColumnWidth(2.0),
    center: true,
  ),
  AppTableColumn(label: 'Дії', width: FlexColumnWidth(0.8), right: true),
];

class AdminsScreen extends StatefulWidget {
  const AdminsScreen({super.key});

  @override
  State<AdminsScreen> createState() => _AdminsScreenState();
}

class _AdminsScreenState extends State<AdminsScreen> {
  static const _itemsPerPage = 8;

  final _service = AdminsService();

  List<AdminUser> _admins = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  String _search = '';
  final _searchController = TextEditingController();

  List<AdminUser> get _filtered {
    if (_search.isEmpty) return _admins;
    final q = _search.toLowerCase();
    return _admins
        .where(
          (a) =>
              a.name.toLowerCase().contains(q) ||
              a.email.toLowerCase().contains(q),
        )
        .toList();
  }

  List<AdminUser> get _paginated {
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
      final data = await _service.getAdmins();
      setState(() => _admins = data);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<List<Widget>> _buildRows(List<AdminUser> page) {
    return page
        .map(
          (a) =>
              [
                    Text(
                      '${a.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray900,
                      ),
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
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray700,
                      ),
                    ),
                    AdminRoleBadge(role: a.role),
                    AdminStatusBadge(status: AdminStatus.fromString(a.status)),
                    AdminLastLoginCell(lastLogin: a.lastLogin),
                    AdminActionMenu(
                      admin: a,
                      onRefresh: _load,
                      service: _service,
                    ),
                  ]
                  as List<Widget>,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AppCard(
        children: [
          AppCardHeader(
            title: const AppCardTitle(text: 'Адміністратори'),
            description: const AppCardDescription(
              text: 'Керування адміністраторами системи',
            ),
          ),
          AppCardContent(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 320,
                  child: AdminSearchField(
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
                        () => showCreateAdminDialog(
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
                        Text('Створити адміністратора'),
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
                    ? AdminErrorBody(error: _error!, onRetry: _load)
                    : AppTable(
                      columns: _kColumns,
                      rows: _isLoading ? [] : _buildRows(_paginated),
                      totalCount: _filtered.length,
                      currentPage: _currentPage,
                      itemsPerPage: _itemsPerPage,
                      isLoading: _isLoading,
                      emptyText: 'Адміністраторів не знайдено',
                      onPageChange: (p) => setState(() => _currentPage = p),
                    ),
          ),
        ],
      ),
    );
  }
}
