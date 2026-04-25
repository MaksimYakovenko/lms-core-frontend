import 'package:flutter/cupertino.dart';

import '../constants/colors.dart';

class AppStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final bool isRight;

  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    this.isRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isRight ? const EdgeInsets.all(15) : const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: isRight ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
        children: [
          if (isRight) ...[
            _buildIcon(),
            const SizedBox(width: 12),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (!isRight) _buildIcon(),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 28, color: iconColor),
    );
  }
}
