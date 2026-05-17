import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_openapi/api.dart';

/// Handles file uploads via S3-compatible presigned
/// URLs (Cloudflare R2 / AWS S3).
class S3Service {
  final ApiService _apiService;
  late final S3Api _s3Api;

  S3Service(this._apiService) {
    _s3Api = S3Api(_apiService.apiClient);
  }

  /// Uploads an [XFile] to S3 using a presigned URL.
  /// Returns the storage [key] of the uploaded file.
  Future<String?> uploadFile(XFile file) async {
    final bytes = await file.readAsBytes();
    final mimeType =
        file.mimeType ?? _resolveMimeType(file.name);

    return uploadBytes(
      fileName: file.name,
      contentType: mimeType,
      bytes: bytes,
    );
  }

  /// Uploads raw [bytes] to S3 using a presigned URL.
  ///
  /// Use this when you already have bytes and
  /// metadata, avoiding [XFile.fromData] pitfalls
  /// on native platforms.
  Future<String?> uploadBytes({
    required String fileName,
    required String contentType,
    required Uint8List bytes,
  }) async {
    try {
      final request = PresignRequestDto(
        fileName: fileName,
        contentType: contentType,
      );

      developer.log(
        'S3 presign request: '
        'fileName=$fileName, '
        'contentType=$contentType',
        name: 'S3Service',
      );

      final response =
          await _s3Api.s3ControllerPreSign(request);

      if (response == null) {
        throw Exception(
          'Failed to get presigned URL.',
        );
      }

      final uploadUrl = response.uploadUrl;
      final key = response.key;

      developer.log(
        'S3 presign OK: key=$key',
        name: 'S3Service',
      );

      final putResponse = await http.put(
        Uri.parse(uploadUrl),
        headers: {'Content-Type': contentType},
        body: bytes,
      );

      if (putResponse.statusCode != 200) {
        throw Exception(
          'Upload failed. '
          'Status: ${putResponse.statusCode}',
        );
      }

      developer.log(
        'S3 upload OK: key=$key',
        name: 'S3Service',
      );

      return key;
    } catch (e) {
      developer.log(
        'S3 Upload Error: $e',
        name: 'S3Service',
        error: e,
      );
      rethrow;
    }
  }

  /// Gets the viewable URL for a file key.
  Future<String?> getFileUrl(String key) async {
    try {
      final response =
          await _s3Api.s3ControllerGetFileUrl(key);
      return response?.url;
    } catch (e) {
      developer.log(
        'S3 GetUrl Error: $e',
        name: 'S3Service',
        error: e,
      );
      return null;
    }
  }

  /// Fallback MIME type resolution from extension.
  String _resolveMimeType(String fileName) {
    final ext =
        fileName.split('.').last.toLowerCase();
    return switch (ext) {
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'svg' => 'image/svg+xml',
      'pdf' => 'application/pdf',
      _ => 'application/octet-stream',
    };
  }
}
