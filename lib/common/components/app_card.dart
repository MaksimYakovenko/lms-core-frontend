import 'package:flutter/material.dart';


const _kBorderColor = Color(0xFFE2E8F0);
const _kBgColor = Color(0xFFFFFFFF);
const _kFgColor = Color(0xFF111827);
const _kMutedFg = Color(0xFF6B7280);
const _kRadius = Radius.circular(12);
const _kPadH = 24.0;
const _kPadTop = 24.0;
const _kPadBottom = 24.0;
const _kGap = 24.0;
const _kHeaderGap = 6.0;

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.innerPadding,
  });

  final List<Widget> children;
  final EdgeInsets padding;
  final EdgeInsets? innerPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _kBgColor,
        border: Border.all(color: _kBorderColor),
        borderRadius: const BorderRadius.all(_kRadius),
      ),
      child: AppCardPaddingScope(
        innerPadding: innerPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _withGaps(children, _kGap),
        ),
      ),
    );
  }
}

/// Inherited widget to expose optional inner padding to descendants.
class AppCardPaddingScope extends InheritedWidget {
  const AppCardPaddingScope({
    super.key,
    required this.child,
    this.innerPadding,
  }) : super(child: child);

  final Widget child;
  final EdgeInsets? innerPadding;

  static EdgeInsets? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppCardPaddingScope>();
    return scope?.innerPadding;
  }

  @override
  bool updateShouldNotify(covariant AppCardPaddingScope oldWidget) {
    return oldWidget.innerPadding != innerPadding;
  }
}

class AppCardHeader extends StatelessWidget {
  const AppCardHeader({super.key, this.title, this.description, this.action});

  final Widget? title;
  final Widget? description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final custom = AppCardPaddingScope.of(context);
    final padding = custom ?? const EdgeInsets.fromLTRB(_kPadH, _kPadTop, _kPadH, 0);

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _withGaps([
                if (title != null) title!,
                if (description != null) description!,
              ], _kHeaderGap),
            ),
          ),
          if (action != null) ...[const SizedBox(width: 8), action!],
        ],
      ),
    );
  }
}

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
        height: 1.0,
        color: style?.color ?? _kFgColor,
      ),
    );
  }
}

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

class AppCardAction extends StatelessWidget {
  const AppCardAction({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class AppCardContent extends StatelessWidget {
  const AppCardContent({super.key, required this.child, this.isLast = false});

  final Widget child;

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final custom = AppCardPaddingScope.of(context);
    final padding = custom != null
        ? EdgeInsets.fromLTRB(custom.left, 0, custom.right, isLast ? custom.bottom : 0)
        : EdgeInsets.fromLTRB(_kPadH, 0, _kPadH, isLast ? _kPadBottom : 0);

    return Padding(
      padding: padding,
      child: child,
    );
  }
}

class AppCardFooter extends StatelessWidget {
  const AppCardFooter({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final custom = AppCardPaddingScope.of(context);
    final padding = custom ?? const EdgeInsets.fromLTRB(_kPadH, 0, _kPadH, _kPadBottom);

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // items-center
        children: children,
      ),
    );
  }
}

List<Widget> _withGaps(List<Widget> widgets, double gap) {
  final result = <Widget>[];
  for (var i = 0; i < widgets.length; i++) {
    result.add(widgets[i]);
    if (i < widgets.length - 1) result.add(SizedBox(height: gap));
  }
  return result;
}
