/// Result of calling the MoMo payment-creation endpoint.
///
/// The backend calls MoMo's `captureWallet` API and
/// returns the URLs needed to redirect the user.
class MoMoPaymentResult {
  /// Web redirect URL (used as a fallback on platforms
  /// that cannot open the MoMo deep link).
  final String? payUrl;

  /// Native deep link that opens the MoMo app directly.
  final String? deeplink;

  /// QR code URL (optional; requires production permission).
  final String? qrCodeUrl;

  /// MoMo result code — 0 means the initiation
  /// succeeded.
  final int resultCode;

  /// Human-readable result message from MoMo.
  final String message;

  const MoMoPaymentResult({
    this.payUrl,
    this.deeplink,
    this.qrCodeUrl,
    required this.resultCode,
    required this.message,
  });

  /// Whether the payment URL was created successfully.
  bool get isSuccess => resultCode == 0;
}
