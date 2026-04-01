import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/admins/admins_service.dart';

Future<void> showDeleteAdminDialog(
  BuildContext context, {
  required AdminUser admin,
  required AdminsService service,
  required VoidCallback onRefresh,
}) {
  return showDialog(
    context: context,
    builder: (_) => _DeleteAdminDialog(admin: admin, service: service, onRefresh: onRefresh),
  );
}

class _DeleteAdminDialog extends StatefulWidget {
  const _DeleteAdminDialog({
    required this.admin,
    required this.service,
    required this.onRefresh,
  });

  final AdminUser admin;
  final AdminsService service;
  final VoidCallback onRefresh;

  @override
  State<_DeleteAdminDialog> createState() => _DeleteAdminDialogState();
}

class _DeleteAdminDialogState extends State<_DeleteAdminDialog> {
  bool _isLoading = false;
  String? _error;

  Future<void> _confirm() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await widget.service.deleteAdmin(widget.admin.id);
      if (mounted) {
        Navigator.of(context).pop();
        widget.onRefresh();
      }
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Видалити адміністратора',
      description: 'Цю дію неможливо скасувати',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: AppColors.gray700, height: 1.5),
              children: [
                const TextSpan(text: 'Ви впевнені, що хочете видалити адміністратора '),
                TextSpan(
                  text: widget.admin.name.isNotEmpty ? widget.admin.name : widget.admin.email,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.gray900),
                ),
                const TextSpan(text: '?'),
              ],
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: const TextStyle(fontSize: 13, color: AppColors.red600),
            ),
          ],
        ],
      ),
      actions: [
        AppButton(
          variant: ButtonVariant.outline,
          size: ButtonSize.lg,
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        const SizedBox(width: 8),
        AppButton(
          variant: ButtonVariant.destructive,
          size: ButtonSize.lg,
          isLoading: _isLoading,
          onPressed: _isLoading ? null : _confirm,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.trash2, size: 15),
              SizedBox(width: 6),
              Text('Видалити'),
            ],
          ),
        ),
      ],
    );
  }
}

