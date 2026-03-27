import 'dart:developer' as developer;

import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class S3Service {
  final ApiService _apiService;
  late final S3Api _s3Api;

  S3Service(this._apiService) {
    _s3Api = S3Api(_apiService.apiClient);
  }

  /// Uploads a file to S3 (or compatible storage like Cloudflare R2) using a presigned URL.
  /// returns the [key] of the uploaded file.
  Future<String?> uploadFile(XFile file) async {
    try {
      // 1. Read file bytes
      final bytes = await file.readAsBytes();

      // 2. Get mime type
      final mimeType =
          lookupMimeType(file.name, headerBytes: bytes) ??
          'application/octet-stream';
      final fileName = file.name;

      // 3. Get presigned URL
      final request = PresignRequestDto(
        fileName: fileName,
        contentType: mimeType,
      );

      final response = await _s3Api.s3ControllerPreSign(request);
      developer.log('S3 Upload Response: $response', name: 'S3Service');

      if (response == null) {
        throw Exception('Failed to get presigned URL from server.');
      }

      final uploadUrl = response.uploadUrl;
      final key = response.key;

      // 4. Upload to S3/R2
      final putResponse = await http.put(
        Uri.parse(uploadUrl),
        headers: {'Content-Type': mimeType},
        body: bytes,
      );

      if (putResponse.statusCode != 200) {
        throw Exception(
          'Failed to upload file to storage. Status: ${putResponse.statusCode}, Body: ${putResponse.body}',
        );
      }

      return key;
    } catch (e) {
      developer.log('S3 Upload Error: $e', name: 'S3Service', error: e);
      rethrow;
    }
  }

  /// Gets the viewable URL for a file key from the backend.
  Future<String?> getFileUrl(String key) async {
    try {
      final response = await _s3Api.s3ControllerGetFileUrl(key);
      return response?.url;
    } catch (e) {
      developer.log('S3 GetUrl Error: $e', name: 'S3Service', error: e);
      return null;
    }
  }
}
