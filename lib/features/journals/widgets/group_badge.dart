import 'package:flutter/cupertino.dart';

import '../../../common/constants/colors.dart';

class GroupBadge extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;

  const GroupBadge({super.key, required this.text, this.onTap});

  @override
  State<GroupBadge> createState() => _GroupBadgeState();
}

class _GroupBadgeState extends State<GroupBadge> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isHovering
                ? const Color(0xFF16A34A)
                : const Color(0xFF22C55E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.background1,
            ),
          ),
        ),
      ),
    );
  }
}

