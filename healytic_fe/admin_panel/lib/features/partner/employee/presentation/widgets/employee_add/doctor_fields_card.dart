import 'package:admin_panel/features/common/widgets/input/text_field.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Form fields specific to doctors
class DoctorFieldsCard extends StatefulWidget {
  const DoctorFieldsCard({super.key});

  @override
  State<DoctorFieldsCard> createState() => _DoctorFieldsCardState();
}

class _DoctorFieldsCardState extends State<DoctorFieldsCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Icon(
                      Icons.school_outlined,
                      size: 18,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Education & Qualifications',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
          // Content
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  fieldKey: 'medical_title',
                  label: 'Medical Title',
                  hintText: 'e.g. BS CKI, Thạc sĩ',
                ),
              ),
              AppDimens.horizontalLarge,
              Expanded(
                child: AppTextField(
                  fieldKey: 'medical_license',
                  label: 'Medical License ID',
                  hintText: 'e.g. CCHN-00123',
                  isRequired: true,
                  prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                ),
              ),
            ],
          ),
          AppDimens.verticalMedium,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  fieldKey: 'experience_years',
                  label: 'Years of Experience',
                  hintText: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
              AppDimens.horizontalLarge,
              Expanded(
                child: AppTextField(
                  fieldKey: 'consultation_fee',
                  label: 'Consultation Fee',
                  hintText: '0.00',
                  keyboardType: TextInputType.number,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 12, right: 4),
                    child: Text(
                      '\$',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppDimens.verticalMedium,
          AppTextField(
            fieldKey: 'specializations',
            label: 'Specializations',
            hintText: 'e.g. Dermatology, Cosmetic Surgery (comma separated)',
            maxLines: 2,
          ),
          AppDimens.verticalMedium,
          AppTextField(
            fieldKey: 'education',
            label: 'Education History',
            hintText: 'e.g. University of Medicine - Doctor of Medicine',
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
