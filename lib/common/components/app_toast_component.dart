import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  AppToast._();

  static void show(
    BuildContext context, {
    required String title,
    String? description,
    ToastificationType type = ToastificationType.info,
    Alignment alignment = Alignment.topRight,
    Duration duration = const Duration(seconds: 4),
  }) {  
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      description: description != null
          ? Text(description, style: const TextStyle(fontSize: 13))
          : null,
      alignment: alignment,
      autoCloseDuration: duration,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(8),
      showProgressBar: true,
      closeOnClick: false,
      pauseOnHover: true,
    );
  }

  static void success(
    BuildContext context, {
    required String title,
    String? description,
    Alignment alignment = Alignment.topRight,
  }) =>
      show(
        context,
        title: title,
        description: description,
        type: ToastificationType.success,
        alignment: alignment,
      );

  static void error(
    BuildContext context, {
    required String title,
    String? description,
    Alignment alignment = Alignment.topRight,
  }) =>
      show(
        context,
        title: title,
        description: description,
        type: ToastificationType.error,
        alignment: alignment,
      );

  static void warning(
    BuildContext context, {
    required String title,
    String? description,
    Alignment alignment = Alignment.topRight,
  }) =>
      show(
        context,
        title: title,
        description: description,
        type: ToastificationType.warning,
        alignment: alignment,
      );

  static void info(
    BuildContext context, {
    required String title,
    String? description,
    Alignment alignment = Alignment.topRight,
  }) =>
      show(
        context,
        title: title,
        description: description,
        type: ToastificationType.info,
        alignment: alignment,
      );
}


