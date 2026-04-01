import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/features/news/news_components.dart';
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
    } catch (_) {}
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
            children: const [
              Text(
                'Новини та Оголошення',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray900,
                ),
              ),
              SizedBox(height: 4),
              Text(
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
        NewsViewButton(
          icon: LucideIcons.layoutGrid,
          label: 'Сітка',
          active: _viewMode == _ViewMode.grid,
          onTap: () => setState(() => _viewMode = _ViewMode.grid),
        ),
        const SizedBox(width: 8),
        NewsViewButton(
          icon: LucideIcons.list,
          label: 'Список',
          active: _viewMode == _ViewMode.list,
          onTap: () => setState(() => _viewMode = _ViewMode.list),
        ),
        const SizedBox(width: 8),
        NewsViewButton(
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
        itemBuilder: (_, i) => NewsGridCard(item: _news[i]),
      );
    });
  }

  Widget _buildList() {
    return ListView.separated(
      itemCount: _news.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => NewsListCard(item: _news[i]),
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
        child: NewsMasonryLayout(
          columnCount: cols,
          columnSpacing: 20,
          rowSpacing: 20,
          children: _news.map((item) => NewsMasonryCard(item: item)).toList(),
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
        itemBuilder: (_, __) => const NewsSkeletonCard(),
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.gray900,
              ),
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

