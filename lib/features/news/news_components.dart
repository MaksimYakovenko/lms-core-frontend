import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/common/utils/web_image_widget.dart';
import 'package:lms_core_frontend/features/news/news_service.dart';

class NewsViewButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const NewsViewButton({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.gray900 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? AppColors.gray900 : AppColors.divider,
          ),
          boxShadow: active
              ? []
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: active ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: active ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsGridCard extends StatefulWidget {
  final NewsItem item;
  const NewsGridCard({super.key, required this.item});

  @override
  State<NewsGridCard> createState() => _NewsGridCardState();
}

class _NewsGridCardState extends State<NewsGridCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _hovered ? 0.12 : 0.04),
              blurRadius: _hovered ? 16 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: NewsImage(
                        url: widget.item.imageUrl,
                        scale: _hovered ? 1.05 : 1.0,
                        height: 180,
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _hovered ? 1 : 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x99000000)],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _hovered ? const Color(0xFF2563EB) : AppColors.gray900,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(LucideIcons.calendar, size: 12, color: AppColors.gray400),
                        const SizedBox(width: 4),
                        Text(
                          'Новина #${widget.item.id}',
                          style: const TextStyle(fontSize: 11, color: AppColors.gray400),
                        ),
                        const Spacer(),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _hovered ? 1 : 0,
                          child: const Icon(LucideIcons.externalLink, size: 14, color: AppColors.gray400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── List card ────────────────────────────────────────────────────────────────

class NewsListCard extends StatefulWidget {
  final NewsItem item;
  const NewsListCard({super.key, required this.item});

  @override
  State<NewsListCard> createState() => _NewsListCardState();
}

class _NewsListCardState extends State<NewsListCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _hovered ? 0.10 : 0.04),
              blurRadius: _hovered ? 14 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 220,
                  child: NewsImage(
                    url: widget.item.imageUrl,
                    scale: _hovered ? 1.05 : 1.0,
                    height: 160,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.item.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: _hovered ? const Color(0xFF2563EB) : AppColors.gray900,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: _hovered ? 1 : 0,
                              child: const Icon(LucideIcons.externalLink, size: 16, color: AppColors.gray400),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(LucideIcons.calendar, size: 14, color: AppColors.gray400),
                            const SizedBox(width: 4),
                            Text(
                              'Новина #${widget.item.id}',
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewsMasonryCard extends StatefulWidget {
  final NewsItem item;
  const NewsMasonryCard({super.key, required this.item});

  @override
  State<NewsMasonryCard> createState() => _NewsMasonryCardState();
}

class _NewsMasonryCardState extends State<NewsMasonryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _hovered ? 0.12 : 0.04),
              blurRadius: _hovered ? 16 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: NewsImage(
                        url: widget.item.imageUrl,
                        scale: _hovered ? 1.05 : 1.0,
                        fit: BoxFit.cover,
                        height: 180,
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _hovered ? 1 : 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x99000000)],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _hovered ? const Color(0xFF2563EB) : AppColors.gray900,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(LucideIcons.calendar, size: 12, color: AppColors.gray400),
                        const SizedBox(width: 4),
                        Text(
                          'Новина #${widget.item.id}',
                          style: const TextStyle(fontSize: 11, color: AppColors.gray400),
                        ),
                        const Spacer(),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _hovered ? 1 : 0,
                          child: const Icon(LucideIcons.externalLink, size: 14, color: AppColors.gray400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsMasonryLayout extends StatelessWidget {
  final int columnCount;
  final double columnSpacing;
  final double rowSpacing;
  final List<Widget> children;

  const NewsMasonryLayout({
    super.key,
    required this.columnCount,
    required this.columnSpacing,
    required this.rowSpacing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final columns = List.generate(columnCount, (_) => <Widget>[]);
    for (var i = 0; i < children.length; i++) {
      columns[i % columnCount].add(children[i]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(columnCount * 2 - 1, (i) {
        if (i.isOdd) return SizedBox(width: columnSpacing);
        final col = columns[i ~/ 2];
        return Expanded(
          child: Column(
            children: [
              for (var j = 0; j < col.length; j++) ...[
                col[j],
                if (j < col.length - 1) SizedBox(height: rowSpacing),
              ],
            ],
          ),
        );
      }),
    );
  }
}

// ─── News image with animated scale + fallback ────────────────────────────────

class NewsImage extends StatelessWidget {
  final String url;
  final double scale;
  final BoxFit fit;
  final double? height;

  const NewsImage({
    super.key,
    required this.url,
    this.scale = 1.0,
    this.fit = BoxFit.cover,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return _ImageWithFallback(url: url, fit: fit, height: height, scale: scale);
  }
}

class _ImageWithFallback extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? height;
  final double scale;
  const _ImageWithFallback({required this.url, required this.fit, this.height, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    final h = height ?? 200.0;

    if (url.isEmpty) return _placeholder(h);

    if (kIsWeb) {
      return WebNetworkImage(
        url: url,
        width: double.infinity,
        height: h,
        fit: fit,
        scale: scale,
        placeholder: (_) => Container(
          width: double.infinity,
          height: h,
          color: const Color(0xFFE5E7EB),
        ),
        errorWidget: (_) => _placeholder(h),
      );
    }

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 300),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        width: double.infinity,
        height: h,
        placeholder: (_, __) => Container(
          width: double.infinity,
          height: h,
          color: const Color(0xFFE5E7EB),
        ),
        errorWidget: (_, __, ___) => _placeholder(h),
      ),
    );
  }

  Widget _placeholder(double h) {
    return Container(
      width: double.infinity,
      height: h,
      color: const Color(0xFFF3F4F6),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 32,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}

class NewsSkeletonCard extends StatefulWidget {
  const NewsSkeletonCard({super.key});

  @override
  State<NewsSkeletonCard> createState() => _NewsSkeletonCardState();
}

class _NewsSkeletonCardState extends State<NewsSkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Color.lerp(
                  const Color(0xFFE5E7EB),
                  const Color(0xFFF3F4F6),
                  _anim.value,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.lerp(
                        const Color(0xFFE5E7EB),
                        const Color(0xFFF3F4F6),
                        _anim.value,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Color.lerp(
                        const Color(0xFFE5E7EB),
                        const Color(0xFFF3F4F6),
                        _anim.value,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

