import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    this.controller,
    this.hintText,
    this.errorText,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.onChanged,
    this.onEditingComplete,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final VoidCallback? onEditingComplete;

  // ── кольори (аналог Tailwind/shadcn токенів) ──────────────────────────────
  static const _borderColor = Color(0xFFE2E8F0);       // border-input
  static const _focusRingColor = Color(0xFF16A34A);     // ring / focus-visible:border-ring
  static const _errorBorderColor = Color(0xFFEF4444);   // destructive
  static const _errorRingColor = Color(0xFFEF4444);     // aria-invalid:border-destructive
  static const _disabledOpacity = 0.5;                  // disabled:opacity-50
  static const _fillColor = Color(0xFFF8FAFC);          // bg-input-background
  static const _hintColor = Color(0xFF94A3B8);          // placeholder:text-muted-foreground
  static const _textColor = Color(0xFF111827);          // text-foreground

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Opacity(
      opacity: enabled ? 1.0 : _disabledOpacity,
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        style: const TextStyle(
          fontSize: 14,
          color: _textColor,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          errorText: hasError ? errorText : null,
          hintStyle: const TextStyle(
            color: _hintColor,
            fontSize: 14,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: _fillColor,
          isDense: true,
          // h-9 = 36px → contentPadding вертикаль 10
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12, // px-3
            vertical: 10,   // py-1 + висота h-9
          ),

          // border (default)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6), // rounded-md
            borderSide: const BorderSide(color: _borderColor),
          ),

          // enabled (no focus, no error)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: hasError ? _errorBorderColor : _borderColor,
            ),
          ),

          // focused — ring-[3px] + border-ring
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: hasError ? _errorBorderColor : _focusRingColor,
              width: 1.5,
            ),
          ),

          // focused + error — aria-invalid:border-destructive
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: _errorRingColor,
              width: 1.5,
            ),
          ),

          // error border
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: _errorBorderColor),
          ),

          // shadow-like focus ring через focusedBorder (Flutter не підтримує ring natively)
        ),
      ),
    );
  }
}

