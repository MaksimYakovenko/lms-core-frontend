import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/admins/utils/admins_formatters.dart';

class AdminLastLoginCell extends StatelessWidget {
  const AdminLastLoginCell({super.key, required this.lastLogin});

  final String? lastLogin;

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
          formatAdminLastLogin(lastLogin),
          style: TextStyle(
            fontSize: 13,
            color: isNever ? AppColors.gray400 : AppColors.gray700,
          ),
        ),
      ],
    );
  }
}

