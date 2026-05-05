import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../common/components/app_button.dart';
import '../../../../common/components/app_input.dart';
import '../../../../common/components/app_label.dart';
import '../../../../common/components/app_toast_component.dart';
import '../../../../common/constants/colors.dart';
import '../journal_details_service.dart';

Future<void> showSetGradeDialog(
  BuildContext context, {
  required int journalId,
  required int lessonId,
  required int studentId,
  required String studentName,
  required String lessonLabel,
  required JournalDetailsService service,
  required VoidCallback onRefresh,
  String? currentValue,
  int? gradeId,
}) {
  return showDialog(
    context: context,
    builder: (_) => _SetGradeDialog(
      journalId: journalId,
      lessonId: lessonId,
      studentId: studentId,
      studentName: studentName,
      lessonLabel: lessonLabel,
      service: service,
      onRefresh: onRefresh,
      currentValue: currentValue,
      gradeId: gradeId,
    ),
  );
}

class _SetGradeDialog extends StatefulWidget {
  const _SetGradeDialog({
    required this.journalId,
    required this.lessonId,
    required this.studentId,
    required this.studentName,
    required this.lessonLabel,
    required this.service,
    required this.onRefresh,
    this.currentValue,
    this.gradeId,
  });

  final int journalId;
  final int lessonId;
  final int studentId;
  final String studentName;
  final String lessonLabel;
  final JournalDetailsService service;
  final VoidCallback onRefresh;
  final String? currentValue;
  final int? gradeId;

  @override
  State<_SetGradeDialog> createState() => _SetGradeDialogState();
}

class _SetGradeDialogState extends State<_SetGradeDialog> {
  late final TextEditingController _valueCtrl;

  bool _isSubmitting = false;
  String? _submitError;
  String _valueError = '';

  @override
  void initState() {
    super.initState();
    _valueCtrl = TextEditingController(text: widget.currentValue ?? '');
  }

  @override
  void dispose() {
    _valueCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit => _valueCtrl.text.trim().isNotEmpty && !_isSubmitting;

  Future<void> _save(String value) async {
    if (value.isEmpty) {
      setState(() => _valueError = 'Введіть оцінку');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
      _valueError = '';
    });

    try {
      await widget.service.putGrade(
        widget.journalId,
        lessonId: widget.lessonId,
        studentId: widget.studentId,
        value: value,
        remark: '',
      );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onRefresh();
        AppToast.success(
          context,
          title: 'Оцінку збережено',
          description: '${widget.studentName}: $value',
        );
      }
    } catch (e) {
      setState(() {
        _submitError = e.toString().replaceFirst('Exception: ', '');
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Внесення оцінки',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.studentName} • ${widget.lessonLabel}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(LucideIcons.x, size: 18, color: AppColors.gray400),
                  splashRadius: 18,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Score input
            const AppLabel(text: 'Бал'),
            const SizedBox(height: 6),
            AppInput(
              controller: _valueCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              hintText: 'Наприклад: 5',
              errorText: _valueError.isEmpty ? null : _valueError,
              onChanged: (_) => setState(() => _valueError = ''),
            ),
            const SizedBox(height: 12),

            // Save score button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                variant: ButtonVariant.black,
                size: ButtonSize.lg,
                isLoading: _isSubmitting,
                onPressed: _canSubmit ? () => _save(_valueCtrl.text.trim()) : null,
                child: const Text('Зберегти бал'),
              ),
            ),
            const SizedBox(height: 10),

            // ХВ / Н·Б row
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    variant: ButtonVariant.outline,
                    size: ButtonSize.lg,
                    isLoading: false,
                    onPressed: _isSubmitting ? null : () => _save('ХВ'),
                    child: const Text('Хворий (ХВ)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    variant: ButtonVariant.outline,
                    size: ButtonSize.lg,
                    isLoading: false,
                    onPressed: _isSubmitting ? null : () => _save('Н/Б'),
                    child: const Text('Пропуск (Н/Б)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Clear button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                variant: ButtonVariant.ghost,
                size: ButtonSize.lg,
                isLoading: false,
                onPressed: _isSubmitting
                    ? null
                    : () async {
                        if (widget.gradeId == null) {
                          setState(() => _valueCtrl.clear());
                          return;
                        }
                        setState(() {
                          _isSubmitting = true;
                          _submitError = null;
                          _valueError = '';
                        });
                        try {
                          await widget.service.deleteGrade(
                            widget.journalId,
                            widget.gradeId!,
                          );
                          if (mounted) {
                            Navigator.of(context).pop();
                            widget.onRefresh();
                            AppToast.success(
                              context,
                              title: 'Оцінку видалено',
                              description: widget.studentName,
                            );
                          }
                        } catch (e) {
                          setState(() {
                            _submitError = e
                                .toString()
                                .replaceFirst('Exception: ', '');
                            _isSubmitting = false;
                          });
                        }
                      },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.x, size: 15),
                    SizedBox(width: 6),
                    Text('Очистити'),
                  ],
                ),
              ),
            ),

            if (_submitError != null) ...[
              const SizedBox(height: 10),
              Text(
                _submitError!,
                style: const TextStyle(fontSize: 13, color: AppColors.red600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
