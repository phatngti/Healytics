import 'package:flutter/material.dart';

/// Enum representing accepted MIME types for file uploads.
enum MimeFileTypeAccept {
  png(value: 'image/png'),
  jpg(value: 'image/jpeg'),
  jpeg(value: 'image/jpeg'),
  pdf(value: 'application/pdf'),
  doc(value: 'application/msword'),
  docx(
    value:
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  ),
  txt(value: 'text/plain'),
  other(value: 'application/octet-stream');

  final String value;

  const MimeFileTypeAccept({required this.value});

  /// Creates a [MimeFileTypeAccept] from a file name or extension.
  static MimeFileTypeAccept fromFileName(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return fromExtension(extension);
  }

  /// Creates a [MimeFileTypeAccept] from a file extension (without dot).
  static MimeFileTypeAccept fromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return MimeFileTypeAccept.png;
      case 'jpg':
        return MimeFileTypeAccept.jpg;
      case 'jpeg':
        return MimeFileTypeAccept.jpeg;
      case 'pdf':
        return MimeFileTypeAccept.pdf;
      case 'doc':
        return MimeFileTypeAccept.doc;
      case 'docx':
        return MimeFileTypeAccept.docx;
      case 'txt':
        return MimeFileTypeAccept.txt;
      default:
        return MimeFileTypeAccept.other;
    }
  }
}

/// Display type categories for document files.
enum FileTypeDisplay {
  image,
  pdf,
  doc,
  docx,
  txt,
  other;

  /// Creates a [FileTypeDisplay] from a file name or extension.
  static FileTypeDisplay fromFileName(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return fromExtension(extension);
  }

  /// Creates a [FileTypeDisplay] from a file extension (without dot).
  static FileTypeDisplay fromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
      case 'jpg':
      case 'jpeg':
        return FileTypeDisplay.image;
      case 'pdf':
        return FileTypeDisplay.pdf;
      case 'doc':
        return FileTypeDisplay.doc;
      case 'docx':
        return FileTypeDisplay.docx;
      case 'txt':
        return FileTypeDisplay.txt;
      default:
        return FileTypeDisplay.other;
    }
  }
}

/// Utility class for file type operations including icons and colors.
class FileTypeUtils {
  const FileTypeUtils._();

  /// Returns appropriate icon based on file name or extension.
  static IconData getFileIcon(String fileName) {
    final display = FileTypeDisplay.fromFileName(fileName);
    switch (display) {
      case FileTypeDisplay.pdf:
        return Icons.picture_as_pdf_rounded;
      case FileTypeDisplay.image:
        return Icons.image_rounded;
      case FileTypeDisplay.doc:
      case FileTypeDisplay.docx:
        return Icons.description_rounded;
      case FileTypeDisplay.txt:
        return Icons.text_snippet_rounded;
      case FileTypeDisplay.other:
        return Icons.insert_drive_file_rounded;
    }
  }

  /// Returns appropriate icon color based on file name or extension.
  static Color getFileIconColor(String fileName, ColorScheme colorScheme) {
    final display = FileTypeDisplay.fromFileName(fileName);
    switch (display) {
      case FileTypeDisplay.pdf:
        return Colors.red.shade600;
      case FileTypeDisplay.image:
        return Colors.blue.shade600;
      case FileTypeDisplay.doc:
      case FileTypeDisplay.docx:
        return Colors.indigo.shade600;
      case FileTypeDisplay.txt:
        return Colors.grey.shade600;
      case FileTypeDisplay.other:
        return colorScheme.primary;
    }
  }

  /// Returns MIME type string based on file name or extension.
  static String getMimeType(String fileName) {
    return MimeFileTypeAccept.fromFileName(fileName).value;
  }

  /// Returns display type string based on file name or extension.
  static String getDisplayType(String fileName) {
    return FileTypeDisplay.fromFileName(fileName).name;
  }
}
