import 'package:flutter/material.dart';

enum ButtonVariant {
  primary,
  destructive,
  outline,
  secondary,
  ghost,
  link,
  black,
}

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

  double get _height => switch (size) {
    ButtonSize.sm => 32,
    ButtonSize.defaultSize => 36,
    ButtonSize.lg => 40,
    ButtonSize.icon => 36,
  };

  EdgeInsets get _padding => switch (size) {
    ButtonSize.sm => const EdgeInsets.symmetric(horizontal: 12),
    ButtonSize.lg => const EdgeInsets.symmetric(horizontal: 24),
    ButtonSize.icon => EdgeInsets.zero,
    ButtonSize.defaultSize => const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
  };

  double get _gap => switch (size) {
    ButtonSize.sm => 6,
    _ => 8,
  };

  static const double _kRadius = 6.0;

  Color? get _bgColor => switch (variant) {
    ButtonVariant.primary => const Color(0xFF16A34A),
    ButtonVariant.destructive => const Color(0xFFDC2626),
    ButtonVariant.secondary => const Color(0xFFF3F4F6),
    ButtonVariant.outline ||
    ButtonVariant.ghost ||
    ButtonVariant.link =>
    Colors.transparent,
    ButtonVariant.black => const Color(0xFF111827),
  };

  Color get _fgColor => switch (variant) {
    ButtonVariant.primary => Colors.white,
    ButtonVariant.destructive => Colors.white,
    ButtonVariant.secondary => const Color(0xFF111827),
    ButtonVariant.outline => const Color(0xFF111827),
    ButtonVariant.ghost => const Color(0xFF111827),
    ButtonVariant.black => Colors.white,
    ButtonVariant.link => const Color(0xFF16A34A),
  };

  Color? get _borderColor => switch (variant) {
    ButtonVariant.outline => const Color(0xFFE5E7EB),
    _ => null,
  };

  Color get _hoverBg => switch (variant) {
    ButtonVariant.primary => const Color(0xFF15803D),
    ButtonVariant.destructive => const Color(0xFFB91C1C),
    ButtonVariant.secondary => const Color(0xFFE5E7EB),
    ButtonVariant.outline => const Color(0xFFF3F4F6),
    ButtonVariant.ghost => const Color(0xFFF3F4F6),
    ButtonVariant.black => const Color(0xFF1F2937),
    ButtonVariant.link => Colors.transparent,
  };

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled || isLoading;
    final effectiveOnPressed = isDisabled ? null : onPressed;

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return (_bgColor ?? Colors.transparent).withAlpha(128);
        }

        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.pressed)) {
          return _hoverBg;
        }

        return _bgColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return _fgColor.withAlpha(128);
        }

        return _fgColor;
      }),
      iconColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return _fgColor.withAlpha(128);
        }

        return _fgColor;
      }),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      side: WidgetStateProperty.resolveWith((states) {
        if (_borderColor == null) return BorderSide.none;

        if (states.contains(WidgetState.focused)) {
          return const BorderSide(
            color: Color(0xFF6B7280),
            width: 1,
          );
        }

        return BorderSide(color: _borderColor!);
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_kRadius),
        ),
      ),
      padding: WidgetStateProperty.all(_padding),
      minimumSize: WidgetStateProperty.all(
        size == ButtonSize.icon ? Size(_height, _height) : Size(0, _height),
      ),
      elevation: WidgetStateProperty.all(0),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
      ),
      animationDuration: const Duration(milliseconds: 150),
    );

    final buttonChild = isLoading
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

    final inner = IconTheme(
      data: IconThemeData(color: _fgColor),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: _fgColor),
        child: buttonChild,
      ),
    );

    if (variant == ButtonVariant.link) {
      return TextButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: inner,
      );
    }

    if (variant == ButtonVariant.outline) {
      return OutlinedButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: inner,
      );
    }

    return ElevatedButton(
      onPressed: effectiveOnPressed,
      style: style,
      child: inner,
    );
  }
}