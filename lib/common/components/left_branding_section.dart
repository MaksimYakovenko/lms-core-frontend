import 'package:flutter/material.dart';

class LeftBrandingSection extends StatelessWidget {
  const LeftBrandingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(48),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF16A34A),
              Color(0xFF1D4ED8),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 80,
              left: 80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: 80,
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Color(0xFF16A34A),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EduPortal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Teacher Management System',
                          style: TextStyle(
                            color: Color(0xFFDCFCE7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 72),
                const Text(
                  'Empowering Education\nAcross Nigeria',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                const SizedBox(
                  width: 460,
                  child: Text(
                    'Manage student results, create CBT exams, upload resources, and track assessments—all in one comprehensive platform.',
                    style: TextStyle(
                      color: Color(0xFFDCFCE7),
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                ),
                const Spacer(),
                const _FeatureItem(
                  title: 'Results Management',
                  description:
                  'Upload and manage student results by class and subject',
                ),
                const SizedBox(height: 20),
                const _FeatureItem(
                  title: 'CBT Exams',
                  description:
                  'Create and schedule computer-based tests with ease',
                ),
                const SizedBox(height: 20),
                const _FeatureItem(
                  title: 'Resource Library',
                  description:
                  'Share academic materials, videos, and past questions',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String title;
  final String description;

  const _FeatureItem({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 7),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFFDCFCE7),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

