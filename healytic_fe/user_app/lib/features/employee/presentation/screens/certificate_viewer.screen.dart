import 'dart:io';

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';

import 'package:user_app/features/employee/domain/entities/certificate.entity.dart';

/// Full-screen viewer for a single certificate.
///
/// - **Images**: Displayed inline with pinch-to-zoom
///   via [InteractiveViewer].
/// - **PDFs**: Rendered in-app via [PDFView] after
///   downloading to a temp file.
class CertificateViewerScreen extends StatelessWidget {
  const CertificateViewerScreen({
    super.key,
    required this.name,
    required this.url,
    required this.type,
  });

  final String name;
  final String url;
  final CertificateType type;

  @override
  Widget build(BuildContext context) {
    final isPdf = type != CertificateType.image;
    final bg = isPdf ? Theme.of(context).colorScheme.surface : Colors.black;

    return Scaffold(
      backgroundColor: bg,
      appBar: _buildAppBar(context, isPdf: isPdf),
      body: switch (type) {
        CertificateType.image => _ImageViewer(url: url),
        CertificateType.pdf => _PdfViewer(url: url),
        CertificateType.unknown => _PdfViewer(url: url),
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, {bool isPdf = false}) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final fgColor = isPdf ? colorScheme.onSurface : Colors.white;
    final bgColor = isPdf
        ? colorScheme.surface
        : Colors.black.withValues(alpha: 0.8);

    return AppBar(
      title: Text(
        name,
        style: textTheme.titleSmall?.copyWith(
          color: fgColor,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      backgroundColor: bgColor,
      iconTheme: IconThemeData(color: fgColor),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
      ),
    );
  }
}

// ─── Image viewer with zoom ────────────────────────

class _ImageViewer extends StatelessWidget {
  const _ImageViewer({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: _loadingBuilder,
          errorBuilder: _errorBuilder,
        ),
      ),
    );
  }

  Widget _loadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;

    final progress = loadingProgress.expectedTotalBytes != null
        ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
        : null;

    return Center(
      child: CircularProgressIndicator(value: progress, color: Colors.white),
    );
  }

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.broken_image,
            size: AppDimens.iconXxl,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          AppDimens.verticalMedium,
          Text(
            'Unable to load image',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

// ─── In-app PDF viewer ─────────────────────────────

class _PdfViewer extends StatefulWidget {
  const _PdfViewer({required this.url});

  final String url;

  @override
  State<_PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<_PdfViewer> {
  static final _log = Logger('PdfViewer');

  String? _localPath;
  bool _isLoading = true;
  String? _error;
  int _totalPages = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    try {
      final response = await http.get(Uri.parse(widget.url));

      if (response.statusCode != 200) {
        throw HttpException('HTTP ${response.statusCode}');
      }

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/'
        'cert_${DateTime.now().millisecondsSinceEpoch}'
        '.pdf',
      );
      await file.writeAsBytes(response.bodyBytes);

      if (mounted) {
        setState(() {
          _localPath = file.path;
          _isLoading = false;
        });
      }
    } catch (e, s) {
      _log.severe('Failed to download PDF', e, s);
      if (mounted) {
        setState(() {
          _error = 'Could not load PDF';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildLoading();
    if (_error != null) return _buildError();
    return _buildPdf();
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: AppDimens.spaceLg),
          Text('Loading PDF...', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.error_outline,
            size: AppDimens.iconXxl,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          AppDimens.verticalMedium,
          Text(
            _error!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          AppDimens.verticalLarge,
          FilledButton.icon(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _error = null;
              });
              _downloadPdf();
            },
            icon: const Icon(Symbols.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPdf() {
    return Stack(
      children: [
        PDFView(
          filePath: _localPath!,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          pageSnap: true,
          fitPolicy: FitPolicy.BOTH,
          nightMode: false,
          onRender: (pages) {
            if (mounted) {
              setState(() => _totalPages = pages ?? 0);
            }
          },
          onPageChanged: (page, _) {
            if (mounted && page != null) {
              setState(() => _currentPage = page);
            }
          },
          onError: (error) {
            _log.severe('PDF render error: $error');
          },
        ),
        if (_totalPages > 1)
          Positioned(
            bottom: AppDimens.spaceLg,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                  vertical: AppDimens.spaceXs,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.inverseSurface.withValues(alpha: 0.7),
                  borderRadius: AppDimens.radiusMediumSmall,
                ),
                child: Text(
                  '${_currentPage + 1} / '
                  '$_totalPages',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
