import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/students/students_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_card.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/components/app_table.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';



const _kColumns = [
  AppTableColumn(label: 'ID', width: FlexColumnWidth(0.6)),
  AppTableColumn(label: 'Name', width: FlexColumnWidth(2.0)),
  AppTableColumn(label: 'Email', width: FlexColumnWidth(2.5)),
  AppTableColumn(label: 'Role', width: FlexColumnWidth(1.0), center: true),
  AppTableColumn(
    label: 'Last Login',
    width: FlexColumnWidth(2.0),
    center: true,
  ),
  AppTableColumn(label: 'Actions', width: FlexColumnWidth(0.8), right: true),
];

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _AdminsScreenState();
}

class _AdminsScreenState extends State<StudentsScreen> {
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
        .where(
          (a) =>
      a.name.toLowerCase().contains(q) ||
          a.email.toLowerCase().contains(q),
    )
        .toList();
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
      final data = await _service.getStudents();
      setState(() => _students = data);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<StudentUser> get _paginated {
    final all = _filtered;
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, all.length);
    return all.sublist(start, end);
  }

  List<List<Widget>> _buildRows(List<StudentUser> page) {
    return page
        .map(
          (a) =>
      [
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
        _RoleBadge(role: a.role),
        _LastLoginCell(lastLogin: a.lastLogin),
        _AdminActionsMenu(admin: a, onRefresh: _load),
      ]
      as List<Widget>,
    )
        .toList();
  }

  void _showCreateAdminDialog(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String? apiError;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Form(
          key: formKey,
          child: AppDialog(
            title: 'Create Student',
            description: 'Enter the email address of the new student.',
            confirmLabel: 'Create Student',
            confirmIcon: LucideIcons.circleCheck,
            isLoading: isLoading,
            onConfirm: () async {
              if (!(formKey.currentState?.validate() ?? false)) return;
              setDialogState(() {
                isLoading = true;
                apiError = null;
              });
              try {
                await _service.createStudent(emailController.text.trim());
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                  _load();
                }
              } catch (e) {
                setDialogState(() {
                  apiError = e.toString().replaceFirst('Exception: ', '');
                  isLoading = false;
                });
              }
            },
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppDialogField(
                  label: 'Email',
                  controller: emailController,
                  hintText: 'student@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(val.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                if (apiError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    apiError!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.red600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(() => emailController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AppCard(
        children: [
          AppCardHeader(
            title: const AppCardTitle(text: 'Students'),
            description: const AppCardDescription(
              text: 'Manage student accounts',
            ),
          ),
          AppCardContent(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 320,
                  child: _SearchField(
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
                    onPressed: () => _showCreateAdminDialog(context),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.userRoundPlus, size: 20,
                          color: AppColors.gray900,
                        ),
                        SizedBox(width: 6),
                        Text('Create Student'),
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
                ? _ErrorBody(error: _error!, onRetry: _load)
                : AppTable(
              columns: _kColumns,
              rows: _isLoading ? [] : _buildRows(_paginated),
              totalCount: _filtered.length,
              currentPage: _currentPage,
              itemsPerPage: _itemsPerPage,
              isLoading: _isLoading,
              emptyText: 'No students found',
              onPageChange: (p) => setState(() => _currentPage = p),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.roleBadgeBg,
        border: Border.all(color: AppColors.roleBadgeBorder),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        role,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.roleBadgeText,
        ),
      ),
    );
  }
}

class _LastLoginCell extends StatelessWidget {
  const _LastLoginCell({required this.lastLogin});

  final String? lastLogin;

  String get _formatted {
    if (lastLogin == null) return 'Never';
    try {
      final dt = DateTime.parse(lastLogin!).toLocal();
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-'
          '${dt.day.toString().padLeft(2, '0')}  '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return lastLogin!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNever = lastLogin == null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isNever ? LucideIcons.circleMinus : LucideIcons.clock,
          size: 14,
          color: isNever ? AppColors.gray400 : AppColors.green700,
        ),
        const SizedBox(width: 5),
        Text(
          _formatted,
          style: TextStyle(
            fontSize: 13,
            color: isNever ? AppColors.gray400 : AppColors.gray700,
          ),
        ),
      ],
    );
  }
}

class _AdminActionsMenu extends StatelessWidget {
  const _AdminActionsMenu({required this.admin, required this.onRefresh});

  final StudentUser admin;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_Action>(
      icon: const Icon(
        LucideIcons.ellipsisVertical,
        size: 16,
        color: AppColors.gray700,
      ),
      iconSize: 16,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.gray200),
      ),
      elevation: 4,
      onSelected: (action) => _onAction(context, action),
      itemBuilder:
          (_) => const [
        PopupMenuItem(
          value: _Action.view,
          child: _MenuItem(icon: LucideIcons.eye, label: 'View Details'),
        ),
        PopupMenuItem(
          value: _Action.edit,
          child: _MenuItem(icon: LucideIcons.pencil, label: 'Edit Teacher'),
        ),
        PopupMenuItem(
          value: _Action.delete,
          child: _MenuItem(
            icon: LucideIcons.trash2,
            label: 'Delete',
            color: AppColors.red600,
          ),
        ),
      ],
    );
  }

  void _onAction(BuildContext context, _Action action) {
    final msg = switch (action) {
      _Action.view => 'View: ${admin.email}',
      _Action.edit => 'Edit: ${admin.email}',
      _Action.delete => 'Delete: ${admin.email}',
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }
}

enum _Action { view, edit, delete }

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.color = AppColors.gray900,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 14, color: color)),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: AppColors.gray900),
          decoration: InputDecoration(
            hintText: 'Search by name or ID...',
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.gray400),
            contentPadding: const EdgeInsets.only(
              left: 40,
              right: 12,
              top: 10,
              bottom: 10,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: AppColors.inputFocusBorder,
                width: 1.5,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(LucideIcons.search, size: 16, color: AppColors.gray400),
        ),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.circleAlert, size: 32, color: AppColors.red600),
          const SizedBox(height: 12),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.red600),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(LucideIcons.refreshCw, size: 15),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

