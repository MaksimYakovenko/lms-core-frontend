import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const ActionItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  State<ActionItem> createState() => ActionItemState();
}

class ActionItemState extends State<ActionItem> {
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
