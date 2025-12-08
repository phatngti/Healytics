import 'dart:convert';

import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path/path.dart' as path;
import 'package:universal_io/io.dart' as io;

class FlutterQuillEditor extends StatefulWidget {
  const FlutterQuillEditor({
    super.key,
    this.initialContent,
    this.onChanged,
    this.height = 500,
    this.width = double.infinity,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
  });

  final List<Map<String, Object>>? initialContent;
  final void Function(List<Map<String, dynamic>>)? onChanged;
  final double height;
  final double width;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;

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

    // Listen to document changes and notify parent
    _controller.document.changes.listen((event) {
      if (widget.onChanged != null) {
        final delta = _controller.document.toDelta().toJson();
        widget.onChanged!(delta);
      }
    });
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
            QuillSimpleToolbar(
              controller: _controller,
              config: QuillSimpleToolbarConfig(
                embedButtons: FlutterQuillEmbeds.toolbarButtons(),
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

class TimeStampEmbed extends Embeddable {
  const TimeStampEmbed(String value) : super(timeStampType, value);

  static const String timeStampType = 'timeStamp';

  static TimeStampEmbed fromDocument(Document document) =>
      TimeStampEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

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
