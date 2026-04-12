import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  static const _borderColor = Color(0xFFE5E7EB);
  static const _surfaceColor = Color(0xFFF9FAFB);
  static const _titleColor = Color(0xFF111827);
  static const _subtitleColor = Color(0xFF4B5563);
  static const _mutedColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ласкаво просимо, Максим Яковенко',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _titleColor,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Керуйте своєю шкільною системою з цієї панелі інструментів',
            style: TextStyle(
              fontSize: 15,
              color: _subtitleColor,
            ),
          ),
          const SizedBox(height: 36),

          Row(
            children: const [
              Expanded(
                child: _StatCard(
                  title: 'Кількість вчителів',
                  value: '120',
                  icon: LucideIcons.graduationCap,
                  iconBgColor: Color(0xFFE0E7FF),
                  iconColor: Color(0xFF2563EB),
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _StatCard(
                  title: 'Кількість студентів',
                  value: '120',
                  icon: LucideIcons.user,
                  iconBgColor: Color(0xFFDCFCE7),
                  iconColor: Color(0xFF16A34A),
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _StatCard(
                  title: 'Кількість груп',
                  value: '120',
                  icon: LucideIcons.layers,
                  iconBgColor: Color(0xFFF3E8FF),
                  iconColor: Color(0xFF9333EA),
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _StatCard(
                  title: 'Кількість предметів',
                  value: '120',
                  icon: LucideIcons.library,
                  iconBgColor: Color(0xFFFFEDD5),
                  iconColor: Color(0xFFEA580C),
                ),
              ),
            ],
          ),

          const SizedBox(height: 36),

          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _borderColor),
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
                          iconBgColor: Color(0xFFE0E7FF),
                          iconColor: Color(0xFF2563EB),
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: _QuickActionCard(
                          title: 'Студенти',
                          icon: LucideIcons.user,
                          iconBgColor: Color(0xFFDCFCE7),
                          iconColor: Color(0xFF16A34A),
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: _QuickActionCard(
                          title: 'Групи',
                          icon: LucideIcons.layers,
                          iconBgColor: Color(0xFFF3E8FF),
                          iconColor: Color(0xFF9333EA),
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: _QuickActionCard(
                          title: 'Предмети',
                          icon: LucideIcons.library,
                          iconBgColor: Color(0xFFFFEDD5),
                          iconColor: Color(0xFFEA580C),
                        ),
                      ),
                    ],
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              LucideIcons.plus,
              size: 20,
              color: Color(0xFF42464E),
            ),
            SizedBox(width: 8),
            Text(
              'Швидкі дії',
              style: TextStyle(
                fontSize: 16,
                color: AdminMainScreen._titleColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Керуйте даними швидко та легко',
          style: TextStyle(
            fontSize: 15,
            color: AdminMainScreen._mutedColor,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminMainScreen._surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AdminMainScreen._borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AdminMainScreen._titleColor,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AdminMainScreen._titleColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 28,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AdminMainScreen._borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AdminMainScreen._titleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _ActionItem(
            icon: LucideIcons.plus,
            label: 'Add',
            highlighted: true,
          ),
          const SizedBox(height: 12),
          const _ActionItem(
            icon: LucideIcons.list,
            label: 'View All',
          ),
          const SizedBox(height: 12),
          const _ActionItem(
            icon: LucideIcons.pencil,
            label: 'Edit',
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;

  const _ActionItem({
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF111827),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );

    if (!highlighted) return child;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}