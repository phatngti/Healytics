import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/products/domain/product_form_field.dart';
import 'package:admin_panel/features/partner/products/domain/staff_allocation.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductOperationsCard extends ConsumerStatefulWidget {
  const ProductOperationsCard({
    super.key,
    this.initialStaffAllocation,
    this.initialStaffIds = const [],
  });

  final String? initialStaffAllocation;
  final List<String> initialStaffIds;

  @override
  ConsumerState<ProductOperationsCard> createState() =>
      ProductOperationsCardState();
}

class ProductOperationsCardState extends ConsumerState<ProductOperationsCard> {
  late String _staffAllocation;
  String _staffRole = EmployeeRoleType.doctor.apiValue;
  List<EmployeeEntity> _selectedStaff = [];
  List<EmployeeEntity> _allStaff = [];
  bool _isLoadingStaff = true;

  @override
  void initState() {
    super.initState();
    _staffAllocation = widget.initialStaffIds.isNotEmpty
        ? StaffAllocation.specific.apiValue
        : widget.initialStaffAllocation ?? StaffAllocation.any.apiValue;
    _loadStaff(includeInitialSelection: widget.initialStaffIds.isNotEmpty);
  }

  Future<void> _loadStaff({bool includeInitialSelection = false}) async {
    try {
      final notifier = ref.read(productProvider.notifier);
      final allStaff = await notifier.getStaffForProduct();
      final selectedIds = widget.initialStaffIds.toSet();
      final selectedStaff = includeInitialSelection
          ? allStaff
                .where((employee) => selectedIds.contains(employee.id.value))
                .toList()
          : _selectedStaff;
      final selectedRole = selectedStaff.isNotEmpty
          ? EmployeeRoleType.fromApiValue(selectedStaff.first.role)?.apiValue
          : null;
      final staffRole = selectedRole ?? _staffRole;

      if (mounted) {
        setState(() {
          _staffRole = staffRole;
          _allStaff = allStaff;
          _selectedStaff = selectedStaff;
          _isLoadingStaff = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingStaff = false;
        });
      }
    }
  }

  /// Sync selected staff with FormBuilder
  void _updateFormBuilderStaff() {
    final formState = FormBuilder.of(context);
    if (formState != null) {
      // Store staff IDs as a list
      final staffIds = _staffAllocation == StaffAllocation.specific.apiValue
          ? _selectedStaff.map((s) => s.id.value).toList()
          : <String>[];
      formState.fields[ProductFormField.selectedStaffIds.key]?.didChange(
        staffIds,
      );
      // Also store staff allocation type
      formState.fields[ProductFormField.staffAllocation.key]?.didChange(
        _staffAllocation,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hidden FormBuilder fields to store staff data
        FormBuilderField<List<dynamic>>(
          name: ProductFormField.selectedStaffIds.key,
          initialValue: widget.initialStaffIds,
          validator: (value) {
            if (_staffAllocation != StaffAllocation.specific.apiValue) {
              return null;
            }
            if (value == null || value.isEmpty) {
              return 'Select at least one staff member';
            }
            return null;
          },
          builder: (field) => const SizedBox.shrink(),
        ),
        FormBuilderField<String>(
          name: ProductFormField.staffAllocation.key,
          initialValue: _staffAllocation,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Staff allocation is required';
            }
            return null;
          },
          builder: (field) => const SizedBox.shrink(),
        ),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppDimens.radiusMediumSmall,
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withAlpha(5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: AppDimens.paddingAllMediumLarge,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  border: Border(
                    bottom: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    AppDimens.horizontalSmall,
                    Text(
                      'OPERATIONS & SCHEDULING',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: AppDimens.paddingAllMediumLarge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Staff & Assignment Section
                    _buildSectionHeader(
                      context,
                      icon: Icons.group_outlined,
                      title: 'Staff & Assignment',
                    ),
                    AppDimens.verticalMediumSmall,
                    _buildStaffAllocationOptions(context),
                    AppDimens.verticalMedium,
                    // Only show staff selector if "Specific Staff" is selected
                    if (_staffAllocation ==
                        StaffAllocation.specific.apiValue) ...[
                      _buildStaffRoleSelector(context),
                      AppDimens.verticalMedium,
                      _buildStaffSelector(context),
                    ],
                    AppDimens.verticalMedium,
                    Divider(color: colorScheme.outlineVariant),
                    AppDimens.verticalMedium,
                    // Scheduling Details Section
                    _buildSectionHeader(
                      context,
                      icon: Icons.schedule_outlined,
                      title: 'Scheduling Details',
                    ),
                    AppDimens.verticalMediumSmall,
                    _buildSchedulingDetails(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        AppDimens.horizontalSmall,
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStaffAllocationOptions(BuildContext context) {
    return Column(
      children: [
        _StaffAllocationOption(
          title: 'Any Available Staff',
          subtitle: 'Auto-assign based on availability',
          isSelected: _staffAllocation == StaffAllocation.any.apiValue,
          onTap: () {
            setState(() {
              _staffAllocation = StaffAllocation.any.apiValue;
              _selectedStaff = [];
            });
            _updateFormBuilderStaff();
          },
        ),
        AppDimens.verticalSmall,
        _StaffAllocationOption(
          title: 'Specific Staff',
          subtitle: 'Limit booking to selected employees',
          isSelected: _staffAllocation == StaffAllocation.specific.apiValue,
          onTap: () {
            setState(
              () => _staffAllocation = StaffAllocation.specific.apiValue,
            );
            _updateFormBuilderStaff();
          },
        ),
      ],
    );
  }

  Widget _buildStaffRoleSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Staff Role',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        AppDimens.verticalSmall,
        Row(
          children: [
            _buildRoleChip(
              context,
              EmployeeRoleType.doctor.displayName,
              EmployeeRoleType.doctor.apiValue,
            ),
            AppDimens.horizontalSmall,
            _buildRoleChip(
              context,
              EmployeeRoleType.therapist.displayName,
              EmployeeRoleType.therapist.apiValue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleChip(BuildContext context, String label, String value) {
    final isSelected = _staffRole == value;
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected && _staffRole != value) {
          setState(() {
            _staffRole = value;
            _isLoadingStaff = true;
            // Clear selected staff when role changes since they likely won't match
            _selectedStaff = [];
          });
          _updateFormBuilderStaff();
          _loadStaff();
        }
      },
      checkmarkColor: isSelected ? colorScheme.onPrimary : null,
      selectedColor: colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: colorScheme.surfaceContainerLow,
      side: BorderSide(
        color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
      ),
    );
  }

  Widget _buildStaffSelector(BuildContext context) {
    if (_isLoadingStaff) {
      return const Center(
        child: Padding(
          padding: AppDimens.paddingAllMedium,
          child: CircularProgressIndicator(),
        ),
      );
    }

    void removeStaff(EmployeeEntity staff) {
      setState(() {
        _selectedStaff.removeWhere((employee) => employee.id == staff.id);
      });
      _updateFormBuilderStaff();
    }

    return _AssignedStaffPanel(
      staff: _selectedStaff,
      onSelect: () => _showStaffSelectionDialog(context),
      onReplace: () => _showStaffSelectionDialog(context),
      onRemove: removeStaff,
    );
  }

  void _showStaffSelectionDialog(BuildContext context) {
    final filteredStaff = _allStaff
        .where((employee) => employee.role == _staffRole)
        .toList();

    showDialog(
      context: context,
      builder: (context) => _EmployeeSelectionDialog(
        allStaff: filteredStaff,
        selectedStaff: _selectedStaff,
        onConfirm: (selected) {
          setState(() {
            _selectedStaff = selected;
          });
          _updateFormBuilderStaff();
        },
      ),
    );
  }

  Widget _buildSchedulingDetails(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _IconTextField(
                icon: Icons.hourglass_empty,
                label: 'Duration (min)',
                hintText: '60',
                fieldKey: ProductFormField.duration.key,
                isRequired: true,
              ),
            ),
            AppDimens.horizontalMedium,
            Expanded(
              child: _IconTextField(
                icon: Icons.more_time,
                label: 'Buffer (min)',
                hintText: '15',
                fieldKey: ProductFormField.buffer.key,
                isRequired: true,
              ),
            ),
          ],
        ),
        AppDimens.verticalMedium,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IconTextField(
              icon: Icons.group_add_outlined,
              label: 'Capacity (Parallel Bookings)',
              hintText: '1',
              fieldKey: ProductFormField.capacity.key,
              isRequired: true,
            ),
            AppDimens.verticalExtraSmall,
            Text(
              'Maximum clients served '
              'simultaneously per slot.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StaffAllocationOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _StaffAllocationOption({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<bool>(
            value: true,
            // ignore: deprecated_member_use
            groupValue: isSelected,
            // ignore: deprecated_member_use
            onChanged: (_) => onTap(),
            activeColor: colorScheme.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          AppDimens.horizontalExtraSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _employeeInitials(EmployeeEntity employee) {
  final name = employee.displayName.trim().isNotEmpty
      ? employee.displayName.trim()
      : employee.fullName.trim();
  if (name.isEmpty) return '?';
  final parts = name.split(RegExp(r'\s+'));
  if (parts.length >= 2) {
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
  return name[0].toUpperCase();
}

String _roleLabel(EmployeeEntity employee) {
  return EmployeeRoleType.fromApiValue(employee.role)?.displayName ??
      employee.role;
}

String _primaryInfo(EmployeeEntity employee) {
  if (employee is DoctorEntity) {
    final title = employee.jobTitle.trim();
    if (title.isNotEmpty) return title;
    return EmployeeRoleType.doctor.displayName;
  }

  if (employee is SpaTherapistEntity) {
    final level = employee.therapistLevel?.trim();
    return [
      _spaTherapistLabel,
      if (level != null && level.isNotEmpty) level,
    ].join(' - ');
  }

  if (employee is MassageTherapistEntity) {
    final level = employee.therapistLevel?.trim();
    return [
      _massageTherapistLabel,
      if (level != null && level.isNotEmpty) level,
    ].join(' - ');
  }

  final position = employee.position.trim();
  return position.isEmpty ? _roleLabel(employee) : position;
}

String _secondaryInfo(EmployeeEntity employee) {
  if (employee is DoctorEntity) {
    final parts = <String>[
      if (employee.specializations.isNotEmpty)
        employee.specializations.take(2).join(', '),
      if ((employee.experienceYears ?? 0) > 0)
        '${employee.experienceYears} yrs exp',
    ];
    return parts.join(' - ');
  }

  if (employee is SpaTherapistEntity) {
    return employee.skills.take(3).join(', ');
  }

  if (employee is MassageTherapistEntity) {
    return employee.skills.take(3).join(', ');
  }

  return employee.employeeCode;
}

List<String> _employeeBadges(EmployeeEntity employee) {
  if (employee is DoctorEntity) {
    return [
      ...employee.specializations.take(2),
      if (employee.medicalLicenses.isNotEmpty) 'Licensed',
    ];
  }

  if (employee is SpaTherapistEntity) {
    return [
      ...employee.skills.take(2),
      if (employee.deviceProficiency.isNotEmpty) 'Devices',
    ];
  }

  if (employee is MassageTherapistEntity) {
    return [
      ...employee.skills.take(2),
      if ((employee.strengthLevel ?? '').isNotEmpty) employee.strengthLevel!,
    ];
  }

  return [];
}

String _statusLabel(EmployeeEntity employee) {
  final normalized = employee.status
      .split('_')
      .where((part) => part.isNotEmpty)
      .map(
        (part) => '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
      )
      .join(' ');
  return normalized.isEmpty ? employee.status : normalized;
}

const _spaTherapistLabel = 'Spa therapist';
const _massageTherapistLabel = 'Massage therapist';

class _EmployeeAvatar extends StatelessWidget {
  final EmployeeEntity employee;
  final double size;

  const _EmployeeAvatar({required this.employee, required this.size});

  @override
  Widget build(BuildContext context) {
    final avatar = employee.avatar.trim();

    if (avatar.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          avatar,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(context),
        ),
      );
    }

    return _fallback(context);
  }

  Widget _fallback(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primaryContainer,
      ),
      child: Center(
        child: Text(
          _employeeInitials(employee),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _AssignedStaffPanel extends StatelessWidget {
  final List<EmployeeEntity> staff;
  final VoidCallback onSelect;
  final VoidCallback onReplace;
  final ValueChanged<EmployeeEntity> onRemove;

  const _AssignedStaffPanel({
    required this.staff,
    required this.onSelect,
    required this.onReplace,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700);

    if (staff.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Assigned Staff', style: titleStyle),
          AppDimens.verticalSmall,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: AppDimens.radiusSmall,
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.surfaceContainerHighest,
                  ),
                  child: Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 22,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                AppDimens.horizontalMediumSmall,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No employees assigned',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Assign specific doctors or therapists for this service.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AppDimens.horizontalMediumSmall,
                OutlinedButton.icon(
                  onPressed: onSelect,
                  icon: const Icon(Icons.group_add_outlined, size: 18),
                  label: const Text('Assign'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text('Assigned Staff', style: titleStyle),
                  AppDimens.horizontalSmall,
                  _StaffCountPill(count: staff.length),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: onReplace,
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: const Text('Replace'),
            ),
          ],
        ),
        AppDimens.verticalSmall,
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            final spacing = isWide ? 12.0 : 8.0;
            final cardWidth = isWide
                ? (constraints.maxWidth - spacing) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: spacing,
              runSpacing: 8,
              children: staff
                  .map(
                    (employee) => SizedBox(
                      width: cardWidth,
                      child: _AssignedStaffCard(
                        employee: employee,
                        onRemove: () => onRemove(employee),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _StaffCountPill extends StatelessWidget {
  final int count;

  const _StaffCountPill({required this.count});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withAlpha(90),
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        '$count assigned',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AssignedStaffCard extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback onRemove;

  const _AssignedStaffCard({required this.employee, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 116),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EmployeeAvatar(employee: employee, size: 52),
          AppDimens.horizontalMediumSmall,
          Expanded(child: _EmployeeBasicInfo(employee: employee)),
          AppDimens.horizontalExtraSmall,
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _StatusPill(label: _statusLabel(employee)),
              const SizedBox(height: 8),
              IconButton(
                tooltip: 'Remove staff member',
                onPressed: onRemove,
                icon: const Icon(Icons.close, size: 18),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmployeeBasicInfo extends StatelessWidget {
  final EmployeeEntity employee;

  const _EmployeeBasicInfo({required this.employee});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final secondary = _secondaryInfo(employee);
    final badges = _employeeBadges(employee);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          employee.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          _primaryInfo(employee),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        if (secondary.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            secondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (badges.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: badges.map((badge) => _StaffBadge(label: badge)).toList(),
          ),
        ],
      ],
    );
  }
}

class _StaffBadge extends StatelessWidget {
  final String label;

  const _StaffBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withAlpha(80),
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;

  const _StatusPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _IconTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hintText;
  final String fieldKey;
  final bool isRequired;

  const _IconTextField({
    required this.icon,
    required this.label,
    required this.hintText,
    required this.fieldKey,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
        FormBuilderTextField(
          key: ValueKey('formfield_$fieldKey'),
          name: fieldKey,
          keyboardType: TextInputType.number,
          validator: _buildValidator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              icon,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 36),
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(color: colorScheme.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  /// Validates the numeric field value.
  ///
  /// Checks emptiness for required fields, then
  /// validates integer format and positive value.
  String? _buildValidator(String? value) {
    final trimmed = value?.trim() ?? '';

    if (isRequired && trimmed.isEmpty) {
      return '$label is required';
    }

    if (trimmed.isEmpty) return null;

    final parsed = int.tryParse(trimmed);
    if (parsed == null) {
      return 'Enter a valid number';
    }

    if (parsed <= 0) {
      return 'Must be greater than 0';
    }

    return null;
  }
}

/// Dialog for selecting staff members from EmployeeEntity list
class _EmployeeSelectionDialog extends StatefulWidget {
  final List<EmployeeEntity> allStaff;
  final List<EmployeeEntity> selectedStaff;
  final ValueChanged<List<EmployeeEntity>> onConfirm;

  const _EmployeeSelectionDialog({
    required this.allStaff,
    required this.selectedStaff,
    required this.onConfirm,
  });

  @override
  State<_EmployeeSelectionDialog> createState() =>
      _EmployeeSelectionDialogState();
}

class _EmployeeSelectionDialogState extends State<_EmployeeSelectionDialog> {
  late List<EmployeeEntity> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedStaff);
  }

  bool _isSelected(EmployeeEntity staff) {
    return _tempSelected.any((s) => s.id == staff.id);
  }

  void _toggleSelection(EmployeeEntity staff) {
    setState(() {
      if (_isSelected(staff)) {
        _tempSelected.removeWhere((s) => s.id == staff.id);
      } else {
        _tempSelected.add(staff);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _tempSelected.length;

    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              'Replace Assigned Staff',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          if (selectedCount > 0) _StaffCountPill(count: selectedCount),
        ],
      ),
      content: SizedBox(
        width: 760,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 600),
          child: widget.allStaff.isEmpty
              ? const Center(child: Text('No staff members available'))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 680;
                    final spacing = isWide ? 12.0 : 8.0;
                    final cardWidth = isWide
                        ? (constraints.maxWidth - spacing) / 2
                        : constraints.maxWidth;

                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: spacing,
                        runSpacing: 8,
                        children: widget.allStaff
                            .map(
                              (staff) => SizedBox(
                                width: cardWidth,
                                child: _EmployeeSelectionCard(
                                  employee: staff,
                                  isSelected: _isSelected(staff),
                                  onTap: () => _toggleSelection(staff),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _tempSelected.isEmpty
              ? null
              : () {
                  widget.onConfirm(_tempSelected);
                  Navigator.of(context).pop();
                },
          child: const Text('Apply Assignment'),
        ),
      ],
    );
  }
}

class _EmployeeSelectionCard extends StatelessWidget {
  final EmployeeEntity employee;
  final bool isSelected;
  final VoidCallback onTap;

  const _EmployeeSelectionCard({
    required this.employee,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected
          ? colorScheme.primaryContainer.withAlpha(70)
          : colorScheme.surfaceContainerLow,
      borderRadius: AppDimens.radiusSmall,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimens.radiusSmall,
        child: Container(
          constraints: const BoxConstraints(minHeight: 126),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EmployeeAvatar(employee: employee, size: 52),
              AppDimens.horizontalMediumSmall,
              Expanded(child: _EmployeeBasicInfo(employee: employee)),
              AppDimens.horizontalSmall,
              Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
