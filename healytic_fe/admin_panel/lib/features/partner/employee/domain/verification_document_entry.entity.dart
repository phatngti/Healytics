import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_document_entry.entity.freezed.dart';
part 'verification_document_entry.entity.g.dart';

/// A group of verification documents keyed by
/// a field identifier.
///
/// Mirrors the backend `VerificationDocumentEntryDto`
/// structure: each entry has a [fieldKey]
/// (e.g. 'id_card', 'license', 'other_documents')
/// and a list of [documents] within that group.
@Freezed(toJson: true)
abstract class VerificationDocumentEntry with _$VerificationDocumentEntry {
  /// Creates a new [VerificationDocumentEntry].
  ///
  /// - [fieldKey]: Unique key identifying the
  ///   document group (e.g., 'id_card', 'license').
  /// - [documents]: List of documents within
  ///   this group.
  const factory VerificationDocumentEntry({
    required String fieldKey,
    @Default([]) List<DocumentEntry> documents,
  }) = _VerificationDocumentEntry;

  /// Creates from JSON data.
  factory VerificationDocumentEntry.fromJson(Map<String, dynamic> json) =>
      _$VerificationDocumentEntryFromJson(json);
}

/// A single document within a verification group.
///
/// Contains the display [name], the uploaded [url],
/// and an optional [updatedTime] timestamp.
@Freezed(toJson: true)
abstract class DocumentEntry with _$DocumentEntry {
  /// Creates a new [DocumentEntry].
  ///
  /// - [name]: Display name of the document.
  /// - [url]: URL of the uploaded document.
  /// - [updatedTime]: ISO timestamp of the last
  ///   update.
  const factory DocumentEntry({
    required String name,
    required String url,
    String? updatedTime,
  }) = _DocumentEntry;

  /// Creates from JSON data.
  factory DocumentEntry.fromJson(Map<String, dynamic> json) =>
      _$DocumentEntryFromJson(json);
}
