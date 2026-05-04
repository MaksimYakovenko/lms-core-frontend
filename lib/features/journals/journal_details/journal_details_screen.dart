import 'package:flutter/material.dart';

import '../../../common/constants/colors.dart';
import 'journal_details_service.dart';
import 'widgets/journal_filters.dart';
import 'widgets/journal_info_card.dart';
import 'widgets/journal_legend.dart';
import 'widgets/quick_stats.dart';

class JournalDetailsScreen extends StatefulWidget {
  const JournalDetailsScreen({
    super.key,
    required this.journalId,
  });

  final String journalId;

  @override
  State<JournalDetailsScreen> createState() =>
      _JournalDetailsScreenState();
}

class _JournalDetailsScreenState extends State<JournalDetailsScreen> {
  final _service = JournalDetailsService();

  late Future<JournalDetails> _future;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final id = int.tryParse(widget.journalId) ?? 0;

    setState(() {
      _future = _service.getJournalById(id);
    });
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

        return JournalDetailsContent(
          journal: journal,
          onRefresh: _refresh,
        );
      },
    );
  }
}

class JournalDetailsContent extends StatelessWidget {
  const JournalDetailsContent({
    super.key,
    required this.journal,
    this.onRefresh,
  });

  final JournalDetails journal;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Електронний журнал',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Управління оцінками та відвідуваністю студентів групи',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            JournalFilters(
              journal: journal,
              onRefresh: onRefresh,
            ),
            const SizedBox(height: 24),
            JournalInfoCard(journal: journal),
            const SizedBox(height: 24),
            const JournalLegend(),
            const SizedBox(height: 24),
            QuickStats(journal: journal),
          ],
        ),
      ),
    );
  }
}