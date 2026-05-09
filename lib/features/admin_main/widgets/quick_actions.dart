import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/constants/colors.dart';

class QuickActionButton extends StatefulWidget {
  const QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.width,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double width;

  @override
  State<QuickActionButton> createState() => QuickActionButtonState();
}

class QuickActionButtonState extends State<QuickActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.gray200 : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 20, color: AppColors.textPrimary),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}