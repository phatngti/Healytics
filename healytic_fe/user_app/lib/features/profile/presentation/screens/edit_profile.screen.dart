import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/toast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/core/providers/s3.provider.dart';
import 'package:user_app/features/profile/domain/entities/user_account.entity.dart';

import '../providers/profile.provider.dart';
import '../providers/edit_profile_controller.provider.dart';
import '../../data/provider/profile.provider.dart';
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
  final ImagePicker _imagePicker = ImagePicker();
  bool _isPopulated = false;

  /// Local override URL shown immediately after
  /// a successful avatar upload, before the
  /// backend round-trips the new URL.
  String? _avatarOverrideUrl;
  bool _isUploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();

    // Populate on first data emission
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryPopulateFields(ref.read(accountMeProvider));
    });
  }

  /// Fills form fields once when account data
  /// becomes available. Guards against double
  /// population via [_isPopulated].
  void _tryPopulateFields(AsyncValue<UserAccountEntity> state) {
    if (_isPopulated) return;
    final data = state.value;
    if (data == null) return;

    _isPopulated = true;
    _nameController.text = data.displayName;
    _emailController.text = data.email;
    _phoneController.text = data.phone ?? '';
    _locationController.text = '';
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
      AppToast.success(context, 'Profile updated successfully.');
      context.pop();
      return;
    }

    if (!success && mounted) {
      final controllerState = ref.read(editProfileControllerProvider);
      final errorText = controllerState.error?.toString();
      AppToast.error(context, errorText ?? 'Unable to update profile.');
    }
  }

  /// Picks an avatar from the gallery, uploads it
  /// via S3, persists the URL to the backend, and
  /// refreshes the displayed image.
  Future<void> _pickAvatar() async {
    if (_isUploadingAvatar) return;
    setState(() => _isUploadingAvatar = true);
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 768,
        maxHeight: 768,
        imageQuality: 85,
      );
      if (image == null) return;

      final s3 = ref.read(s3ServiceProvider);
      final key = await s3.uploadFile(image);

      if (!mounted || key == null) {
        if (mounted) {
          AppToast.error(
            context,
            'Unable to update avatar.',
          );
        }
        return;
      }

      // Resolve the viewable URL from the S3 key.
      final url = await s3.getFileUrl(key);
      if (!mounted) return;

      if (url == null) {
        AppToast.error(
          context,
          'Upload succeeded but failed to '
          'retrieve the image URL.',
        );
        return;
      }

      // Persist the full URL to the backend
      // and display it immediately.
      final repo = ref.read(profileRepositoryProvider);
      await repo.updateAvatarUrl(url);

      if (!mounted) return;

      setState(() => _avatarOverrideUrl = url);
      ref.invalidate(accountMeProvider);
      AppToast.success(
        context,
        'Avatar updated successfully.',
      );
    } catch (e, st) {
      developer.log(
        'Avatar upload failed',
        name: 'EditProfileScreen',
        error: e,
        stackTrace: st,
      );
      if (mounted) {
        AppToast.error(
          context,
          'Unable to update avatar.',
        );
      }
    } finally {
      if (mounted) {
        setState(
          () => _isUploadingAvatar = false,
        );
      }
    }
  }

  Future<void> _showChangePasswordDialog() async {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainerHigh,
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PasswordField(
                controller: currentController,
                labelText: 'Current password',
              ),
              const SizedBox(height: 12),
              _PasswordField(
                controller: newController,
                labelText: 'New password',
              ),
              const SizedBox(height: 12),
              _PasswordField(
                controller: confirmController,
                labelText: 'Confirm new password',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final success = await ref
                    .read(editProfileControllerProvider.notifier)
                    .changePassword(
                      currentPassword: currentController.text,
                      newPassword: newController.text,
                      confirmPassword: confirmController.text,
                    );
                if (!mounted || !dialogContext.mounted) {
                  return;
                }
                if (success) {
                  Navigator.of(dialogContext).pop();
                  AppToast.success(context, 'Password changed successfully.');
                } else {
                  AppToast.error(
                    context,
                    _controllerError('Unable to change password.'),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );

    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
  }

  Future<void> _showDeleteAccountDialog() async {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainerHigh,
          title: Text(
            'Delete Account',
            style: TextStyle(color: colorScheme.error),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This permanently removes your '
                'account data. Type DELETE and '
                'enter your password to continue.',
                style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Type DELETE',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              _PasswordField(
                controller: passwordController,
                labelText: 'Password',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () async {
                if (confirmController.text.trim() != 'DELETE') {
                  AppToast.error(context, 'Type DELETE to confirm.');
                  return;
                }

                final success = await ref
                    .read(editProfileControllerProvider.notifier)
                    .deleteAccount(password: passwordController.text);
                if (!mounted || !dialogContext.mounted) {
                  return;
                }
                if (success) {
                  Navigator.of(dialogContext).pop();
                  ref.read(authSessionStoreProvider).forceLogout();
                  AppToast.success(context, 'Account deleted.');
                } else {
                  AppToast.error(
                    context,
                    _controllerError('Unable to delete account.'),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    passwordController.dispose();
    confirmController.dispose();
  }

  String _controllerError(String fallback) {
    final errorText = ref.read(editProfileControllerProvider).error?.toString();
    if (errorText == null || errorText.isEmpty) {
      return fallback;
    }
    return errorText.replaceFirst('Exception: ', '');
  }

  @override
  Widget build(BuildContext context) {
    // Listen for provider resolution
    // (handles cold-start loading state)
    ref.listen<AsyncValue<UserAccountEntity>>(
      accountMeProvider,
      (_, next) => _tryPopulateFields(next),
    );

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(editProfileControllerProvider);
    final isLoading = state.isLoading;
    final accountData = ref.watch(accountMeProvider).value;

    return Scaffold(
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
                    name: accountData?.displayName ?? '',
                    imageUrl: _avatarOverrideUrl ??
                        accountData?.avatarUrl,
                    onEditAvatar: _pickAvatar,
                    isBusy: _isUploadingAvatar,
                  ),
                  const SizedBox(height: 32),
                  EditProfileForm(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    locationController: _locationController,
                  ),
                  const SizedBox(height: 32),
                  EditProfileSecurity(
                    onChangePassword: _showChangePasswordDialog,
                    isBusy: isLoading,
                  ),
                  const SizedBox(height: 32),
                  EditProfileDangerZone(
                    onDeleteAccount: _showDeleteAccountDialog,
                    isBusy: isLoading,
                  ),
                  // Footer spacing
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({required this.controller, required this.labelText});

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
