import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logging/logging.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/toast.dart';
import 'package:user_app/core/entities/app_exception.dart';
import 'package:user_app/features/authenticate/presentation/providers/authenticate.provider.dart';
import 'package:user_app/features/authenticate/presentation/providers/google_sign_in_just_completed.provider.dart';
import 'package:user_app/features/authenticate/presentation/widgets/login_form.widget.dart';
import 'package:user_app/router/routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/utils/device.dart';

final _log = Logger('SignInScreen');

/// Decodes the `profileCompleted` claim from a Healytics access token.
///
/// Treats a literal `bool true` as completed; missing, `null`, or any
/// non-bool value (including the strings `"true"`/`"false"`) as `false`,
/// matching the design's "first-time vs returning" branching rule
/// (Req 4.1, Req 4.2).
bool _decodeProfileCompleted(String accessToken) {
  try {
    final claims = JwtDecoder.decode(accessToken);
    final raw = claims['profileCompleted'];
    return raw is bool && raw;
  } catch (_) {
    return false;
  }
}

/// Maps an [AppException] thrown during the Google sign-in flow to a
/// user-facing toast message (Req 7.1–7.5).
///
/// Backend error codes are matched by substring on `err.message` because
/// the data source's `_messageFromResponse` returns the body's `message`
/// field, and the backend embeds the literal code text in that message.
/// HTTP-status-only matches (no embedded code) fall through to the default.
String _googleErrorToast(Object err) {
  if (err is NetworkException) {
    return 'Network error. Please check your connection and try again.';
  }
  if (err is ServerException) {
    final message = err.message;
    if (err.statusCode == 401 && message.contains('GOOGLE_TOKEN_INVALID')) {
      return 'Could not verify your Google sign-in. Please try again.';
    }
    if (err.statusCode == 401 &&
        message.contains('GOOGLE_EMAIL_NOT_VERIFIED')) {
      return 'Your Google email is not verified. Please verify it and try again.';
    }
    if (err.statusCode == 409 &&
        message.contains('EMAIL_ALREADY_REGISTERED_WITH_PASSWORD')) {
      return 'This email is already registered with a password. '
          'Please sign in with email and password instead.';
    }
    if (err.statusCode == 403 && message.contains('ACCOUNT_DISABLED')) {
      return 'This account is disabled. Please contact support.';
    }
  }
  return 'Could not complete Google sign-in. Please try again.';
}

class SingInScreen extends HookConsumerWidget {
  const SingInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double minBodyHeight =
        DeviceUtils.getScreenHeight(context) -
        DeviceUtils.getStatusBarHeight(context) -
        DeviceUtils.getAppBarHeight();

    final isLoading = ref.watch(authenticateProvider).isLoading;

    // Auth state listener: branches on success
    // (profile-completed vs first-time) and surfaces
    // failure toasts. Guarded by `previous?.isLoading == true`
    // so it only reacts to a fresh sign-in attempt.
    ref.listen(authenticateProvider, (previous, next) {
      _log.fine('Auth state: $next');
      if (previous?.isLoading != true) return;

      next.when(
        data: (data) {
          final entity = data.authenticate;
          if (entity == null) return;
          if (!context.mounted) return;

          final completed = _decodeProfileCompleted(entity.accessToken);
          if (completed) {
            AppToast.success(context, 'Signed in successfully.');
            const HomeRoute().go(context);
          } else {
            // Mark a fresh Google sign-in so the redirect
            // guard for FinishGoogleSignUpRoute (Req 5.12)
            // lets us in.
            ref.read(googleSignInJustCompletedProvider.notifier).state = true;
            FinishGoogleSignUpRoute(
              name: entity.basicInfo?.name,
              email: entity.basicInfo?.email,
            ).go(context);
          }
        },
        error: (err, _) {
          if (!context.mounted) return;
          AppToast.error(context, _googleErrorToast(err));
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () {
            context.pushReplacementNamed(OnboardingRoute.name);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimens.paddingAllMedium,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minBodyHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Image.asset('assets/images/signin_image.png'),
                    AppDimens.verticalSmall,
                    Text(
                      'Welcome Back!',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    AppDimens.verticalSmall,
                    Text(
                      'We\u2019re so excited '
                      'to see you again!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              AppDimens.verticalLarge,
              // Form
              LoginForm(),
              AppDimens.verticalLarge,
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              AppDimens.verticalLarge,
              // Login with social media
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: AppButton(
                        key: keys.signInPage.googleButton,
                        onPressed: isLoading
                            ? null
                            : () {
                                ref
                                    .read(authenticateProvider.notifier)
                                    .signInWithGoogle();
                              },
                        buttonType: ButtonType.outline,
                        customStyle: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppDimens.radiusSmall,
                          ),
                        ),
                        isLoading: isLoading,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Continue with'),
                            AppDimens.horizontalSmall,
                            SvgPicture.asset(
                              'assets/icons/google_icon.svg',
                              height: 24,
                              width: 24,
                            ),
                            AppDimens.horizontalSmall,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
