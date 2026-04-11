import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/toast.dart';
import 'package:go_router/go_router.dart';

import '../providers/profile.provider.dart';
import '../providers/edit_profile_controller.provider.dart';
import '../widgets/edit_profile/edit_profile_picture.widget.dart';
import '../widgets/edit_profile/edit_profile_form.widget.dart';
import '../widgets/edit_profile/edit_profile_security.widget.dart';
import '../widgets/edit_profile/edit_profile_danger_zone.widget.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();

    // Fill initial data if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accountData = ref.read(accountMeProvider).value;
      if (accountData != null) {
        _nameController.text = accountData.displayName;
        _emailController.text = accountData.email;
        _phoneController.text = accountData.phone ?? '';
        // Mock location
        _locationController.text = 'San Francisco, CA';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submit() async {
    final controller = ref.read(editProfileControllerProvider.notifier);
    final success = await controller.submitProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
    );

    if (success && mounted) {
      AppToast.success(
        context,
        'Profile updated successfully.',
      );
      context.pop();
      return;
    }

    if (!success && mounted) {
      final controllerState = ref.read(editProfileControllerProvider);
      final errorText = controllerState.error?.toString();
      AppToast.error(
        context,
        errorText ?? 'Unable to update profile.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(editProfileControllerProvider);
    final isLoading = state.isLoading;
    final accountData = ref.watch(accountMeProvider).value;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Edit Profile',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : _submit,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      )
                    : Text(
                        'Done',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.horizontalPadding(context),
                vertical: 24,
              ),
              child: Column(
                children: [
                  EditProfilePicture(
                    name: accountData?.displayName ?? 'Julianne Smith',
                  ),
                  const SizedBox(height: 32),
                  EditProfileForm(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    locationController: _locationController,
                  ),
                  const SizedBox(height: 32),
                  const EditProfileSecurity(),
                  const SizedBox(height: 32),
                  const EditProfileDangerZone(),
                  const SizedBox(height: 48), // Footer spacing
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
