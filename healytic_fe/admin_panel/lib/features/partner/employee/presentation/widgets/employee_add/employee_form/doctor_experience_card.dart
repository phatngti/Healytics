import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/medical_specialization.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:flutter/material.dart';

/// Card containing experience & qualification fields
/// for doctors: years of experience, consultation fee,
/// and specializations.
class DoctorExperienceCard extends StatefulWidget {
  /// Whether the fields are editable.
  final bool isEditing;

  /// Existing doctor entity for pre-fill in edit mode.
  final DoctorEntity? doctor;

  const DoctorExperienceCard({super.key, this.isEditing = true, this.doctor});

  @override
  State<DoctorExperienceCard> createState() => _DoctorExperienceCardState();
}

class _DoctorExperienceCardState extends State<DoctorExperienceCard> {
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
          _buildHeader(colorScheme, textTheme, semanticColors),
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

  Widget _buildHeader(
    ColorScheme colorScheme,
    TextTheme textTheme,
    SemanticColors semanticColors,
  ) {
    return Container(
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
                color: semanticColors.success?.withAlpha(25),
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      semanticColors.success?.withAlpha(75) ??
                      colorScheme.outlineVariant,
                ),
              ),
              child: Icon(
                Icons.workspace_premium_outlined,
                size: 18,
                color: semanticColors.success,
              ),
            ),
            AppDimens.horizontalMediumSmall,
            Text(
              'Experience & Qualifications',
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
                  suffixIcon: const Icon(Icons.percent, size: 20),
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
        ],
      ),
    );
  }
}
