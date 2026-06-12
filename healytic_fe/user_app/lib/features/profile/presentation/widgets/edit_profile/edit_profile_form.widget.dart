import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/location_entity.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/providers/location_provider.dart';
import 'package:user_app/features/profile/domain/entities/account_address.entity.dart';

class EditProfileAddressSelection {
  const EditProfileAddressSelection({
    required this.streetAddress,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
  });

  final String streetAddress;
  final String? provinceId;
  final String? districtId;
  final String? wardId;
}

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.streetAddressController,
    this.initialAddress,
    required this.onAddressChanged,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController streetAddressController;
  final AccountAddressEntity? initialAddress;
  final ValueChanged<EditProfileAddressSelection> onAddressChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildField(
          context,
          label: 'FULL NAME',
          icon: Icons.person_outline,
          controller: nameController,
          hintText: 'Enter your full name',
        ),
        const SizedBox(height: 24),
        _buildField(
          context,
          label: 'EMAIL ADDRESS',
          icon: Icons.mail_outline,
          controller: emailController,
          hintText: 'your@email.com',
          keyboardType: TextInputType.emailAddress,
          readOnly: true,
        ),
        const SizedBox(height: 24),
        _buildField(
          context,
          label: 'PHONE NUMBER',
          icon: Icons.call_outlined,
          controller: phoneController,
          hintText: '0901234567',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        EditProfileAddressFields(
          streetAddressController: streetAddressController,
          initialAddress: initialAddress,
          onChanged: onAddressChanged,
        ),
      ],
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(icon, color: colorScheme.onSurfaceVariant),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EditProfileAddressFields extends ConsumerStatefulWidget {
  const EditProfileAddressFields({
    super.key,
    required this.streetAddressController,
    required this.onChanged,
    this.initialAddress,
  });

  final TextEditingController streetAddressController;
  final AccountAddressEntity? initialAddress;
  final ValueChanged<EditProfileAddressSelection> onChanged;

  @override
  ConsumerState<EditProfileAddressFields> createState() =>
      _EditProfileAddressFieldsState();
}

class _EditProfileAddressFieldsState
    extends ConsumerState<EditProfileAddressFields> {
  String? _selectedProvinceId;
  String? _selectedDistrictId;
  String? _selectedWardId;
  AccountAddressEntity? _appliedInitialAddress;

  @override
  void initState() {
    super.initState();
    widget.streetAddressController.addListener(_emitSelection);
    _applyInitialAddress(widget.initialAddress);
  }

  @override
  void didUpdateWidget(covariant EditProfileAddressFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streetAddressController != widget.streetAddressController) {
      oldWidget.streetAddressController.removeListener(_emitSelection);
      widget.streetAddressController.addListener(_emitSelection);
    }
    _applyInitialAddress(widget.initialAddress);
  }

  @override
  void dispose() {
    widget.streetAddressController.removeListener(_emitSelection);
    super.dispose();
  }

  void _applyInitialAddress(AccountAddressEntity? address) {
    if (address == null || identical(address, _appliedInitialAddress)) {
      return;
    }
    _appliedInitialAddress = address;
    _selectedProvinceId = _emptyToNull(address.provinceId);
    _selectedDistrictId = _emptyToNull(address.districtId);
    _selectedWardId = _emptyToNull(address.wardId);
    if (widget.streetAddressController.text.trim().isEmpty) {
      widget.streetAddressController.text = address.streetAddress;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _emitSelection();
    });
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  void _emitSelection() {
    widget.onChanged(
      EditProfileAddressSelection(
        streetAddress: widget.streetAddressController.text.trim(),
        provinceId: _selectedProvinceId,
        districtId: _selectedDistrictId,
        wardId: _selectedWardId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provincesAsync = ref.watch(provincesProvider);
    final districtsAsync = ref.watch(districtsProvider(_selectedProvinceId));
    final wardsAsync = ref.watch(wardsProvider(_selectedDistrictId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: 'LOCATION'),
        _buildLocationDropdown(
          label: 'Province/City',
          hintText: 'Select Province',
          asyncValue: provincesAsync,
          selectedId: _selectedProvinceId,
          onChanged: (id) {
            setState(() {
              _selectedProvinceId = id;
              _selectedDistrictId = null;
              _selectedWardId = null;
            });
            _emitSelection();
          },
        ),
        const SizedBox(height: 12),
        _buildLocationDropdown(
          label: 'District',
          hintText: 'Select District',
          asyncValue: districtsAsync,
          selectedId: _selectedDistrictId,
          enabled: _selectedProvinceId != null,
          onChanged: (id) {
            setState(() {
              _selectedDistrictId = id;
              _selectedWardId = null;
            });
            _emitSelection();
          },
        ),
        const SizedBox(height: 12),
        _buildLocationDropdown(
          label: 'Ward/Commune',
          hintText: 'Select Ward',
          asyncValue: wardsAsync,
          selectedId: _selectedWardId,
          enabled: _selectedDistrictId != null,
          onChanged: (id) {
            setState(() => _selectedWardId = id);
            _emitSelection();
          },
        ),
        const SizedBox(height: 12),
        _AddressTextField(
          controller: widget.streetAddressController,
          hintText: 'Street address',
        ),
      ],
    );
  }

  Widget _buildLocationDropdown({
    required String label,
    required String hintText,
    required AsyncValue<List<LocationEntity>> asyncValue,
    required String? selectedId,
    required ValueChanged<String?> onChanged,
    bool enabled = true,
  }) {
    return asyncValue.when(
      data: (locations) {
        final value = locations.any((location) => location.id == selectedId)
            ? selectedId
            : null;
        return _LocationDropdown(
          label: label,
          hintText: hintText,
          value: value,
          enabled: enabled && locations.isNotEmpty,
          locations: locations,
          onChanged: onChanged,
        );
      },
      loading: () => const _AddressStatusField(text: 'Loading...'),
      error: (_, _) => _AddressStatusField(text: 'Could not load $label'),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _LocationDropdown extends StatelessWidget {
  const _LocationDropdown({
    required this.label,
    required this.hintText,
    required this.value,
    required this.enabled,
    required this.locations,
    required this.onChanged,
  });

  final String label;
  final String hintText;
  final String? value;
  final bool enabled;
  final List<LocationEntity> locations;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonFormField<String>(
        key: ValueKey('edit-profile-location-$label-${value ?? 'empty'}'),
        initialValue: value,
        isExpanded: true,
        items: locations
            .map(
              (location) => DropdownMenuItem<String>(
                value: location.id,
                child: Text(
                  location.fullName ?? location.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: enabled ? onChanged : null,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: enabled
              ? colorScheme.onSurfaceVariant
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _AddressTextField extends StatelessWidget {
  const _AddressTextField({required this.controller, required this.hintText});

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.done,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            Icons.home_outlined,
            color: colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _AddressStatusField extends StatelessWidget {
  const _AddressStatusField({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        enabled: false,
        initialValue: text,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
