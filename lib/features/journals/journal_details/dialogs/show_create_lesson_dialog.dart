import 'package:flutter/material.dart';
import 'package:lms_core_frontend/features/journals/journals/journals_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_dialog.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/groups/groups_service.dart';

import '../../../subjects/subjects_service.dart';
import '../../../teachers/teachers_service.dart';

Future<void> createJournalDialog(
    BuildContext context, {
      required JournalsService service,
      required VoidCallback onRefresh,
    }) {
  return showDialog(
    context: context,
    builder:
        (_) => _CreateJournalDialog(
      service: service,
      onRefresh: onRefresh,
    ),
  );
}

class _CreateJournalDialog extends StatefulWidget {
  const _CreateJournalDialog({
    required this.service,
    required this.onRefresh,
  });

  final JournalsService service;
  final VoidCallback onRefresh;

  @override
  State<_CreateJournalDialog> createState() => _CreateJournalDialogState();
}

class _CreateJournalDialogState extends State<_CreateJournalDialog> {
  final _groupsService = GroupsService();
  final _teachersService = TeachersService();
  final _subjectsService = SubjectsService();

  List<Group> _groups = [];
  List<TeacherUser> _teachers = [];
  List<Subject> _subjects = [];
  Group? _selectedGroup;
  TeacherUser? _selectedTeacher;
  TeacherUser? _selectedAssistant;
  Subject? _selectedSubject;

  bool _isLoadingGroups = true;
  bool _isLoadingTeachers = true;
  bool _isLoadingSubjects = true;
  bool _isSubmitting = false;
  String? _loadError;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _loadLessonTypes();
    _loadTeachers();
    _loadSubjects();
  }

  Future<void> _loadLessonTypes() async {
    try {
      final groups = await _groupsService.getGroups();
      if (mounted) {
        setState(() {
          _groups = groups;
          _isLoadingGroups = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadError = e.toString().replaceFirst('Exception: ', '');
          _isLoadingGroups = false;
        });
      }
    }
  }

  Future<void> _loadTeachers() async {
    try {
      final teachers = await _teachersService.getTeachers();
      if (mounted) {
        setState(() {
          _teachers = teachers;
          _isLoadingTeachers = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadError = e.toString().replaceFirst('Exception: ', '');
          _isLoadingTeachers = false;
        });
      }
    }
  }

  Future<void> _loadSubjects() async {
    try {
      final subjects = await _subjectsService.getSubjects();
      if (mounted) {
        setState(() {
          _subjects = subjects;
          _isLoadingSubjects = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadError = e.toString().replaceFirst('Exception: ', '');
          _isLoadingSubjects = false;
        });
      }
    }
  }

  bool get _canSubmit =>
      _selectedGroup != null &&
          _selectedTeacher != null &&
          _selectedSubject != null;

  Future<void> _submit() async {
    if (!_canSubmit) return;

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      await widget.service.createJournalWithAssignment(
        groupId: _selectedGroup!.id,
        subjectId: _selectedSubject!.id,
        teacherId: _selectedTeacher!.id,
        assistantId: _selectedAssistant?.id,
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

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
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
        borderSide: const BorderSide(color: AppColors.inputFocusBorder, width: 1.5),
      ),
    );
  }

  Widget _loadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }

  Widget _errorText() {
    return Text(_loadError!, style: const TextStyle(fontSize: 13, color: AppColors.red600));
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Створити журнал',
      description: 'Введіть дані нового журналу',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Group ---
          const Text('Група', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gray900, height: 1.0)),
          const SizedBox(height: 6),
          if (_isLoadingGroups)
            _loadingIndicator()
          else if (_loadError != null)
            _errorText()
          else
            DropdownButtonFormField<Group>(
              value: _selectedGroup,
              hint: const Text('Оберіть групу...', style: TextStyle(fontSize: 14, color: AppColors.gray400)),
              decoration: _dropdownDecoration(),
              style: const TextStyle(fontSize: 14, color: AppColors.gray900),
              items: _groups.map((g) => DropdownMenuItem(value: g, child: Text('${g.name} (курс ${g.courseNumber})'))).toList(),
              onChanged: (g) => setState(() => _selectedGroup = g),
            ),
          const SizedBox(height: 12),

          const Text('Предмет', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gray900, height: 1.0)),
          const SizedBox(height: 6),
          if (_isLoadingSubjects)
            _loadingIndicator()
          else if (_loadError != null)
            _errorText()
          else
            DropdownButtonFormField<Subject>(
              value: _selectedSubject,
              hint: const Text('Оберіть предмет...', style: TextStyle(fontSize: 14, color: AppColors.gray400)),
              decoration: _dropdownDecoration(),
              style: const TextStyle(fontSize: 14, color: AppColors.gray900),
              items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
              onChanged: (s) => setState(() => _selectedSubject = s),
            ),
          const SizedBox(height: 12),

          const Text('Викладач', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gray900, height: 1.0)),
          const SizedBox(height: 6),
          if (_isLoadingTeachers)
            _loadingIndicator()
          else if (_loadError != null)
            _errorText()
          else
            DropdownButtonFormField<TeacherUser>(
              value: _selectedTeacher,
              hint: const Text('Оберіть викладача...', style: TextStyle(fontSize: 14, color: AppColors.gray400)),
              decoration: _dropdownDecoration(),
              style: const TextStyle(fontSize: 14, color: AppColors.gray900),
              items: _teachers.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
              onChanged: (t) => setState(() => _selectedTeacher = t),
            ),
          const SizedBox(height: 12),

          const Text('Асистент викладача', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gray900, height: 1.0)),
          const SizedBox(height: 6),
          if (_isLoadingTeachers)
            _loadingIndicator()
          else if (_loadError != null)
            _errorText()
          else
            DropdownButtonFormField<TeacherUser>(
              value: _selectedAssistant,
              hint: const Text('Оберіть асистента...', style: TextStyle(fontSize: 14, color: AppColors.gray400)),
              decoration: _dropdownDecoration(),
              style: const TextStyle(fontSize: 14, color: AppColors.gray900),
              items: _teachers.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
              onChanged: (t) => setState(() => _selectedAssistant = t),
            ),

          if (_submitError != null) ...[
            const SizedBox(height: 10),
            Text(_submitError!, style: const TextStyle(fontSize: 13, color: AppColors.red600)),
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
          variant: ButtonVariant.primary,
          size: ButtonSize.lg,
          isLoading: _isSubmitting,
          onPressed: (_isSubmitting || !_canSubmit) ? null : _submit,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.notebookPen, size: 15),
              SizedBox(width: 6),
              Text('Створити'),
            ],
          ),
        ),
      ],
    );
  }
}
