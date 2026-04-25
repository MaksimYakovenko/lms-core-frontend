import 'package:flutter/material.dart';
import 'package:lms_core_frontend/common/components/app_stat_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/features/admin_main/main_service.dart';

import '../../common/constants/colors.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  final AdminMainService _service = AdminMainService();

  bool _isLoading = true;
  String _displayName = '';
  Map<String, int> _totals = {
    'total_teachers': 0,
    'total_students': 0,
    'total_groups': 0,
    'total_subjects': 0,
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final name = await _service.fetchDisplayName(context);
      final totals = await _service.fetchTotals(context);
      setState(() {
        _displayName = name!;
        _totals = totals!;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isLoading
              ? const SizedBox(
                height: 28,
                width: 200,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Color(0xFF2563EB),
                  backgroundColor: Color(0xFFE0E7FF),
                ),
              )
              : Text(
                'Ласкаво просимо, $_displayName 👋!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
          const SizedBox(height: 10),
          const Text(
            'Керуйте своєю шкільною системою з цієї панелі інструментів',
            style: TextStyle(fontSize: 15, color: AppColors.textMuted),
          ),
          const SizedBox(height: 36),

          if (_isLoading)
            Row(
              children:
                  List.generate(
                    4,
                    (i) => [
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.background1,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (i < 3) const SizedBox(width: 24),
                    ],
                  ).expand((e) => e).toList(),
            )
          else
            Row(
              children: [
                Expanded(
                  child: AppStatCard(
                    title: 'Кількість вчителів',
                    value: _totals['total_teachers']!.toString(),
                    icon: LucideIcons.graduationCap,
                    iconBgColor: const Color(0xFFE0E7FF),
                    iconColor: const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AppStatCard(
                    title: 'Кількість студентів',
                    value: _totals['total_students']!.toString(),
                    icon: LucideIcons.user,
                    iconBgColor: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AppStatCard(
                    title: 'Кількість груп',
                    value: _totals['total_groups']!.toString(),
                    icon: LucideIcons.layers,
                    iconBgColor: const Color(0xFFF3E8FF),
                    iconColor: const Color(0xFF9333EA),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AppStatCard(
                    title: 'Кількість предметів',
                    value: _totals['total_subjects']!.toString(),
                    icon: LucideIcons.library,
                    iconBgColor: const Color(0xFFFFEDD5),
                    iconColor: const Color(0xFFEA580C),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 36),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.background1,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.trendingUp,
                            size: 20,
                            color: const Color(0xFF16A34A),
                          ),
                          SizedBox(width: 8),
                          Text('Розподіл учнів за групами'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.background1,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.graduationCap,
                        size: 20,
                        color: const Color(0xFF9333EA),
                      ),
                      SizedBox(width: 8),
                      Text('Розподіл вчителів за предметами'),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 36),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
              color: AppColors.background1,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(),
                const SizedBox(height: 24),
                Row(
                  children: const [
                    Expanded(
                      child: _QuickActionCard(
                        title: 'Викладачі',
                        icon: LucideIcons.graduationCap,
                        iconColor: Color(0xFF2563EB),
                        textColor: Color(0xFF2563EB),
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _QuickActionCard(
                        title: 'Студенти',
                        icon: LucideIcons.user,
                        iconColor: Color(0xFF16A34A),
                        textColor: Color(0xFF16A34A),
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _QuickActionCard(
                        title: 'Групи',
                        icon: LucideIcons.layers,
                        iconColor: Color(0xFF9333EA),
                        textColor: Color(0xFF9333EA),
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _QuickActionCard(
                        title: 'Предмети',
                        icon: LucideIcons.library,
                        iconColor: Color(0xFFEA580C),
                        textColor: Color(0xFFEA580C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.plus, size: 20, color: Color(0xFF42464E)),
            SizedBox(width: 8),
            Text(
              'Швидкі дії',
              style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Керуйте даними швидко та легко',
          style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color? textColor;
  final VoidCallback? onAdd;
  final VoidCallback? onViewAll;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    this.textColor,
    this.onAdd,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _ActionItem(
            icon: LucideIcons.plus,
            label: 'Додати',
            onTap: onAdd,
          ),

          _ActionItem(
            icon: LucideIcons.list,
            label: 'Переглянути список',
            onTap: onViewAll,
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  State<_ActionItem> createState() => _ActionItemState();
}

class _ActionItemState extends State<_ActionItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFE5E7EB) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 18, color: const Color(0xFF111827)),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}