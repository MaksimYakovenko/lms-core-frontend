import 'package:flutter/material.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';

class SubjectsErrorBody extends StatelessWidget {
  const SubjectsErrorBody({super.key, required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(error, style: const TextStyle(fontSize: 14, color: AppColors.red600)),
        const SizedBox(height: 12),
        AppButton(
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: onRetry,
          child: const Text('Спробувати ще раз'),
        ),
      ],
    );
  }
}

