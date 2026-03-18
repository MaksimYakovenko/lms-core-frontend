import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/news/news_service.dart';

enum _ViewMode { grid, list, masonry }

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();

  bool _loading = true;
  String? _error;
  List<NewsItem> _news = [];
  _ViewMode _viewMode = _ViewMode.grid;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _newsService.parseAndSave();
    } catch (_) {
    }
    try {
      final news = await _newsService.getNews();
      if (mounted) setState(() => _news = news);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildViewToggle(),
            const SizedBox(height: 24),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Новини та Оголошення',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Останні події факультету та університету',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        if (!_loading)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_news.length} новин',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildViewToggle() {
    return Row(
      children: [
        _ViewButton(
          icon: LucideIcons.layoutGrid,
          label: 'Сітка',
          active: _viewMode == _ViewMode.grid,
          onTap: () => setState(() => _viewMode = _ViewMode.grid),
        ),
        const SizedBox(width: 8),
        _ViewButton(
          icon: LucideIcons.list,
          label: 'Список',
          active: _viewMode == _ViewMode.list,
          onTap: () => setState(() => _viewMode = _ViewMode.list),
        ),
        const SizedBox(width: 8),
        _ViewButton(
          icon: LucideIcons.layoutDashboard,
          label: 'Масонрі',
          active: _viewMode == _ViewMode.masonry,
          onTap: () => setState(() => _viewMode = _ViewMode.masonry),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) return _buildSkeletons();
    if (_error != null) return _buildError();
    if (_news.isEmpty) return _buildEmpty();

    return switch (_viewMode) {
      _ViewMode.grid => _buildGrid(),
      _ViewMode.list => _buildList(),
      _ViewMode.masonry => _buildMasonry(),
    };
  }

  Widget _buildGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth > 900
          ? 3
          : constraints.maxWidth > 600
              ? 2
              : 1;
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          mainAxisExtent: 320,
        ),
        itemCount: _news.length,
        itemBuilder: (_, i) => _GridCard(item: _news[i]),
      );
    });
  }

  Widget _buildList() {
    return ListView.separated(
      itemCount: _news.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _ListCard(item: _news[i]),
    );
  }

  Widget _buildMasonry() {
    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth > 900
          ? 3
          : constraints.maxWidth > 600
              ? 2
              : 1;
      return SingleChildScrollView(
        child: _MasonryLayout(
          columnCount: cols,
          columnSpacing: 20,
          rowSpacing: 20,
          children: _news.map((item) => _MasonryCard(item: item)).toList(),
        ),
      );
    });
  }

  Widget _buildSkeletons() {
    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth > 900
          ? 3
          : constraints.maxWidth > 600
              ? 2
              : 1;
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          mainAxisExtent: 320,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const _SkeletonCard(),
      );
    });
  }

  Widget _buildEmpty() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(LucideIcons.calendar, size: 32, color: AppColors.gray400),
            ),
            const SizedBox(height: 16),
            const Text(
              'Новин поки немає',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.gray900),
            ),
            const SizedBox(height: 4),
            const Text(
              'Новини та оголошення з\'являться тут',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.circleAlert, size: 48, color: AppColors.red600),
          const SizedBox(height: 16),
          Text(
            _error!,
            style: const TextStyle(color: AppColors.red600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadNews,
            icon: const Icon(LucideIcons.refreshCw),
            label: const Text('Спробувати знову'),
          ),
        ],
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ViewButton({
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

class _GridCard extends StatefulWidget {
  final NewsItem item;
  const _GridCard({required this.item});

  @override
  State<_GridCard> createState() => _GridCardState();
}

class _GridCardState extends State<_GridCard> {
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
              // Image
              SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _NewsImage(
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
              // Content
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

class _ListCard extends StatefulWidget {
  final NewsItem item;
  const _ListCard({required this.item});

  @override
  State<_ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<_ListCard> {
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
              // Image
              SizedBox(
                width: 220,
                child: _NewsImage(
                  url: widget.item.imageUrl,
                  scale: _hovered ? 1.05 : 1.0,
                  height: 160,
                ),
              ),
              // Content
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
          ),  // SizedBox
        ),
      ),
    );
  }
}

class _MasonryCard extends StatefulWidget {
  final NewsItem item;
  const _MasonryCard({required this.item});

  @override
  State<_MasonryCard> createState() => _MasonryCardState();
}

class _MasonryCardState extends State<_MasonryCard> {
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
                      child: _NewsImage(
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

class _MasonryLayout extends StatelessWidget {
  final int columnCount;
  final double columnSpacing;
  final double rowSpacing;
  final List<Widget> children;

  const _MasonryLayout({
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

class _NewsImage extends StatelessWidget {
  final String url;
  final double scale;
  final BoxFit fit;
  final double? height;

  const _NewsImage({
    required this.url,
    this.scale = 1.0,
    this.fit = BoxFit.cover,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 300),
      child: _ImageWithFallback(url: url, fit: fit, height: height),
    );
  }
}

class _ImageWithFallback extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final double? height;
  const _ImageWithFallback({required this.url, required this.fit, this.height});

  @override
  State<_ImageWithFallback> createState() => _ImageWithFallbackState();
}

class _ImageWithFallbackState extends State<_ImageWithFallback> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    final h = widget.height ?? 200.0;

    if (_hasError || widget.url.isEmpty) {
      return _placeholder(h);
    }

    return SizedBox(
      width: double.infinity,
      height: h,
      child: Image.network(
        widget.url,
        fit: widget.fit,
        width: double.infinity,
        height: h,
        errorBuilder: (_, __, ___) {
          Future.microtask(() {
            if (mounted) setState(() => _hasError = true);
          });
          return _placeholder(h);
        },
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _placeholder(h);
        },
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

class _SkeletonCard extends StatefulWidget {
  const _SkeletonCard();

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
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
                color: Color.lerp(const Color(0xFFE5E7EB), const Color(0xFFF3F4F6), _anim.value),
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
                      color: Color.lerp(const Color(0xFFE5E7EB), const Color(0xFFF3F4F6), _anim.value),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Color.lerp(const Color(0xFFE5E7EB), const Color(0xFFF3F4F6), _anim.value),
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
