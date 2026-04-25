import 'dart:convert';

import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/image_upload.provider.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:admin_panel/features/common/providers/authen_token.provider.dart';
import 'package:admin_panel/features/partner/profile_completion/domain/profile_completion.entity.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/providers/profile_completion.provider.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/branding_section.widget.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/certifications_section.widget.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/clinic_identity_card.widget.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/completion_bottom_bar.widget.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/description_section.widget.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/gallery_section.widget.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/progress_hero.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:common/widgets/quill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Partner profile completion screen orchestrator.
///
/// Composes decomposed section widgets and delegates
/// all data operations to [ProfileCompletionNotifier].
class ProfileCompletionScreen extends ConsumerStatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  ConsumerState<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState
    extends ConsumerState<ProfileCompletionScreen> {
  static const int _minDescLength = 120;
  static const int _maxDescLength = 100000000;
  static const int _minGalleryImages = 3;
  static const int _maxGalleryImages = 8;

  /// Dialog width for certification add/edit.
  static const double _kDialogWidth = 420;

  /// Dialog width for description editor.
  ///
  /// Made wider to accommodate the Quill toolbar.
  static const double _kDescDialogWidth = 560;

  /// Bottom bar height for scroll padding.
  static const double _kBottomBarHeight = 132;

  /// Max content width for the main content area.
  static const double _kMaxContentWidth = 1100;

  /// Raw description stored as Quill Delta JSON string.
  ///
  /// Falls back to plain text when the stored value
  /// is not valid JSON.
  String _descRaw = '';

  bool _didHydrate = false;
  bool _showValidation = false;
  bool _isSavingDraft = false;
  bool _isCompleting = false;
  bool _isUploadingCover = false;
  bool _isUploadingLogo = false;
  bool _isUploadingGallery = false;

  String? _coverImageUrl;
  String? _logoImageUrl;
  List<String> _gallery = <String>[];
  List<PartnerCertificationItem> _certifications = <PartnerCertificationItem>[];

  // ── Lifecycle ────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.invalidate(profileCompletionProvider);
      }
    });
  }

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

  bool get _isReadyToComplete =>
      _hasCover && _hasLogo && _isDescValid && _isGalleryValid;

  List<CompletionChecklistItem> get _checklist {
    return [
      CompletionChecklistItem(
        key: 'coverImageUrl',
        label: 'Clinic cover image',
        isRequired: true,
        completed: _hasCover,
      ),
      CompletionChecklistItem(
        key: 'logoImageUrl',
        label: 'Clinic logo image',
        isRequired: true,
        completed: _hasLogo,
      ),
      CompletionChecklistItem(
        key: 'description',
        label: 'Clinic description',
        isRequired: true,
        completed: _isDescValid,
      ),
      CompletionChecklistItem(
        key: 'gallery',
        label: 'Clinic gallery',
        isRequired: true,
        completed: _isGalleryValid,
      ),
      CompletionChecklistItem(
        key: 'certifications',
        label: 'Trust badges and certifications',
        isRequired: false,
        completed: _certifications.isNotEmpty,
      ),
    ];
  }

  int get _completionPercent {
    final items = _checklist;
    return ((items.where((i) => i.completed).length / items.length) * 100)
        .round();
  }

  int get _requiredDoneCount =>
      _checklist.where((i) => i.isRequired && i.completed).length;

  // ── Hydration ────────────────────────────────

  void _hydrateFrom(
    PartnerProfileCompletionEntity entity, {
    bool overwrite = false,
  }) {
    if (_didHydrate && !overwrite) return;

    _coverImageUrl = entity.coverImageUrl;
    _logoImageUrl = entity.logoImageUrl;
    _gallery = List<String>.from(entity.gallery);
    _certifications = _normalize(entity.certifications);
    _descRaw = entity.description ?? '';
    _didHydrate = true;
  }

  List<PartnerCertificationItem> _normalize(
    List<PartnerCertificationItem> items,
  ) {
    return items
        .asMap()
        .entries
        .map((e) => e.value.copyWith(sortOrder: e.key))
        .toList();
  }

  PartnerProfileCompletionUpdateRequest _buildRequest() {
    return PartnerProfileCompletionUpdateRequest(
      coverImageUrl: _coverImageUrl?.trim(),
      logoImageUrl: _logoImageUrl?.trim(),
      description: _descRaw,
      gallery: List<String>.from(_gallery),
      certifications: _normalize(_certifications),
    );
  }

  // ── Actions ──────────────────────────────────

  Future<void> _logout() async {
    await ref.read(authenTokenProvider.notifier).removeToken();
    await Store.delete(StoreKey.accessToken);
    await Store.delete(StoreKey.refreshToken);
    await UserRoleHelper.clearPartnerFlags();
    if (mounted) context.go('/');
  }

  Future<void> _saveDraft() async {
    if (_isSavingDraft || _isCompleting) return;
    setState(() => _isSavingDraft = true);

    try {
      final result = await ref
          .read(profileCompletionProvider.notifier)
          .saveDraft(_buildRequest());

      if (!mounted) return;
      setState(() => _hydrateFrom(result, overwrite: true));
      _snack(
        result.isCompleted
            ? 'Draft saved. Your profile is '
                  'ready to complete.'
            : 'Draft saved.',
      );
    } catch (e) {
      _snack('Could not save draft: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSavingDraft = false);
      }
    }
  }

  Future<void> _completeProfile() async {
    if (_isSavingDraft || _isCompleting) return;
    setState(() => _showValidation = true);

    if (!_isReadyToComplete) {
      _snack(
        'Complete the required branding, '
        'description, and gallery fields first.',
        isError: true,
      );
      return;
    }

    setState(() => _isCompleting = true);

    try {
      final result = await ref
          .read(profileCompletionProvider.notifier)
          .completeProfile(_buildRequest());

      if (!mounted) return;
      setState(() => _hydrateFrom(result, overwrite: true));

      if (result.isCompleted && UserRoleHelper.isProviderProfileCompleted()) {
        context.go('/provider/dashboard');
        return;
      }

      _snack(
        'Profile saved, but completion is '
        'still pending. Check the required '
        'items again.',
        isError: true,
      );
    } catch (e) {
      _snack('Could not complete profile: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isCompleting = false);
      }
    }
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
  }

  void _deleteCertification(int index) {
    setState(() {
      final next = [..._certifications]..removeAt(index);
      _certifications = _normalize(next);
    });
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
  }

  Future<PartnerCertificationItem?> _showCertificationDialog({
    PartnerCertificationItem? initial,
  }) async {
    final titleCtrl = TextEditingController(text: initial?.title ?? '');
    final subtitleCtrl = TextEditingController(text: initial?.subtitle ?? '');
    var selectedIcon =
        initial?.iconName ?? CertificationsSectionWidget.iconOptions.keys.first;

    final result = await showDialog<PartnerCertificationItem>(
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
                            PartnerCertificationItem(
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
    String? latestDeltaJson;
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
  }

  // ── Utilities ────────────────────────────────

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

  // ── Build ────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(profileCompletionProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen(profileCompletionProvider, (previous, next) {
      final entity = next.asData?.value;
      if (entity == null || !mounted) return;
      if (entity.isCompleted && UserRoleHelper.isProviderProfileCompleted()) {
        context.go('/provider/dashboard');
      }
    });

    return asyncData.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('Complete Clinic Profile')),
        body: Center(
          child: Padding(
            padding: AppDimens.paddingAllLarge,
            child: ErrorCard(
              title: 'Failed to load clinic profile',
              error: error,
              stackTrace: stackTrace,
              onRetry: () => ref.invalidate(profileCompletionProvider),
            ),
          ),
        ),
      ),
      data: (entity) {
        _hydrateFrom(entity);

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? colorScheme.surfaceDim
              : colorScheme.surface,
          appBar: AppBar(
            title: const Text('Complete Clinic Profile'),
            actions: [
              TextButton.icon(
                onPressed: _isSavingDraft || _isCompleting ? null : _logout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
              ),
              AppDimens.horizontalMediumSmall,
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.spaceXxl,
                  AppDimens.spaceXxl,
                  AppDimens.spaceXxl,
                  _kBottomBarHeight,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _kMaxContentWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProgressHeroWidget(
                          entity: entity,
                          checklist: _checklist,
                          completionPercent: _completionPercent,
                          requiredCompletedCount: _requiredDoneCount,
                        ),
                        AppDimens.verticalLarge,
                        ClinicIdentityCardWidget(
                          identity: entity.clinicIdentity,
                        ),
                        AppDimens.verticalLarge,
                        BrandingSectionWidget(
                          coverImageUrl: _coverImageUrl,
                          logoImageUrl: _logoImageUrl,
                          isUploadingCover: _isUploadingCover,
                          isUploadingLogo: _isUploadingLogo,
                          showValidationErrors: _showValidation,
                          hasCoverImage: _hasCover,
                          hasLogoImage: _hasLogo,
                          onUploadCover: () =>
                              _uploadSingleImage(isCover: true),
                          onUploadLogo: () =>
                              _uploadSingleImage(isCover: false),
                          onRemoveCover: _hasCover
                              ? () => setState(() => _coverImageUrl = null)
                              : null,
                          onRemoveLogo: _hasLogo
                              ? () => setState(() => _logoImageUrl = null)
                              : null,
                        ),
                        AppDimens.verticalLarge,
                        DescriptionSectionWidget(
                          description: _trimmedDesc,
                          showValidationErrors: _showValidation,
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
                          showValidationErrors: _showValidation,
                          isGalleryValid: _isGalleryValid,
                          minImages: _minGalleryImages,
                          maxImages: _maxGalleryImages,
                          onAddImages: _uploadGalleryImages,
                          onRemoveImage: _removeGalleryImage,
                          onMoveImage: _moveGalleryImage,
                        ),
                        AppDimens.verticalLarge,
                        CertificationsSectionWidget(
                          certifications: _certifications,
                          onAdd: _addCertification,
                          onEdit: _editCertification,
                          onDelete: _deleteCertification,
                          onMove: _moveCertification,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: CompletionBottomBarWidget(
                  isBusy:
                      _isSavingDraft || _isCompleting || _isUploadingGallery,
                  isSavingDraft: _isSavingDraft,
                  isCompletingProfile: _isCompleting,
                  isReadyToComplete: _isReadyToComplete,
                  requiredCompletedCount: _requiredDoneCount,
                  onSaveDraft: _saveDraft,
                  onCompleteProfile: _completeProfile,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
