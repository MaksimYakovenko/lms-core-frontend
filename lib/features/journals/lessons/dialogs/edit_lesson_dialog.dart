import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/classrooms/classrooms_service.dart';
import 'package:lms_core_frontend/features/journals/lessons/lessons_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';

import '../../journal_details/journal_details_service.dart';
import 'delete_lesson_dialog.dart';

Future<void> showEditLessonDialog(
  BuildContext context, {
  required int journalId,
  required int lessonId,
  required VoidCallback onRefresh,
  String? initialLessonType,
  DateTime? initialDate,
  int? initialLessonNumber,
  String? initialTitle,
  String? initialDescription,
  int? initialClassroomId,
}) {
  return showDialog(
    context: context,
    builder:
        (_) => _EditLessonDialog(
          journalId: journalId,
          lessonId: lessonId,
          onRefresh: onRefresh,
          initialLessonType: initialLessonType,
          initialDate: initialDate,
          initialLessonNumber: initialLessonNumber,
          initialTitle: initialTitle,
          initialDescription: initialDescription,
          initialClassroomId: initialClassroomId,
        ),
  );
}

class _EditLessonDialog extends StatefulWidget {
  const _EditLessonDialog({
    required this.journalId,
    required this.lessonId,
    required this.onRefresh,
    this.initialLessonType,
    this.initialDate,
    this.initialLessonNumber,
    this.initialTitle,
    this.initialDescription,
    this.initialClassroomId,
  });

  final int journalId;
  final int lessonId;
  final VoidCallback onRefresh;
  final String? initialLessonType;
  final DateTime? initialDate;
  final int? initialLessonNumber;
  final String? initialTitle;
  final String? initialDescription;
  final int? initialClassroomId;

  @override
  State<_EditLessonDialog> createState() => _CreateLessonDialogState();
}

class _CreateLessonDialogState extends State<_EditLessonDialog> {
  final _service = LessonsService();
  final _classroomsService = ClassroomsService();
  late final JournalDetails journal;

  List<LessonType> _lessonTypes = [];
  List<LessonPeriod> _lessonPeriods = [];
  List<Classroom> _classrooms = [];

  LessonType? _selectedLessonType;
  LessonPeriod? _selectedPeriod;
  Classroom? _selectedClassroom;
  DateTime _selectedDate = DateTime.now();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  bool _isLoadingTypes = true;
  bool _isLoadingPeriods = true;
  bool _isLoadingClassrooms = true;
  bool _isSubmitting = false;
  String? _loadError;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate!;
    }
    _loadLessonTypes();
    _loadLessonPeriods();
    _loadClassrooms();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadLessonTypes() async {
    try {
      final types = await _service.getLessonTypes();
      if (mounted) {
        setState(() {
          _lessonTypes = types;
          _isLoadingTypes = false;
          if (widget.initialLessonType != null) {
            _selectedLessonType = _lessonTypes.where((t) => t.value == widget.initialLessonType).firstOrNull;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadError = e.toString().replaceFirst('Exception: ', '');
          _isLoadingTypes = false;
        });
      }
    }
  }

  Future<void> _loadLessonPeriods() async {
    try {
      final periods = await _service.getLessonPeriods();
      if (mounted) {
        setState(() {
          _lessonPeriods = periods;
          _isLoadingPeriods = false;
          if (widget.initialLessonNumber != null) {
            _selectedPeriod = _lessonPeriods.where((p) => p.number == widget.initialLessonNumber).firstOrNull;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadError = e.toString().replaceFirst('Exception: ', '');
          _isLoadingPeriods = false;
        });
      }
    }
  }

  Future<void> _loadClassrooms() async {
    try {
      final classrooms = await _classroomsService.getClassrooms();
      if (mounted) {
        setState(() {
          _classrooms = classrooms;
          _isLoadingClassrooms = false;
          if (widget.initialClassroomId != null) {
            _selectedClassroom = _classrooms.where((c) => c.id == widget.initialClassroomId).firstOrNull;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadError = e.toString().replaceFirst('Exception: ', '');
          _isLoadingClassrooms = false;
        });
      }
    }
  }

  bool get _canSubmit => _selectedLessonType != null && _selectedPeriod != null;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      await _service.editLesson(
        journalId: widget.journalId,
        lessonType: _selectedLessonType!.value,
        date: _selectedDate,
        classroomId: _selectedClassroom?.id,
        lessonNumber: _selectedPeriod?.number,
        lessonId: widget.lessonId,
        title: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop();
        widget.onRefresh();
      }
    } catch (e) {
      setState(
        () => _submitError = e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _dropdownDecoration() => InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
  );

  Widget _loadingIndicator() => const Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Редагувати пару',
      description: 'Внесіть зміни до пари та натисніть "Редагувати" для збереження.',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_loadError != null) ...[
            Text(
              _loadError!,
              style: const TextStyle(fontSize: 13, color: AppColors.red600),
            ),
            const SizedBox(height: 12),
          ],

          // Row 1: Тип пари | Номер пари
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Тип пари',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gray900, height: 1.0),
                    ),
                    const SizedBox(height: 6),
                    if (_isLoadingTypes)
                      _loadingIndicator()
                    else
                      DropdownButtonFormField<LessonType>(
                        value: _selectedLessonType,
                        hint: const Text('Оберіть...', style: TextStyle(fontSize: 14, color: AppColors.gray400)),
                        decoration: _dropdownDecoration(),
                        style: const TextStyle(fontSize: 14, color: AppColors.gray900),
                        isExpanded: true,
                        items: _lessonTypes.map((t) => DropdownMenuItem(value: t, child: Text(t.label))).toList(),
                        onChanged: (t) => setState(() => _selectedLessonType = t),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Номер пари',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gray900, height: 1.0),
                    ),
                    const SizedBox(height: 6),
                    if (_isLoadingPeriods)
                      _loadingIndicator()
                    else
                      DropdownButtonFormField<LessonPeriod>(
                        value: _selectedPeriod,
                        hint: const Text('Оберіть...', style: TextStyle(fontSize: 14, color: AppColors.gray400)),
                        decoration: _dropdownDecoration(),
                        style: const TextStyle(fontSize: 14, color: AppColors.gray900),
                        isExpanded: true,
                        items: _lessonPeriods
                            .map((p) => DropdownMenuItem(value: p, child: Text('${p.label} (${p.startTime}–${p.endTime})')))
                            .toList(),
                        onChanged: (p) => setState(() => _selectedPeriod = p),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Row 2: Дата | Аудиторія
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Дата',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gray900, height: 1.0),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          builder: (context, child) => Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.accent,
                                onPrimary: Colors.white,
                                onSurface: AppColors.gray900,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) setState(() => _selectedDate = picked);
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: IgnorePointer(
                        child: TextFormField(
                          enabled: false,
                          decoration: _dropdownDecoration().copyWith(
                            prefixIcon: const Icon(LucideIcons.calendar, size: 16, color: AppColors.gray400),
                            prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: AppColors.gray200),
                            ),
                          ),
                          controller: TextEditingController(
                            text: '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                          ),
                          style: const TextStyle(fontSize: 14, color: AppColors.gray900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Аудиторія',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gray900, height: 1.0),
                    ),
                    const SizedBox(height: 6),
                    if (_isLoadingClassrooms)
                      _loadingIndicator()
                    else
                      DropdownButtonFormField<Classroom>(
                        value: _selectedClassroom,
                        hint: const Text('Оберіть...', style: TextStyle(fontSize: 14, color: AppColors.gray400)),
                        decoration: _dropdownDecoration(),
                        style: const TextStyle(fontSize: 14, color: AppColors.gray900),
                        isExpanded: true,
                        items: _classrooms.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                        onChanged: (c) => setState(() => _selectedClassroom = c),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Row 3: Тема пари
          const Text(
            'Тема пари',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gray900, height: 1.0),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _titleController,
            decoration: _dropdownDecoration().copyWith(
              hintText: 'Введіть тему пари...',
              hintStyle: const TextStyle(fontSize: 14, color: AppColors.gray400),
            ),
            style: const TextStyle(fontSize: 14, color: AppColors.gray900),
          ),

          const SizedBox(height: 12),

          // Row 4: Опис пари
          const Text(
            'Опис пари',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gray900, height: 1.0),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration: _dropdownDecoration().copyWith(
              hintText: 'Введіть опис пари...',
              hintStyle: const TextStyle(fontSize: 14, color: AppColors.gray400),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            style: const TextStyle(fontSize: 14, color: AppColors.gray900),
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
      actions: [
        AppButton(
          variant: ButtonVariant.outline,
          size: ButtonSize.lg,
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        const SizedBox(width: 8),
        AppButton(
          variant: ButtonVariant.destructive,
          size: ButtonSize.lg,
          isLoading: _isSubmitting,
          onPressed: () => showDeleteLessonDialog(
            context,
            journalId: widget.journalId,
            lessonId: widget.lessonId,
            service: _service,
            onRefresh: widget.onRefresh,
            onDeleted: () => Navigator.of(context).pop(),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.trash2, size: 15),
              SizedBox(width: 6),
              Text('Видалити'),
            ],
          ),
        ),
        const SizedBox(width: 8),
        AppButton(
          variant: ButtonVariant.primary,
          size: ButtonSize.lg,
          isLoading: _isSubmitting,
          onPressed: (_isSubmitting || !_canSubmit) ? null : _submit,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.pencil, size: 15),
              SizedBox(width: 6),
              Text('Редагувати'),
            ],
          ),
        ),
      ],
    );
  }
}
