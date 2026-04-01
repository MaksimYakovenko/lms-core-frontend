import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_card.dart';
import 'package:lms_core_frontend/config/routers/view_identifiers.dart';

class NotFoundPageScreen extends StatelessWidget {
  const NotFoundPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: AppCard(
            children: [
              AppCardHeader(
                title: Row(
                  children: const [
                    Icon(LucideIcons.triangleAlert,
                        size: 20, color: Color(0xFFDC2626)),
                    SizedBox(width: 8),
                    Text(
                      '404 — Сторінку не знайдено',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                description: const AppCardDescription(
                  text:
                      'Сторінка, яку ви шукаєте, не існує або була переміщена.',
                ),
              ),
              AppCardContent(
                isLast: false,
                child: Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: const Text(
                    '404',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFE5E7EB),
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              AppCardFooter(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: () =>
                          context.goNamed(ViewIdentifiers.home.name),
                      variant: ButtonVariant.primary,
                      size: ButtonSize.defaultSize,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(LucideIcons.house, size: 16),
                          SizedBox(width: 8),
                          Text('На головну'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      onPressed: () => context.pop(),
                      variant: ButtonVariant.outline,
                      size: ButtonSize.defaultSize,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(LucideIcons.arrowLeft, size: 16),
                          SizedBox(width: 8),
                          Text('Назад'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
