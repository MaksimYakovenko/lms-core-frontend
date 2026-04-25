import 'package:flutter/material.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_stat_card.dart';
import 'package:lms_core_frontend/common/components/app_table.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/journals/journals_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class JournalsScreen extends StatefulWidget {
  const JournalsScreen({super.key});

  @override
  State<JournalsScreen> createState() => _JournalsScreenState();
}

class _JournalsScreenState extends State<JournalsScreen> {
  final _service = JournalsService();
  late Future<List<Journal>> _futureJournals;
  int _page = 1;
  static const _perPage = 8;

  @override
  void initState() {
    super.initState();
    _futureJournals = _service.getJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Журнали',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Управління класними журналами та відвідуваністю',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                AppButton(
                  variant: ButtonVariant.black,
                  size: ButtonSize.defaultSize,
                  onPressed: () {},
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.circlePlus, size: 16),
                      SizedBox(width: 8),
                      Text('Створити журнал'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            FutureBuilder<List<Journal>>(
              future: _futureJournals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Помилка: ${snapshot.error}'));
                }

                final journals = snapshot.data ?? [];

                final rows = journals.map((j) {
                  return [
                    Text(
                      j.subject.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      j.group.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ];
                }).toList();

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppStatCard(
                            isRight: true,
                            title: 'Всього журналів',
                            value: journals.length.toString(),
                            icon: LucideIcons.bookOpen,
                            iconBgColor: const Color(0xFFE0E7FF),
                            iconColor: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: AppStatCard(
                            isRight: true,
                            title: 'Активні класи',
                            value: '24',
                            icon: LucideIcons.fileText,
                            iconBgColor: Color(0xFFDCFCE7),
                            iconColor: Color(0xFF16A34A),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: AppStatCard(
                            isRight: true,
                            title: 'Останні перегляди',
                            value: '15',
                            icon: LucideIcons.eye,
                            iconBgColor: Color(0xFFF3E8FF),
                            iconColor: Color(0xFF9333EA),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        AppButton(
                          variant: ButtonVariant.outline,
                          size: ButtonSize.defaultSize,
                          onPressed: () {},
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.eye, size: 16),
                              SizedBox(width: 8),
                              Text('Відвідуваність'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        AppButton(
                          variant: ButtonVariant.outline,
                          size: ButtonSize.defaultSize,
                          onPressed: () {},
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.fileText, size: 16),
                              SizedBox(width: 8),
                              Text('Зведені звіти'),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Оберіть журнал:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    AppTable(
                      columns: const [
                        AppTableColumn(label: 'Предмет', width: FlexColumnWidth(4)),
                        AppTableColumn(label: 'Група', width: FlexColumnWidth(4)),
                      ],
                      rows: rows,
                      totalCount: journals.length,
                      currentPage: _page,
                      itemsPerPage: _perPage,
                      onPageChange: (p) => setState(() => _page = p),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
