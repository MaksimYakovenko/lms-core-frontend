import 'package:flutter/material.dart';

// ── токени ───────────────────────────────────────────────────────────────────
const _kBorderColor = Color(0xFFE2E8F0);       // border
const _kBgColor = Color(0xFFFFFFFF);           // bg-card
const _kFgColor = Color(0xFF111827);           // text-card-foreground
const _kMutedFg = Color(0xFF6B7280);           // text-muted-foreground
const _kRadius = Radius.circular(12);          // rounded-xl
const _kPadH = 24.0;                           // px-6
const _kPadTop = 24.0;                         // pt-6
const _kPadBottom = 24.0;                      // pb-6
const _kGap = 24.0;                            // gap-6
const _kHeaderGap = 6.0;                       // gap-1.5

// ── Card ─────────────────────────────────────────────────────────────────────

/// Аналог <Card> — bg-card rounded-xl border flex flex-col gap-6
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.children,
    this.padding = EdgeInsets.zero,
  });

  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _kBgColor,
        border: Border.all(color: _kBorderColor),
        borderRadius: const BorderRadius.all(_kRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _withGaps(children, _kGap),
      ),
    );
  }
}

// ── CardHeader ───────────────────────────────────────────────────────────────

/// Аналог <CardHeader> — px-6 pt-6 grid gap-1.5, підтримує action у правому куті
class AppCardHeader extends StatelessWidget {
  const AppCardHeader({
    super.key,
    this.title,
    this.description,
    this.action,
  });

  final Widget? title;
  final Widget? description;

  /// col-start-2 row-span-2 — дія вирівняна праворуч
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_kPadH, _kPadTop, _kPadH, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _withGaps(
                [
                  if (title != null) title!,
                  if (description != null) description!,
                ],
                _kHeaderGap,
              ),
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 8),
            action!,
          ],
        ],
      ),
    );
  }
}

// ── CardTitle ────────────────────────────────────────────────────────────────

/// Аналог <CardTitle> / <h4> — leading-none font-semibold
class AppCardTitle extends StatelessWidget {
  const AppCardTitle({super.key, required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(
        fontSize: style?.fontSize ?? 16,
        fontWeight: style?.fontWeight ?? FontWeight.w600,
        height: 1.0,                   // leading-none
        color: style?.color ?? _kFgColor,
      ),
    );
  }
}

// ── CardDescription ──────────────────────────────────────────────────────────

/// Аналог <CardDescription> / <p> — text-muted-foreground text-sm
class AppCardDescription extends StatelessWidget {
  const AppCardDescription({super.key, required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(
        fontSize: style?.fontSize ?? 14,
        color: style?.color ?? _kMutedFg,
      ),
    );
  }
}

// ── CardAction ───────────────────────────────────────────────────────────────

/// Аналог <CardAction> — self-start justify-self-end (правий кут хедера)
class AppCardAction extends StatelessWidget {
  const AppCardAction({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

// ── CardContent ──────────────────────────────────────────────────────────────

/// Аналог <CardContent> — px-6, останній елемент отримує pb-6
class AppCardContent extends StatelessWidget {
  const AppCardContent({super.key, required this.child, this.isLast = false});

  final Widget child;

  /// [&:last-child]:pb-6 — якщо це останній блок у Card
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _kPadH,
        0,
        _kPadH,
        isLast ? _kPadBottom : 0,
      ),
      child: child,
    );
  }
}

// ── CardFooter ───────────────────────────────────────────────────────────────

/// Аналог <CardFooter> — flex items-center px-6 pb-6
class AppCardFooter extends StatelessWidget {
  const AppCardFooter({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_kPadH, 0, _kPadH, _kPadBottom),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // items-center
        children: children,
      ),
    );
  }
}

// ── утиліта ──────────────────────────────────────────────────────────────────
List<Widget> _withGaps(List<Widget> widgets, double gap) {
  final result = <Widget>[];
  for (var i = 0; i < widgets.length; i++) {
    result.add(widgets[i]);
    if (i < widgets.length - 1) result.add(SizedBox(height: gap));
  }
  return result;
}

