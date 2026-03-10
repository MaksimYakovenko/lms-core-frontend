import 'package:flutter/material.dart';

enum ButtonVariant { primary, destructive, outline, secondary, ghost, link }

enum ButtonSize { defaultSize, sm, lg, icon }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.defaultSize,
    this.isLoading = false,
    this.disabled = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool disabled;

  // ── розміри (h-8 → 32, h-9 → 36, h-10 → 40, size-9 → 36) ─────────────────
  double get _height => switch (size) {
        ButtonSize.sm          => 32, // h-8
        ButtonSize.defaultSize => 36, // h-9
        ButtonSize.lg          => 40, // h-10
        ButtonSize.icon        => 36, // size-9
      };

  // sm: px-3 gap-1.5 | default: px-4 py-2 | lg: px-6 | icon: no padding
  EdgeInsets get _padding => switch (size) {
        ButtonSize.sm          => const EdgeInsets.symmetric(horizontal: 12),
        ButtonSize.lg          => const EdgeInsets.symmetric(horizontal: 24),
        ButtonSize.icon        => EdgeInsets.zero,
        ButtonSize.defaultSize => const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      };

  // gap між дочірніми елементами (gap-2 / gap-1.5)
  double get _gap => switch (size) {
        ButtonSize.sm => 6,  // gap-1.5
        _             => 8,  // gap-2
      };

  // rounded-md = 6
  static const double _kRadius = 6.0;

  // ── кольори відповідно до React variants ───────────────────────────────────

  // bg-primary = #16A34A, bg-destructive = #DC2626
  // bg-secondary = #F3F4F6, outline/ghost/link = transparent
  Color? get _bgColor => switch (variant) {
        ButtonVariant.primary     => const Color(0xFF16A34A),
        ButtonVariant.destructive => const Color(0xFFDC2626),
        ButtonVariant.secondary   => const Color(0xFFF3F4F6),
        ButtonVariant.outline ||
        ButtonVariant.ghost  ||
        ButtonVariant.link        => Colors.transparent,
      };

  // text-primary-foreground / white / secondary-foreground / foreground
  Color get _fgColor => switch (variant) {
        ButtonVariant.primary     => Colors.white,
        ButtonVariant.destructive => Colors.white,
        ButtonVariant.secondary   => const Color(0xFF111827),
        ButtonVariant.outline     => const Color(0xFF111827),
        ButtonVariant.ghost       => const Color(0xFF111827),
        ButtonVariant.link        => const Color(0xFF16A34A),
      };

  // outline: border bg-background
  Color? get _borderColor => switch (variant) {
        ButtonVariant.outline => const Color(0xFFE5E7EB),
        _                     => null,
      };

  // hover: bg-primary/90, bg-destructive/90, bg-secondary/80, bg-accent, bg-accent/50
  Color get _hoverBg => switch (variant) {
        ButtonVariant.primary     => const Color(0xFF15803D), // /90
        ButtonVariant.destructive => const Color(0xFFB91C1C), // /90
        ButtonVariant.secondary   => const Color(0xFFE5E7EB), // /80
        ButtonVariant.outline     => const Color(0xFFF3F4F6), // hover:bg-accent
        ButtonVariant.ghost       => const Color(0xFFF3F4F6), // hover:bg-accent
        ButtonVariant.link        => Colors.transparent,
      };

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled || isLoading;
    final effectiveOnPressed = isDisabled ? null : onPressed;

    final style = ButtonStyle(
      // transition-all + disabled:opacity-50
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return (_bgColor ?? Colors.transparent).withAlpha(128); // opacity-50
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.pressed)) {
          return _hoverBg;
        }
        return _bgColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return _fgColor.withAlpha(128); // opacity-50
        }
        return _fgColor;
      }),
      // focus-visible:ring-[3px] focus-visible:ring-ring/50
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      side: WidgetStateProperty.resolveWith((states) {
        if (_borderColor == null) return BorderSide.none;
        // focus-visible:border-ring
        if (states.contains(WidgetState.focused)) {
          return const BorderSide(color: Color(0xFF6B7280), width: 1);
        }
        return BorderSide(color: _borderColor!);
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kRadius)),
      ),
      padding: WidgetStateProperty.all(_padding),
      minimumSize: WidgetStateProperty.all(
        size == ButtonSize.icon
            ? Size(_height, _height)
            : Size(0, _height),
      ),
      elevation: WidgetStateProperty.all(0),
      // text-sm font-medium
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
      ),
      // animationDuration для transition-all
      animationDuration: const Duration(milliseconds: 150),
    );

    // Обгортаємо child у Row з gap, щоб іконки та текст мали правильний відступ
    final inner = isLoading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_fgColor),
                ),
              ),
              SizedBox(width: _gap),
              child,
            ],
          )
        : child;

    if (variant == ButtonVariant.link) {
      return TextButton(onPressed: effectiveOnPressed, style: style, child: inner);
    }
    if (variant == ButtonVariant.outline) {
      return OutlinedButton(onPressed: effectiveOnPressed, style: style, child: inner);
    }
    return ElevatedButton(onPressed: effectiveOnPressed, style: style, child: inner);
  }
}
