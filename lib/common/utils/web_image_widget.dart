import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class WebNetworkImage extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double scale;
  final Widget Function(BuildContext) placeholder;
  final Widget Function(BuildContext) errorWidget;

  const WebNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.scale = 1.0,
    required this.placeholder,
    required this.errorWidget,
  });

  @override
  State<WebNetworkImage> createState() => _WebNetworkImageState();
}

class _WebNetworkImageState extends State<WebNetworkImage> {
  late final String _viewId;
  bool _hasError = false;
  bool _loaded = false;
  html.ImageElement? _img;

  @override
  void initState() {
    super.initState();
    _viewId = 'web-img-${widget.url.hashCode}-${identityHashCode(this)}';

    if (kIsWeb) {
      ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
        final img = html.ImageElement()
          ..src = widget.url
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.objectFit = _boxFitToCss(widget.fit)
          ..style.display = 'block'
          ..style.margin = '0'
          ..style.padding = '0'
          ..style.border = 'none'
          ..style.transition = 'transform 300ms ease';

        _img = img;

        img.onLoad.listen((_) {
          if (mounted) setState(() => _loaded = true);
        });
        img.onError.listen((_) {
          if (mounted) setState(() => _hasError = true);
        });

        return img;
      });
    }
  }

  @override
  void didUpdateWidget(WebNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Apply scale via CSS transform directly on the <img> element
    if (oldWidget.scale != widget.scale) {
      _img?.style.transform = widget.scale == 1.0
          ? 'scale(1)'
          : 'scale(${widget.scale})';
    }
  }

  String _boxFitToCss(BoxFit fit) {
    return switch (fit) {
      BoxFit.cover => 'cover',
      BoxFit.contain => 'contain',
      BoxFit.fill => 'fill',
      BoxFit.fitWidth => 'contain',
      BoxFit.fitHeight => 'contain',
      BoxFit.none => 'none',
      BoxFit.scaleDown => 'scale-down',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return widget.errorWidget(context);

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 200,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          if (!_loaded) widget.placeholder(context),
          Positioned.fill(
            child: HtmlElementView(viewType: _viewId),
          ),
        ],
      ),
    );
  }
}

