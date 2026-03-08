import 'package:flutter/material.dart';

enum AlertVariant { defaultVariant, destructive }

// ── токени ───────────────────────────────────────────────────────────────────
const _kBorderRadius = Radius.circular(8);     // rounded-lg
const _kPadding = EdgeInsets.symmetric(        // px-4 py-3
  horizontal: 16,
  vertical: 12,
);

// ── Alert ────────────────────────────────────────────────────────────────────

/// Аналог <Alert> — relative w-full rounded-lg border px-4 py-3
class AppAlert extends StatelessWidget {
  const AppAlert({
    super.key,
    required this.children,
    this.variant = AlertVariant.defaultVariant,
    this.icon,
  });

  final List<Widget> children;
  final AlertVariant variant;

  /// [&>svg]:size-4 [&>svg]:translate-y-0.5 — іконка ліворуч
  final Widget? icon;

  Color get _bgColor => switch (variant) {
        AlertVariant.defaultVariant => const Color(0xFFFFFFFF),  // bg-card
        AlertVariant.destructive => const Color(0xFFFEF2F2),
      };

  Color get _borderColor => switch (variant) {
        AlertVariant.defaultVariant => const Color(0xFFE2E8F0),
        AlertVariant.destructive => const Color(0xFFFCA5A5),
      };

  Color get _iconColor => switch (variant) {
        AlertVariant.defaultVariant => const Color(0xFF111827),
        AlertVariant.destructive => const Color(0xFFEF4444),  // text-destructive
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: _kPadding,
      decoration: BoxDecoration(
        color: _bgColor,
        border: Border.all(color: _borderColor),
        borderRadius: const BorderRadius.all(_kBorderRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // іконка — has-[>svg]:grid-cols-[calc(var(--spacing)*4)_1fr]
          if (icon != null) ...[
            SizedBox(
              width: 16,   // size-4
              height: 16,
              child: IconTheme(
                data: IconThemeData(color: _iconColor, size: 16),
                child: icon!,
              ),
            ),
            const SizedBox(width: 12),  // gap-x-3
          ],
          // контент — col 2
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

// ── AlertTitle ───────────────────────────────────────────────────────────────

/// Аналог <AlertTitle> — font-medium tracking-tight line-clamp-1
class AppAlertTitle extends StatelessWidget {
  const AppAlertTitle({
    super.key,
    required this.text,
    this.variant = AlertVariant.defaultVariant,
  });

  final String text;
  final AlertVariant variant;

  Color get _color => switch (variant) {
        AlertVariant.defaultVariant => const Color(0xFF111827),
        AlertVariant.destructive => const Color(0xFFB91C1C),
      };

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,                              // line-clamp-1
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14,                           // text-sm
        fontWeight: FontWeight.w500,            // font-medium
        letterSpacing: -0.025 * 14,             // tracking-tight
        color: _color,
        height: 1.0,                            // min-h-4
      ),
    );
  }
}

// ── AlertDescription ─────────────────────────────────────────────────────────

/// Аналог <AlertDescription> — text-muted-foreground text-sm [&_p]:leading-relaxed
class AppAlertDescription extends StatelessWidget {
  const AppAlertDescription({
    super.key,
    required this.text,
    this.variant = AlertVariant.defaultVariant,
  });

  final String text;
  final AlertVariant variant;

  Color get _color => switch (variant) {
        AlertVariant.defaultVariant => const Color(0xFF6B7280),    // text-muted-foreground
        AlertVariant.destructive => const Color(0xFFB91C1C),       // text-destructive/90
      };

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,    // text-sm
        color: _color,
        height: 1.625,   // leading-relaxed
      ),
    );
  }
}

