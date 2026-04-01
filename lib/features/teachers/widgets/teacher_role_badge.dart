import 'package:flutter/material.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';

class TeacherRoleBadge extends StatelessWidget {
  const TeacherRoleBadge({super.key, required this.role});

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

