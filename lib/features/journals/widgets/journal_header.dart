import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../common/constants/colors.dart';
import '../../../config/routers/view_identifiers.dart';
import '../journals_service.dart';

class JournalHeader extends StatelessWidget {
  const JournalHeader({
    super.key,
    required this.journal,
  });

  final JournalDetails journal;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.goNamed(ViewIdentifiers.journals.name),
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                LucideIcons.arrowLeft,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                children: [
                  const TextSpan(text: 'Журнал оцінок для групи '),
                  TextSpan(
                    text: journal.groupName,
                    style: const TextStyle(color: Color(0xFFEF4444)),
                  ),
                  TextSpan(text: ' [${journal.subject}]'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          _TeacherInfo(name: journal.teacherName),
        ],
      ),
    );
  }
}

class _TeacherInfo extends StatelessWidget {
  const _TeacherInfo({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFFE5E7EB),
          child: Icon(
            LucideIcons.user,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'викладач:',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          name,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFFEF4444),
          ),
        ),
      ],
    );
  }
}