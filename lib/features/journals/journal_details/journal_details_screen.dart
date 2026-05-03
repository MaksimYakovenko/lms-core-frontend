import 'package:flutter/material.dart';
import 'package:lms_core_frontend/common/components/_components.dart';
import 'package:lms_core_frontend/features/journals/journal_details/widgets/filter_dropdowns.dart';
import 'package:lms_core_frontend/features/journals/journal_details/widgets/grades_table.dart';
import 'package:lms_core_frontend/features/journals/journal_details/widgets/journal_header.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../common/constants/colors.dart';
import 'journal_details_service.dart';

class JournalDetailsScreen extends StatefulWidget {
  const JournalDetailsScreen({super.key, required this.journalId});

  final String journalId;

  @override
  State<JournalDetailsScreen> createState() => _JournalDetailsScreenState();
}

class _JournalDetailsScreenState extends State<JournalDetailsScreen> {
  final _service = JournalDetailsService();

  late final Future<JournalDetails> _future;

  @override
  void initState() {
    super.initState();

    final id = int.tryParse(widget.journalId) ?? 0;
    _future = _service.getJournalById(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JournalDetails>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snap.hasError) {
          return Center(
            child: Text(
              'Помилка: ${snap.error}',
              style: const TextStyle(color: AppColors.red600),
            ),
          );
        }

        final journal = snap.data;

        if (journal == null) {
          return const Center(child: Text('Журнал не знайдено'));
        }

        return JournalDetailsContent(journal: journal);
      },
    );
  }
}

class JournalDetailsContent extends StatelessWidget {
  const JournalDetailsContent({super.key, required this.journal});

  final JournalDetails journal;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JournalHeader(journal: journal),
          const SizedBox(height: 16),
          const JournalFilters(),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 24,
              top: 24,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.background1,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradesTable(journal: journal),
                  // SizedBox(height: 12),
                  SizedBox(height: 24),
                  AppButton(
                    variant: ButtonVariant.black,
                    size: ButtonSize.lg,
                    onPressed: () => {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.save, size: 16),
                        SizedBox(width: 8),
                        Text('Зберегти оцінки'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
