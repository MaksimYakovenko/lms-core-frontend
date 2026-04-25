import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';


class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.description,
    required this.content,
    this.actions,
    this.onConfirm,
    this.confirmLabel = 'Confirm',
    this.confirmIcon,
    this.isLoading = false,
    this.width = 480,
  });

  final String title;
  final String? description;
  final Widget content;
  final List<Widget>? actions;
  final VoidCallback? onConfirm;
  final String confirmLabel;
  final IconData? confirmIcon;
  final bool isLoading;
  final double width;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? description,
    required Widget content,
    List<Widget>? actions,
    VoidCallback? onConfirm,
    String confirmLabel = 'Підтвердити',
    IconData? confirmIcon,
    bool isLoading = false,
    double width = 480,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => AppDialog(
        title: title,
        description: description,
        content: content,
        actions: actions,
        onConfirm: onConfirm,
        confirmLabel: confirmLabel,
        confirmIcon: confirmIcon,
        isLoading: isLoading,
        width: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── DialogHeader ─────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray900,
                          height: 1.2,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          description!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.gray400,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Close ✕
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.transparent,
                    ),
                    child: const Icon(LucideIcons.x, size: 16, color: AppColors.gray700),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── DialogContent ────────────────────────────────────────────────
            content,

            const SizedBox(height: 24),

            // ── Separator ────────────────────────────────────────────────────
            const Divider(height: 1, color: AppColors.gray200),
            const SizedBox(height: 16),

            // ── DialogFooter ─────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions ??
                  [
                    AppButton(
                      variant: ButtonVariant.outline,
                      size: ButtonSize.lg,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Скасувати'),
                    ),
                    const SizedBox(width: 8),
                    AppButton(
                      variant: ButtonVariant.primary,
                      size: ButtonSize.lg,
                      isLoading: isLoading,
                      onPressed: onConfirm,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (confirmIcon != null) ...[
                            Icon(confirmIcon, size: 15),
                            const SizedBox(width: 6),
                          ],
                          Text(confirmLabel),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── AppDialogField ────────────────────────────────────────────────────────────

class AppDialogField extends StatelessWidget {
  const AppDialogField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray900,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: const TextStyle(fontSize: 14, color: AppColors.gray900),
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.gray400),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.red600),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.red600, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

