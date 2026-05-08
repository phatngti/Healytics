import 'package:common/widgets/input/form_field_builders.dart';
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
  const ProductOperationsCard({super.key});

  @override
  ConsumerState<ProductOperationsCard> createState() =>
      _ProductOperationsCardState();
}

class _ProductOperationsCardState extends ConsumerState<ProductOperationsCard> {
  String _staffAllocation = StaffAllocation.any.apiValue;
  String _staffRole = EmployeeRoleType.doctor.apiValue;
  List<EmployeeEntity> _selectedStaff = [];
  List<EmployeeEntity> _allStaff = [];
  bool _isLoadingStaff = true;

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    try {
      final staff = await ref
          .read(productProvider.notifier)
          .getStaffForProduct(role: _staffRole);
      if (mounted) {
        setState(() {
          _allStaff = staff;
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
      final staffIds = _selectedStaff.map((s) => s.id).toList();
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
          initialValue: _selectedStaff.map((s) => s.id).toList(),
          builder: (field) => const SizedBox.shrink(),
        ),
        FormBuilderField<String>(
          name: ProductFormField.staffAllocation.key,
          initialValue: _staffAllocation,
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
                    AppDimens.verticalMedium,
                    Divider(color: colorScheme.outlineVariant),
                    AppDimens.verticalMedium,
                    // Booking Rules Section
                    _buildSectionHeader(
                      context,
                      icon: Icons.event_available_outlined,
                      title: 'Booking Rules',
                    ),
                    AppDimens.verticalMediumSmall,
                    _buildBookingRules(context),
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
            setState(() => _staffAllocation = StaffAllocation.any.apiValue);
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

    return FormFieldBuilders.buildChipSelectorField(
      context,
      label: 'Select Staff',
      chips: _selectedStaff
          .map(
            (staff) => _EmployeeStaffChip(
              employee: staff,
              onRemove: () {
                setState(() {
                  _selectedStaff.remove(staff);
                });
                _updateFormBuilderStaff();
              },
            ),
          )
          .toList(),
      emptyPlaceholder: 'Select staff members...',
      onTap: () => _showStaffSelectionDialog(context),
    );
  }

  void _showStaffSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _EmployeeSelectionDialog(
        allStaff: _allStaff,
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
              ),
            ),
            AppDimens.horizontalMedium,
            Expanded(
              child: _IconTextField(
                icon: Icons.more_time,
                label: 'Buffer (min)',
                hintText: '15',
                fieldKey: ProductFormField.buffer.key,
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
            ),
            AppDimens.verticalExtraSmall,
            Text(
              'Maximum clients served simultaneously per slot.',
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

  Widget _buildBookingRules(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Min. Lead Time',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    key: const ValueKey('formfield_lead_time'),
                    name: ProductFormField.leadTime.key,
                    keyboardType: TextInputType.number,
                    initialValue: '2',
                    decoration: InputDecoration(
                      hintText: '2',
                      filled: true,
                      fillColor: colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        borderSide: BorderSide(
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        borderSide: BorderSide(
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        borderSide: BorderSide(color: colorScheme.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    border: Border.all(color: colorScheme.outlineVariant),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    'hours',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        AppDimens.verticalMedium,
        // Availability Info Card
        Container(
          padding: AppDimens.paddingAllMediumSmall,
          decoration: BoxDecoration(
            color: colorScheme.primary.withAlpha(13),
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(color: colorScheme.primary.withAlpha(26)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Availability',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Using Business Hours (Mon-Fri, 9am-6pm)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
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
            groupValue: isSelected,
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

/// Staff chip widget that displays an EmployeeEntity
class _EmployeeStaffChip extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback onRemove;

  const _EmployeeStaffChip({required this.employee, required this.onRemove});

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(left: 4, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: AppDimens.radiusPill,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (employee.avatar.isNotEmpty)
            CircleAvatar(
              radius: 10,
              backgroundImage: NetworkImage(employee.avatar, headers: const {}),
              onBackgroundImageError: (_, __) {},
            )
          else
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surfaceContainerHighest,
              ),
              child: Center(
                child: Text(
                  _getInitials(employee.displayName),
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 6),
          Text(
            employee.displayName,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
          AppDimens.horizontalExtraSmall,
          InkWell(
            onTap: onRemove,
            borderRadius: AppDimens.radiusPill,
            child: Icon(
              Icons.close,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hintText;
  final String fieldKey;

  const _IconTextField({
    required this.icon,
    required this.label,
    required this.hintText,
    required this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        FormBuilderTextField(
          key: ValueKey('formfield_$fieldKey'),
          name: fieldKey,
          keyboardType: TextInputType.number,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
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
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(
        'Select Staff Members',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.allStaff.map((staff) {
              final isSelected = _isSelected(staff);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (_) => _toggleSelection(staff),
                title: Row(
                  children: [
                    if (staff.avatar.isNotEmpty)
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(staff.avatar),
                        onBackgroundImageError: (_, __) {},
                      )
                    else
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.surfaceContainerHighest,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    AppDimens.horizontalMediumSmall,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            staff.displayName,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            staff.position,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onConfirm(_tempSelected);
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
