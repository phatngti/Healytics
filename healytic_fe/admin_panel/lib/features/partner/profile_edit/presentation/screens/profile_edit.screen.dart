import 'dart:convert';

import 'package:admin_panel/core/providers/image_upload.provider.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/branding_section.widget.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/certifications_section.widget.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/description_section.widget.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/gallery_section.widget.dart';
import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.entity.dart';
import 'package:admin_panel/features/partner/profile_edit/presentation/providers/public_profile_edit.provider.dart';
import 'package:admin_panel/features/partner/profile_edit/presentation/widgets/address_card.widget.dart';
import 'package:admin_panel/features/partner/profile_edit/presentation/widgets/business_overview_card.widget.dart';
import 'package:admin_panel/features/partner/profile_edit/presentation/widgets/completion_sidebar.widget.dart';
import 'package:admin_panel/features/partner/profile_edit/presentation/widgets/contact_card.widget.dart';
import 'package:admin_panel/features/partner/profile_edit/presentation/widgets/legal_summary_card.widget.dart';
import 'package:admin_panel/features/partner/profile_edit/presentation/widgets/save_discard_bar.widget.dart';
import 'package:admin_panel/features/partner/profile_edit/presentation/widgets/verification_badge.widget.dart';
import 'package:admin_panel/features/partner/profile_completion/domain/profile_completion.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:common/widgets/quill.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Partner public profile edit screen.
///
/// Two-column layout: left column for read-only
/// and editable sections, right rail for status,
/// completion, and legal summary.
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  static const int _minDescLength = 120;
  static const int _maxDescLength = 1000;
  static const int _minGalleryImages = 3;
  static const int _maxGalleryImages = 8;

  /// Dialog width for certification add/edit.
  static const double _kDialogWidth = 420;

  /// Dialog width for description editor.
  ///
  /// Made wider to accommodate the Quill toolbar.
  static const double _kDescDialogWidth = 560;

  /// Bottom bar height for scroll padding.
  static const double _kBottomBarHeight = 80;

  /// Two-column breakpoint.
  static const double _kWideBreakpoint = 1024;

  /// Max content width.
  static const double _kMaxContentWidth = 1200;

  /// Right rail width.
  static const double _kRailWidth = 340;

  /// Raw description stored as Quill Delta JSON string.
  ///
  /// Falls back to plain text when the stored value
  /// is not valid JSON.
  String _descRaw = '';

  bool _didHydrate = false;
  bool _isSaving = false;
  bool _isUploadingCover = false;
  bool _isUploadingLogo = false;
  bool _isUploadingGallery = false;
  bool _showValidationErrors = false;

  // Local draft state
  String? _coverImageUrl;
  String? _logoImageUrl;
  List<String> _gallery = <String>[];
  List<PublicProfileCertification> _certifications =
      <PublicProfileCertification>[];

  @override
  void dispose() {
    super.dispose();
  }

  // ── Computed properties ──────────────────────

  /// Extracts plain text from the stored Quill Delta
  /// JSON for length validation and display.
  String get _trimmedDesc => _getPlainTextFromDesc(_descRaw);

  bool get _hasCover =>
      _coverImageUrl != null && _coverImageUrl!.trim().isNotEmpty;

  bool get _hasLogo =>
      _logoImageUrl != null && _logoImageUrl!.trim().isNotEmpty;

  bool get _isDescValid =>
      _trimmedDesc.length >= _minDescLength &&
      _trimmedDesc.length <= _maxDescLength;

  bool get _isGalleryValid =>
      _gallery.length >= _minGalleryImages &&
      _gallery.length <= _maxGalleryImages;

  bool get _isProfilePublishable =>
      _hasCover && _hasLogo && _isDescValid && _isGalleryValid;

  // ── Hydration ────────────────────────────────

  void _hydrateFrom(PublicProfileStorefront sf, {bool overwrite = false}) {
    if (_didHydrate && !overwrite) return;

    _coverImageUrl = sf.coverImageUrl;
    _logoImageUrl = sf.logoImageUrl;
    _gallery = List<String>.from(sf.gallery);
    _certifications = List.from(sf.certifications);
    _descRaw = sf.description ?? '';
    _didHydrate = true;
  }

  /// Pushes current local state to the notifier
  /// draft so dirty-checking works.
  void _syncDraft() {
    final notifier = ref.read(publicProfileEditProvider.notifier);
    notifier.updateDraft(
      PublicProfileStorefront(
        coverImageUrl: _coverImageUrl?.trim(),
        logoImageUrl: _logoImageUrl?.trim(),
        description: _descRaw,
        gallery: List<String>.from(_gallery),
        certifications: _normalize(_certifications),
      ),
    );
  }

  List<PublicProfileCertification> _normalize(
    List<PublicProfileCertification> items,
  ) {
    return items
        .asMap()
        .entries
        .map((e) => e.value.copyWith(sortOrder: e.key))
        .toList();
  }

  // ── Actions ──────────────────────────────────

  Future<void> _save() async {
    if (_isSaving) return;
    _syncDraft();

    if (!_isProfilePublishable) {
      setState(() => _showValidationErrors = true);
      _snack(
        'Complete cover, logo, description, and gallery before saving.',
        isError: true,
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final result = await ref.read(publicProfileEditProvider.notifier).save();

      if (!mounted) return;
      setState(() {
        _hydrateFrom(result.storefront, overwrite: true);
        _showValidationErrors = false;
      });
      _snack('Profile saved successfully.');
    } catch (e) {
      _snack('Could not save profile: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _discard() {
    ref.read(publicProfileEditProvider.notifier).discard();

    final current = ref.read(publicProfileEditProvider).asData?.value;
    if (current == null || !mounted) return;

    setState(() {
      _hydrateFrom(current.storefront, overwrite: true);
      _showValidationErrors = false;
    });
    _snack('Changes discarded.');
  }

  // ── Image upload helpers ─────────────────────

  Future<void> _uploadSingleImage({required bool isCover}) async {
    setState(() {
      if (isCover) {
        _isUploadingCover = true;
      } else {
        _isUploadingLogo = true;
      }
    });

    try {
      final uploader = ref.read(imageUploadServiceProvider);
      final url = await uploader.pickAndUploadSingle();
      if (url == null) return;

      if (!mounted) return;
      setState(() {
        if (isCover) {
          _coverImageUrl = url;
        } else {
          _logoImageUrl = url;
        }
      });
      _syncDraft();
    } catch (e) {
      _snack('Image upload failed: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          if (isCover) {
            _isUploadingCover = false;
          } else {
            _isUploadingLogo = false;
          }
        });
      }
    }
  }

  Future<void> _uploadGalleryImages() async {
    if (_gallery.length >= _maxGalleryImages) {
      _snack(
        'You can upload up to '
        '$_maxGalleryImages gallery images.',
        isError: true,
      );
      return;
    }

    setState(() => _isUploadingGallery = true);

    try {
      final slots = _maxGalleryImages - _gallery.length;
      final uploader = ref.read(imageUploadServiceProvider);
      final urls = await uploader.pickAndUploadMultiple(maxFiles: slots);
      if (urls.isEmpty) return;

      if (!mounted) return;
      setState(() {
        _gallery = [..._gallery, ...urls];
      });
      _syncDraft();
    } catch (e) {
      _snack('Gallery upload failed: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isUploadingGallery = false);
      }
    }
  }

  // ── Gallery mutations ────────────────────────

  void _removeGalleryImage(int index) {
    setState(() {
      _gallery = [..._gallery]..removeAt(index);
    });
    _syncDraft();
  }

  void _moveGalleryImage(int index, int direction) {
    final target = index + direction;
    if (target < 0 || target >= _gallery.length) {
      return;
    }

    setState(() {
      final next = [..._gallery];
      final item = next.removeAt(index);
      next.insert(target, item);
      _gallery = next;
    });
    _syncDraft();
  }

  // ── Certification mutations ──────────────────

  Future<void> _addCertification() async {
    final item = await _showCertificationDialog();
    if (item == null) return;

    setState(() {
      _certifications = _normalize([
        ..._certifications,
        item.copyWith(sortOrder: _certifications.length),
      ]);
    });
    _syncDraft();
  }

  Future<void> _editCertification(int index) async {
    final item = await _showCertificationDialog(
      initial: _certifications[index],
    );
    if (item == null) return;

    setState(() {
      final next = [..._certifications];
      next[index] = item.copyWith(id: _certifications[index].id);
      _certifications = _normalize(next);
    });
    _syncDraft();
  }

  void _deleteCertification(int index) {
    setState(() {
      final next = [..._certifications]..removeAt(index);
      _certifications = _normalize(next);
    });
    _syncDraft();
  }

  void _moveCertification(int index, int direction) {
    final target = index + direction;
    if (target < 0 || target >= _certifications.length) {
      return;
    }

    setState(() {
      final next = [..._certifications];
      final item = next.removeAt(index);
      next.insert(target, item);
      _certifications = _normalize(next);
    });
    _syncDraft();
  }

  Future<PublicProfileCertification?> _showCertificationDialog({
    PublicProfileCertification? initial,
  }) async {
    final titleCtrl = TextEditingController(text: initial?.title ?? '');
    final subtitleCtrl = TextEditingController(text: initial?.subtitle ?? '');
    var selectedIcon =
        initial?.iconName ?? CertificationsSectionWidget.iconOptions.keys.first;

    final result = await showDialog<PublicProfileCertification>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isValid = titleCtrl.text.trim().isNotEmpty;

            return AlertDialog(
              title: Text(
                initial == null ? 'Add certification' : 'Edit certification',
              ),
              content: SizedBox(
                width: _kDialogWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'ISO 9001:2015',
                      ),
                      maxLength: 200,
                    ),
                    AppDimens.verticalMediumSmall,
                    TextField(
                      controller: subtitleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Subtitle',
                        hintText: 'Quality management',
                      ),
                      maxLength: 200,
                    ),
                    AppDimens.verticalMediumSmall,
                    DropdownButtonFormField<String>(
                      initialValue: selectedIcon,
                      decoration: const InputDecoration(
                        labelText: 'Badge icon',
                      ),
                      items: CertificationsSectionWidget.iconOptions.entries
                          .map((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Row(
                                children: [
                                  Icon(entry.value, size: AppDimens.iconSmMd),
                                  AppDimens.horizontalMediumSmall,
                                  Text(_formatName(entry.key)),
                                ],
                              ),
                            );
                          })
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          selectedIcon = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: !isValid
                      ? null
                      : () {
                          final sub = subtitleCtrl.text.trim();
                          Navigator.of(context).pop(
                            PublicProfileCertification(
                              id: initial?.id,
                              title: titleCtrl.text.trim(),
                              subtitle: sub.isEmpty ? null : sub,
                              iconName: selectedIcon,
                              sortOrder:
                                  initial?.sortOrder ?? _certifications.length,
                            ),
                          );
                        },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    titleCtrl.dispose();
    subtitleCtrl.dispose();
    return result;
  }

  Future<void> _editDescription() async {
    final initialContent = _tryParseQuillContent(_descRaw);
    // Tracks the latest Delta JSON from the editor.
    String? latestDeltaJson = _descRaw;
    int latestPlainLength = _trimmedDesc.length;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isValid =
                latestPlainLength >= _minDescLength &&
                latestPlainLength <= _maxDescLength;

            return AlertDialog(
              title: const Text('Clinic description'),
              content: SizedBox(
                width: _kDescDialogWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write a concise, '
                      'patient-friendly '
                      'description covering '
                      'specialties and care.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppDimens.verticalMedium,
                    FlutterQuillEditor(
                      initialContent: initialContent,
                      height: 300,
                      onChanged: (delta) {
                        final encoded = jsonEncode(delta);
                        final plain = _getPlainTextFromDesc(encoded);
                        setState(() {
                          latestDeltaJson = encoded;
                          latestPlainLength = plain.length;
                        });
                      },
                    ),
                    AppDimens.verticalSmall,
                    Text(
                      '$latestPlainLength/'
                      '$_minDescLength min',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (latestPlainLength > 0 && !isValid)
                      Padding(
                        padding: const EdgeInsets.only(top: AppDimens.spaceXxs),
                        child: Text(
                          'At least '
                          '$_minDescLength '
                          'characters.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: !isValid
                      ? null
                      : () => Navigator.of(context).pop(latestDeltaJson),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null || !mounted) return;
    setState(() {
      _descRaw = result;
    });
    _syncDraft();
  }

  // ── Helpers ──────────────────────────────────

  void _snack(String message, {bool isError = false}) {
    if (!mounted) return;
    final cs = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? cs.error : cs.primary,
      ),
    );
  }

  String _formatName(String value) {
    return value
        .split('_')
        .where((p) => p.isNotEmpty)
        .map(
          (p) =>
              '${p[0].toUpperCase()}'
              '${p.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  /// Parses a raw description (Quill Delta JSON or
  /// plain text) into a Delta ops list suitable for
  /// [FlutterQuillEditor.initialContent].
  ///
  /// Returns `null` when the value is empty.
  /// Non-JSON strings are wrapped as plain-text Delta.
  static List<Map<String, Object>>? _tryParseQuillContent(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List && decoded.isNotEmpty) {
        return decoded.map((e) => Map<String, Object>.from(e as Map)).toList();
      }
      return null;
    } on FormatException {
      // Not JSON — wrap as plain-text Delta.
      return <Map<String, Object>>[
        {'insert': '$raw\n'},
      ];
    }
  }

  /// Extracts trimmed plain text from a raw
  /// description that may be Quill Delta JSON or
  /// a legacy plain-text string.
  static String _getPlainTextFromDesc(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List && decoded.isNotEmpty) {
        final buf = StringBuffer();
        for (final op in decoded) {
          if (op is Map && op['insert'] is String) {
            buf.write(op['insert'] as String);
          }
        }
        return buf.toString().trim();
      }
      return raw.trim();
    } on FormatException {
      return raw.trim();
    }
  }

  /// Bridges from [PublicProfileCertification]
  /// to [PartnerCertificationItem] used by the
  /// shared certifications widget.
  List<PartnerCertificationItem> _toCertItems() {
    return _certifications
        .map(
          (c) => PartnerCertificationItem(
            id: c.id,
            title: c.title,
            subtitle: c.subtitle,
            iconName: c.iconName,
            sortOrder: c.sortOrder,
          ),
        )
        .toList();
  }

  // ── Build ────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(publicProfileEditProvider);
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return asyncData.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: Center(
          child: Padding(
            padding: AppDimens.paddingAllLarge,
            child: ErrorCard(
              title: 'Failed to load public profile',
              error: error,
              stackTrace: stackTrace,
              onRetry: () => ref.invalidate(publicProfileEditProvider),
            ),
          ),
        ),
      ),
      data: (entity) {
        _hydrateFrom(entity.storefront);

        final notifier = ref.read(publicProfileEditProvider.notifier);
        final isDirty = notifier.isDirty;

        return Scaffold(
          backgroundColor: isDark ? cs.surfaceDim : cs.surface,
          appBar: AppBar(title: const Text('Edit Profile')),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppDimens.spaceXxl,
                  AppDimens.spaceXxl,
                  AppDimens.spaceXxl,
                  isDirty || _isSaving ? _kBottomBarHeight : AppDimens.spaceXxl,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _kMaxContentWidth,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= _kWideBreakpoint;

                        final leftColumn = _buildLeftColumn(entity);
                        final rightRail = _buildRightRail(entity);

                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: leftColumn),
                              AppDimens.horizontalLargeExtra,
                              SizedBox(width: _kRailWidth, child: rightRail),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            rightRail,
                            AppDimens.verticalLarge,
                            leftColumn,
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: SaveDiscardBarWidget(
                  isDirty: isDirty,
                  isSaving: _isSaving,
                  onDiscard: _discard,
                  onSave: _save,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeftColumn(PartnerPublicProfileEntity entity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BusinessOverviewCardWidget(info: entity.businessInfo),
        AppDimens.verticalLarge,
        AddressCardWidget(address: entity.address),
        AppDimens.verticalLarge,
        ContactCardWidget(info: entity.businessInfo),
        AppDimens.verticalLarge,
        BrandingSectionWidget(
          coverImageUrl: _coverImageUrl,
          logoImageUrl: _logoImageUrl,
          isUploadingCover: _isUploadingCover,
          isUploadingLogo: _isUploadingLogo,
          showValidationErrors: _showValidationErrors,
          hasCoverImage: _hasCover,
          hasLogoImage: _hasLogo,
          onUploadCover: () => _uploadSingleImage(isCover: true),
          onUploadLogo: () => _uploadSingleImage(isCover: false),
          onRemoveCover: _hasCover
              ? () {
                  setState(() => _coverImageUrl = null);
                  _syncDraft();
                }
              : null,
          onRemoveLogo: _hasLogo
              ? () {
                  setState(() => _logoImageUrl = null);
                  _syncDraft();
                }
              : null,
        ),
        AppDimens.verticalLarge,
        DescriptionSectionWidget(
          description: _trimmedDesc,
          showValidationErrors: _showValidationErrors,
          isDescriptionValid: _isDescValid,
          trimmedLength: _trimmedDesc.length,
          minLength: _minDescLength,
          maxLength: _maxDescLength,
          onEdit: _editDescription,
        ),
        AppDimens.verticalLarge,
        GallerySectionWidget(
          gallery: _gallery,
          isUploadingGallery: _isUploadingGallery,
          showValidationErrors: _showValidationErrors,
          isGalleryValid: _isGalleryValid,
          minImages: _minGalleryImages,
          maxImages: _maxGalleryImages,
          onAddImages: _uploadGalleryImages,
          onRemoveImage: _removeGalleryImage,
          onMoveImage: _moveGalleryImage,
        ),
        AppDimens.verticalLarge,
        CertificationsSectionWidget(
          certifications: _toCertItems(),
          onAdd: _addCertification,
          onEdit: _editCertification,
          onDelete: _deleteCertification,
          onMove: _moveCertification,
        ),
      ],
    );
  }

  Widget _buildRightRail(PartnerPublicProfileEntity entity) {
    return Column(
      children: [
        VerificationBadgeWidget(status: entity.verificationStatus),
        AppDimens.verticalMedium,
        CompletionSidebarWidget(summary: entity.completionSummary),
        AppDimens.verticalMedium,
        LegalSummaryCardWidget(summary: entity.legalSummary),
      ],
    );
  }
}
