import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:admin_panel/core/services/s3.service.dart';
import 'package:admin_panel/utils/url_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

/// Wraps [S3Service] with convenience methods for
/// picking files from the device and uploading them
/// to cloud storage in a single call.
class ImageUploadService {
  final S3Service _s3;

  ImageUploadService(this._s3);

  // ── Single-image flow ────────────────────────

  /// Opens a file-picker for a single image,
  /// uploads to S3, and returns the public URL.
  ///
  /// Returns `null` if the user cancels the picker.
  Future<String?> pickAndUploadSingle() async {
    final file = await _pickSingleImage();
    if (file == null) return null;
    return uploadFile(file);
  }

  // ── Multi-image flow ─────────────────────────

  /// Opens a file-picker for multiple images,
  /// uploads each to S3 sequentially, and returns
  /// the list of public URLs.
  ///
  /// Returns an empty list when the user cancels.
  Future<List<String>> pickAndUploadMultiple({int? maxFiles}) async {
    final files = await _pickMultipleImages();
    if (files.isEmpty) return const <String>[];

    final selected = maxFiles != null ? files.take(maxFiles).toList() : files;

    final urls = <String>[];
    for (final f in selected) {
      final url = await uploadFile(f);
      urls.add(url);
    }
    return urls;
  }

  // ── Raw upload ───────────────────────────────

  /// Uploads a single [XFile] to S3/R2 and returns
  /// the public URL. Throws on failure.
  Future<String> uploadFile(XFile file) async {
    final key = await _s3.uploadFile(file);
    if (key == null || key.isEmpty) {
      throw Exception('Upload did not return a file key.');
    }
    return formatR2Url(key) ?? key;
  }

  // ── File picking ─────────────────────────────

  Future<XFile?> _pickSingleImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return null;
    }
    return _toXFile(result.files.first);
  }

  Future<List<XFile>> _pickMultipleImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );
    if (result == null) return const <XFile>[];

    return result.files
        .map(_toXFile)
        .whereType<XFile>()
        .toList(growable: false);
  }

  XFile? _toXFile(PlatformFile file) {
    final Uint8List? bytes = file.bytes;
    if (bytes != null) {
      return XFile.fromData(
        bytes,
        name: file.name,
        mimeType: file.extension == null ? null : 'image/${file.extension}',
      );
    }
    final path = file.path;
    if (path == null || path.isEmpty) return null;
    return XFile(path, name: file.name);
  }
}
