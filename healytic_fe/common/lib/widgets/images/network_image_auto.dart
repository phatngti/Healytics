import 'dart:convert' show utf8;
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A network image widget that auto-detects SVG vs
/// raster URLs and renders accordingly.
///
/// - **SVG** (`.svg` extension or `/svg` path segment):
///   rendered via [SvgPicture.network].
/// - **Raster** (PNG, JPEG, WebP, etc.):
///   rendered via [CachedNetworkImage].
///
/// Provides consistent [placeholder] and [errorWidget]
/// callbacks for both image types.
///
/// ```dart
/// NetworkImageAuto(
///   imageUrl: 'https://example.com/avatar.svg',
///   fit: BoxFit.cover,
///   placeholder: (context) => CircularProgressIndicator(),
///   errorWidget: (context) => Icon(Icons.error),
/// )
/// ```
class NetworkImageAuto extends StatelessWidget {
  /// Creates a [NetworkImageAuto] widget.
  const NetworkImageAuto({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.color,
    this.colorBlendMode,
  });

  /// The network URL to load.
  final String imageUrl;

  /// How the image should fit within its bounds.
  final BoxFit fit;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Builder shown while loading (both SVG and
  /// raster). Receives the current [BuildContext].
  final WidgetBuilder? placeholder;

  /// Builder shown on error (both SVG and
  /// raster). Receives the current [BuildContext].
  final WidgetBuilder? errorWidget;

  /// Optional color overlay applied to the image.
  final Color? color;

  /// Blend mode used with [color].
  final BlendMode? colorBlendMode;

  /// Whether [url] points to an SVG resource.
  ///
  /// Checks for `.svg` extension or `/svg` path
  /// segment (e.g. DiceBear URLs).
  static bool isSvgUrl(String url) {
    final path =
        Uri.tryParse(url)?.path ?? '';
    return path.endsWith('.svg') ||
        path.contains('/svg');
  }

  @override
  Widget build(BuildContext context) {
    // Guard against empty or whitespace-only URLs to
    // prevent CachedNetworkImage from throwing
    // "No host specified in URI".
    if (imageUrl.trim().isEmpty) {
      if (errorWidget != null) {
        return errorWidget!(context);
      }
      return SizedBox(
        width: width,
        height: height,
      );
    }

    if (isSvgUrl(imageUrl)) {
      return SvgPicture(
        _CleanSvgNetworkLoader(imageUrl),
        fit: fit,
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(
                color!,
                colorBlendMode ?? BlendMode.srcIn,
              )
            : null,
        placeholderBuilder: placeholder != null
            ? (_) => placeholder!(context)
            : null,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      placeholder: placeholder != null
          ? (ctx, _) => placeholder!(ctx)
          : null,
      errorWidget: errorWidget != null
          ? (ctx, _, __) => errorWidget!(ctx)
          : null,
    );
  }
}

final _metadataPattern = RegExp(
  r'<metadata[\s>].*?</metadata>',
  dotAll: true,
);

/// Fetches an SVG from the network and strips `<metadata>` elements
/// that the vector_graphics_compiler cannot handle.
class _CleanSvgNetworkLoader extends SvgNetworkLoader {
  const _CleanSvgNetworkLoader(super.url);

  @override
  String provideSvg(Uint8List? message) {
    final raw = utf8.decode(message!, allowMalformed: true);
    return raw.replaceAll(_metadataPattern, '');
  }
}
