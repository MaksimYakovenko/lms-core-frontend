import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';

class GroupSearchField extends StatelessWidget {
  const GroupSearchField({super.key, required this.controller, required this.onChanged});

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
            hintText: 'Пошук по назві або ID...',
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.gray400),
            contentPadding: const EdgeInsets.only(left: 40, right: 12, top: 10, bottom: 10),
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
              borderSide: const BorderSide(color: AppColors.inputFocusBorder, width: 1.5),
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

