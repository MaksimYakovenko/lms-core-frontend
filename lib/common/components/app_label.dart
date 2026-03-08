import 'package:flutter/material.dart';

class AppLabel extends StatelessWidget {
  const AppLabel({
    super.key,
    required this.text,
    this.disabled = false,
    this.child,
  });

  final String text;

  /// group-data-[disabled=true]:opacity-50 — аналог disabled стану
  final bool disabled;

  /// Опціональний дочірній віджет після тексту (gap-2 — аналог flex gap)
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,       // peer-disabled:opacity-50
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,                  // text-sm
              fontWeight: FontWeight.w500,   // font-medium
              height: 1.0,                   // leading-none
              color: Color(0xFF111827),
            ),
          ),
          if (child != null) ...[
            const SizedBox(width: 8),        // gap-2
            child!,
          ],
        ],
      ),
    );
  }
}

