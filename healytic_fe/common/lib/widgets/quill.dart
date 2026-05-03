import 'dart:convert';

import 'package:common/utils/demensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path/path.dart' as path;
import 'package:universal_io/io.dart' as io;

/// A rich-text editor widget powered by Flutter Quill.
///
/// Provides a configurable WYSIWYG editing experience with a
/// toolbar, image paste/embed support (web and native), and
/// Delta-based content serialization.
///
/// Toolbar visibility is controlled by [showToolbar] (defaults
/// to `true`). When [readOnly] is `true`, the toolbar is always
/// hidden regardless of [showToolbar]. Pass a custom
/// [toolbarConfig] to override the default toolbar layout.
///
/// Content is stored as a list of Delta JSON objects and can be
/// round-tripped via [initialContent] and [onChanged].
///
/// ```dart
/// FlutterQuillEditor(
///   initialContent: [{'insert': 'Hello World\n'}],
///   onChanged: (delta) => setState(() => _content = delta),
///   height: 300,
///   showToolbar: true,
/// )
/// ```
class FlutterQuillEditor extends StatefulWidget {
  /// Creates a [FlutterQuillEditor].
  ///
  /// - [initialContent] — Pre-populated Delta JSON content.
  /// - [onChanged] — Called with the full Delta JSON on change.
  /// - [height] / [width] — Dimensions of the editor container.
  /// - [readOnly] — When `true`, disables editing.
  /// - [showToolbar] — When `false`, hides the toolbar.
  /// - [toolbarConfig] — Custom toolbar configuration.
  /// - [borderColor] / [borderWidth] / [borderRadius] — Styling.
  const FlutterQuillEditor({
    super.key,
    this.initialContent,
    this.onChanged,
    this.height = 500,
    this.width = double.infinity,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
    this.readOnly = false,
    this.showToolbar = true,
    this.toolbarConfig,
  });

  /// Initial content as a list of Quill Delta JSON maps.
  final List<Map<String, Object>>? initialContent;

  /// Callback fired on every document change with the full Delta JSON.
  final void Function(List<Map<String, dynamic>>)? onChanged;

  /// Height of the editor container in logical pixels.
  final double height;

  /// Width of the editor container in logical pixels.
  final double width;

  /// Border color of the editor container. Defaults to grey.
  final Color? borderColor;

  /// Border width in logical pixels (defaults to 1.0).
  final double borderWidth;

  /// Border radius in logical pixels (defaults to 8.0).
  final double borderRadius;

  /// When `true`, disables editing and hides the toolbar.
  final bool readOnly;

  /// Whether to display the formatting toolbar.
  ///
  /// Defaults to `true`. Has no effect when [readOnly] is
  /// `true` (the toolbar is always hidden in read-only mode).
  final bool showToolbar;

  /// Custom toolbar configuration.
  ///
  /// When `null`, a sensible default configuration is used
  /// with embed buttons, clipboard paste, small button, and
  /// single-row display.
  final QuillSimpleToolbarConfig? toolbarConfig;

  @override
  State<FlutterQuillEditor> createState() => _FlutterQuillEditorState();
}

class _FlutterQuillEditorState extends State<FlutterQuillEditor> {
  @override
  void initState() {
    super.initState();
    // Ensure we have a valid delta - at minimum a newline character
    final content =
        (widget.initialContent == null || widget.initialContent!.isEmpty)
        ? [
            {'insert': '\n'},
          ]
        : widget.initialContent!;
    _controller.document = Document.fromJson(content);
    _controller.readOnly = widget.readOnly;

    // Listen to document changes and notify parent
    _controller.document.changes.listen((event) {
      if (widget.onChanged != null) {
        final delta = _controller.document.toDelta().toJson();
        widget.onChanged!(delta);
      }
    });
  }

  @override
  void didUpdateWidget(FlutterQuillEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.readOnly != oldWidget.readOnly) {
      _controller.readOnly = widget.readOnly;
    }
  }

  final QuillController _controller = () {
    return QuillController.basic(
      config: QuillControllerConfig(
        clipboardConfig: QuillClipboardConfig(
          enableExternalRichPaste: true,
          onImagePaste: (imageBytes) async {
            // --- XỬ LÝ CHO WEB ---
            // Mặc dù universal_io không gây lỗi crash, nhưng trên Web
            // ta vẫn nên dùng Base64 để hiển thị ảnh ngay lập tức.
            if (kIsWeb) {
              final base64String = base64Encode(imageBytes);
              return 'data:image/png;base64,$base64String';
            }

            // --- XỬ LÝ CHO MOBILE / DESKTOP ---
            // Đoạn này dùng 'io' từ gói 'universal_io'.
            // Nó hoạt động y hệt 'dart:io' trên Android/iOS.

            try {
              // 1. Tạo tên file duy nhất
              final newFileName =
                  'image-file-${DateTime.now().toIso8601String()}.png';

              // 2. Lấy đường dẫn thư mục tạm (System Temp)
              final newPath = path.join(
                io.Directory.systemTemp.path,
                newFileName,
              );

              // 3. Ghi file xuống bộ nhớ
              final file = await io.File(
                newPath,
              ).writeAsBytes(imageBytes, flush: true);

              // 4. Trả về đường dẫn file để Quill hiển thị
              return file.path;
            } catch (e) {
              debugPrint("Lỗi khi lưu ảnh: $e");
              return null;
            }
          },
        ),
      ),
    );
  }();

  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: AppDimens.paddingVerticalSmall,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor ?? Colors.grey.shade300,
          width: widget.borderWidth,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Column(
          children: [
            if (!widget.readOnly && widget.showToolbar)
              QuillSimpleToolbar(
                controller: _controller,
                config: widget.toolbarConfig ??
                    QuillSimpleToolbarConfig(
                      embedButtons:
                          FlutterQuillEmbeds.toolbarButtons(),
                      showClipboardPaste: true,
                      showSmallButton: true,
                      multiRowsDisplay: false,
                    ),
              ),
            Expanded(
              child: QuillEditor(
                focusNode: _editorFocusNode,
                scrollController: _editorScrollController,
                controller: _controller,
                config: QuillEditorConfig(
                  placeholder: 'Start writing your notes...',
                  padding: const EdgeInsets.all(16),
                  embedBuilders: kIsWeb
                      ? FlutterQuillEmbeds.editorWebBuilders()
                      : [
                          ...FlutterQuillEmbeds.editorBuilders(
                            imageEmbedConfig: QuillEditorImageEmbedConfig(
                              imageProviderBuilder: (context, imageUrl) {
                                // https://pub.dev/packages/flutter_quill_extensions#-image-assets
                                if (imageUrl.startsWith('assets/')) {
                                  return AssetImage(imageUrl);
                                }
                                return null;
                              },
                            ),
                            videoEmbedConfig: QuillEditorVideoEmbedConfig(
                              customVideoBuilder: (videoUrl, readOnly) {
                                // To load YouTube videos https://github.com/singerdmx/flutter-quill/releases/tag/v10.8.0
                                return null;
                              },
                            ),
                          ),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A custom [Embeddable] that stores a timestamp as a serialized Quill Document.
///
/// The embedded value is the JSON-encoded Delta representation of a [Document].
class TimeStampEmbed extends Embeddable {
  /// Creates a [TimeStampEmbed] with a raw JSON [value].
  const TimeStampEmbed(String value) : super(timeStampType, value);

  /// The embed type identifier used in the Delta.
  static const String timeStampType = 'timeStamp';

  /// Creates a [TimeStampEmbed] from an existing Quill [Document].
  static TimeStampEmbed fromDocument(Document document) =>
      TimeStampEmbed(jsonEncode(document.toDelta().toJson()));

  /// Deserializes the embedded data back into a Quill [Document].
  Document get document => Document.fromJson(jsonDecode(data));
}

/// Builder that renders [TimeStampEmbed] nodes in the Quill editor.
///
/// Displays a clock icon followed by the timestamp text inline.
class TimeStampEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'timeStamp';

  @override
  String toPlainText(Embed node) {
    return node.value.data;
  }

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    return Row(
      children: [
        const Icon(Icons.access_time_rounded),
        Text(embedContext.node.value.data as String),
      ],
    );
  }
}
