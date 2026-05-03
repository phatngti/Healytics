String sanitizeUrl(String url) {
  final urlWithSchema = url.trimLeft().startsWith(RegExp(r"https?://"))
      ? url
      : "https://$url";
  return urlWithSchema.trimRight().replaceFirst(RegExp(r"/+$"), "");
}
