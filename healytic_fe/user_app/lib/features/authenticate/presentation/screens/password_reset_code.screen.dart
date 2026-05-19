import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:user_app/core/entities/app_exception.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/core/utils/form_validators.dart';
import 'package:user_app/features/authenticate/data/repositories/authenticate_repository_impl.dart';
import 'package:user_app/router/routes.dart';

class PasswordResetCodeScreen extends HookConsumerWidget {
  const PasswordResetCodeScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeController = useTextEditingController();
    final isSubmitting = useState(false);
    final isResending = useState(false);

    useListenable(codeController);

    final normalizedEmail = email.trim();
    final hasValidCode =
        FormValidators.otpCode(codeController.text.trim(), length: 6) == null;

    Future<void> submit() async {
      final code = codeController.text.trim();
      final validation = FormValidators.otpCode(code, length: 6);
      if (validation != null) {
        AppToast.warning(context, validation);
        return;
      }

      FocusScope.of(context).unfocus();
      isSubmitting.value = true;
      try {
        final resetToken = await ref
            .read(authenticateRepositoryProvider)
            .validatePasswordResetCode(email: normalizedEmail, code: code);

        if (context.mounted) {
          AppToast.success(context, 'Password reset code verified.');
          ResetPasswordRoute(token: resetToken).pushReplacement(context);
        }
      } catch (error) {
        final message = AppException.fromError(error).userMessage;
        if (context.mounted) {
          AppToast.error(context, message);
        }
      } finally {
        isSubmitting.value = false;
      }
    }

    Future<void> resendCode() async {
      isResending.value = true;
      try {
        await ref
            .read(authenticateRepositoryProvider)
            .requestPasswordReset(email: normalizedEmail);
        codeController.clear();
        if (context.mounted) {
          AppToast.success(context, 'A new password reset code was sent.');
        }
      } catch (error) {
        final message = AppException.fromError(error).userMessage;
        if (context.mounted) {
          AppToast.error(context, message);
        }
      } finally {
        isResending.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () {
            const ForgotPasswordRoute().pushReplacement(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimens.paddingAllMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Image.asset('assets/images/signin_image.png', height: 150),
                    AppDimens.verticalMedium,
                    Text(
                      'Enter verification code',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    AppDimens.verticalSmall,
                    Text(
                      'We sent a 6-digit code to $normalizedEmail.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              AppDimens.verticalLarge,
              Center(
                child: Pinput(
                  key: keys.passwordResetCodePage.pinput,
                  controller: codeController,
                  length: 6,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  separatorBuilder: (_) => const SizedBox(width: 8),
                  preFilledWidget: Text(
                    '-',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onCompleted: (_) {
                    if (!isSubmitting.value) {
                      submit();
                    }
                  },
                ),
              ),
              AppDimens.verticalMedium,
              Center(
                child: TextButton(
                  key: keys.passwordResetCodePage.resendButton,
                  onPressed: (isSubmitting.value || isResending.value)
                      ? null
                      : resendCode,
                  child: Text(isResending.value ? 'Sending...' : 'Resend code'),
                ),
              ),
              AppDimens.verticalLarge,
              FractionallySizedBox(
                widthFactor: 0.8,
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    key: keys.passwordResetCodePage.submitButton,
                    onPressed: (isSubmitting.value || !hasValidCode)
                        ? null
                        : submit,
                    buttonType: ButtonType.elevated,
                    customStyle: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppDimens.radiusSmall,
                      ),
                      textStyle: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    isLoading: isSubmitting.value,
                    child: const Text('Verify Code'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
