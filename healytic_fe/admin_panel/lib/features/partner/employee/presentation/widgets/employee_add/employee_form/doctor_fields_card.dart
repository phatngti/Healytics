import 'package:admin_panel/features/partner/employee/domain/medical_certification.dart';
import 'package:admin_panel/features/partner/employee/domain/medical_education.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:flutter/material.dart';

/// Form fields specific to doctors: medical titles,
/// licenses, education, and certifications.
class DoctorFieldsCard extends StatefulWidget {
  /// Whether the fields are editable.
  final bool isEditing;

  /// Existing doctor entity for pre-fill in edit mode.
  final DoctorEntity? doctor;

  const DoctorFieldsCard({
    super.key,
    this.isEditing = true,
    this.doctor,
  });

  @override
  State<DoctorFieldsCard> createState() =>
      _DoctorFieldsCardState();
}

class _DoctorFieldsCardState
    extends State<DoctorFieldsCard> {
  bool _isExpanded = true;

  /// Number of medical title/license rows.
  int _credentialCount = 1;

  @override
  void initState() {
    super.initState();
    _initCredentialCount();
  }

  /// Initialises the row count from the doctor entity
  /// when editing an existing doctor.
  void _initCredentialCount() {
    final doctor = widget.doctor;
    if (doctor == null) return;

    final titles = doctor.medicalTitles.length;
    final licenses = doctor.medicalLicenses.length;
    final max =
        titles > licenses ? titles : licenses;
    if (max > 1) {
      _credentialCount = max;
    }
  }

  void _addCredentialRow() {
    setState(() {
      _credentialCount++;
    });
  }

  void _removeCredentialRow(int index) {
    if (_credentialCount <= 1) return;
    setState(() {
      _credentialCount--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors =
        Theme.of(context).extension<SemanticColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildHeader(
            colorScheme,
            textTheme,
            semanticColors,
          ),
          AnimatedCrossFade(
            firstChild: _buildContent(context),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(
              milliseconds: 200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    ColorScheme colorScheme,
    TextTheme textTheme,
    SemanticColors semanticColors,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: semanticColors.info
                    ?.withAlpha(25),
                shape: BoxShape.circle,
                border: Border.all(
                  color: semanticColors.info
                          ?.withAlpha(75) ??
                      colorScheme.outlineVariant,
                ),
              ),
              child: Icon(
                Icons.school_outlined,
                size: 18,
                color: semanticColors.info,
              ),
            ),
            AppDimens.horizontalMediumSmall,
            Text(
              'Education & Qualifications',
              style:
                  textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(
                milliseconds: 200,
              ),
              child: Icon(
                Icons.expand_more,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppDimens.paddingAllLarge,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCredentialRows(context),
          AppDimens.verticalMedium,
          _buildEducationField(context),
          AppDimens.verticalMedium,
          _buildCertificationsField(context),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Multi medical title / license rows
  // ──────────────────────────────────────────────

  Widget _buildCredentialRows(
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _credentialCount; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i < _credentialCount - 1
                  ? AppDimens.paddingAllMedium.top
                  : 0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: FormFieldBuilders
                      .buildTextField(
                    context,
                    fieldKey: 'medical_title_$i',
                    label: i == 0
                        ? 'Medical Title'
                        : '',
                    hintText:
                        'e.g. BS CKI, Thạc sĩ',
                    enabled: widget.isEditing,
                    initialValue: _titleAt(i),
                  ),
                ),
                AppDimens.horizontalLarge,
                Expanded(
                  child: FormFieldBuilders
                      .buildTextField(
                    context,
                    fieldKey: 'medical_license_$i',
                    label: i == 0
                        ? 'Medical License ID'
                        : '',
                    hintText: 'e.g. CCHN-00123',
                    isRequired: i == 0,
                    prefixIcon: Icons.badge_outlined,
                    enabled: widget.isEditing,
                    initialValue: _licenseAt(i),
                  ),
                ),
                if (widget.isEditing)
                  _buildRowAction(
                    context,
                    index: i,
                    colorScheme: colorScheme,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRowAction(
    BuildContext context, {
    required int index,
    required ColorScheme colorScheme,
  }) {
    final isLast = index == _credentialCount - 1;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        onPressed: isLast
            ? _addCredentialRow
            : () => _removeCredentialRow(index),
        icon: Icon(
          isLast ? Icons.add_circle_outline : Icons.remove_circle_outline,
          color: isLast
              ? colorScheme.primary
              : colorScheme.error,
          size: 22,
        ),
        tooltip: isLast
            ? 'Add credential'
            : 'Remove credential',
      ),
    );
  }

  String? _titleAt(int index) {
    final titles = widget.doctor?.medicalTitles;
    if (titles == null || index >= titles.length) {
      return null;
    }
    return titles[index];
  }

  String? _licenseAt(int index) {
    final licenses =
        widget.doctor?.medicalLicenses;
    if (licenses == null ||
        index >= licenses.length) {
      return null;
    }
    return licenses[index];
  }

  // ──────────────────────────────────────────────
  // Education (multi-select popover)
  // ──────────────────────────────────────────────

  Widget _buildEducationField(
    BuildContext context,
  ) {
    return FormFieldBuilders
        .buildMultiSelectPopoverField<String>(
      context,
      fieldKey: 'education',
      label: 'Education',
      items: MedicalEducation.optionsMap,
      initialValue: widget.doctor?.education,
      searchHint: 'Search education...',
      enabled: widget.isEditing,
    );
  }

  // ──────────────────────────────────────────────
  // Certifications (multi-select popover)
  // ──────────────────────────────────────────────

  Widget _buildCertificationsField(
    BuildContext context,
  ) {
    return FormFieldBuilders
        .buildMultiSelectPopoverField<String>(
      context,
      fieldKey: 'certifications',
      label: 'Certifications',
      items: MedicalCertification.optionsMap,
      initialValue:
          widget.doctor?.certifications,
      searchHint: 'Search certification...',
      enabled: widget.isEditing,
    );
  }
}
