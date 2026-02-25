import 'package:admin_panel/features/partner/employee/domain/medical_education.dart';
import 'package:admin_panel/features/partner/employee/domain/medical_specialization.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Form fields specific to doctors
class DoctorFieldsCard extends StatefulWidget {
  final bool isEditing;
  final DoctorEntity? doctor;

  const DoctorFieldsCard({super.key, this.isEditing = true, this.doctor});

  @override
  State<DoctorFieldsCard> createState() => _DoctorFieldsCardState();
}

class _DoctorFieldsCardState extends State<DoctorFieldsCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                      color: semanticColors.info?.withAlpha(25),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            semanticColors.info?.withAlpha(75) ??
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
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: _buildContent(context),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppDimens.paddingAllLarge,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'medical_title',
                  label: 'Medical Title',
                  hintText: 'e.g. BS CKI, Thạc sĩ',
                  enabled: widget.isEditing,
                  initialValue: widget.doctor?.jobTitle,
                ),
              ),
              AppDimens.horizontalLarge,
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'medical_license',
                  label: 'Medical License ID',
                  hintText: 'e.g. CCHN-00123',
                  isRequired: true,
                  prefixIcon: Icons.badge_outlined,
                  enabled: widget.isEditing,
                  initialValue: widget.doctor?.medicalLicense,
                ),
              ),
            ],
          ),
          AppDimens.verticalMedium,
          Row(
            children: [
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'experience_years',
                  label: 'Years of Experience',
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  enabled: widget.isEditing,
                  initialValue: widget.doctor?.experienceYears?.toString(),
                ),
              ),
              AppDimens.horizontalLarge,
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'consultation_fee',
                  label: 'Consultation Fee',
                  hintText: '00%',
                  keyboardType: TextInputType.number,
                  suffixIcon: Icon(Icons.percent, size: 20),
                  enabled: widget.isEditing,
                  initialValue: widget.doctor?.consultationFee?.toString(),
                ),
              ),
            ],
          ),
          AppDimens.verticalMedium,
          FormFieldBuilders.buildMultiSelectChipField(
            context,
            fieldKey: 'specializations',
            label: 'Specializations',
            availableOptions: MedicalSpecialization.optionsMap,
            searchHint: 'Search or add specialization...',
            allowCreate: true,
            width: double.infinity,
            enabled: widget.isEditing,
            initialValue: widget.doctor?.specializations,
          ),
          AppDimens.verticalMedium,
          FormFieldBuilders.buildDropdownField(
            context,
            fieldKey: 'education',
            label: 'Education',
            items: MedicalEducation.values.map((e) => e.displayName).toList(),
            enabled: widget.isEditing,
            initialValue: widget.doctor?.education.firstOrNull,
          ),
        ],
      ),
    );
  }
}
