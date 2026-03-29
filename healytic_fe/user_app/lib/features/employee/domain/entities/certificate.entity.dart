// Domain entity for employee certificates.
//
// Pure Dart — no Flutter or framework imports.

/// Type of certificate file.
enum CertificateType {
  image,
  pdf,
  unknown;

  /// Infers type from a URL file extension.
  static CertificateType fromUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.endsWith('.pdf')) return CertificateType.pdf;

    const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    for (final ext in imageExtensions) {
      if (lower.contains(ext)) return CertificateType.image;
    }
    return CertificateType.unknown;
  }
}

/// Certificate document belonging to an employee.
class CertificateEntity {
  /// Human-readable certificate name.
  final String name;

  /// S3 URL to the certificate file.
  final String url;

  /// File type (image, pdf, or unknown).
  final CertificateType type;

  const CertificateEntity({
    required this.name,
    required this.url,
    required this.type,
  });
}
