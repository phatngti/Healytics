import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:common/widgets/button/button.dart';
import 'package:user_app/features/authenticate/presentation/widgets/login_form.widget.dart';
import 'package:user_app/router/routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/utils/device.dart';

class SingInScreen extends HookConsumerWidget {
  const SingInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double minBodyHeight =
        DeviceUtils.getScreenHeight(context) -
        DeviceUtils.getStatusBarHeight(context) -
        DeviceUtils.getAppBarHeight();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => {context.pushReplacementNamed(OnboardingRoute.name)},
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
                      'We’re so excited to see you again!',
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
                        onPressed: () {
                          // Handle Google sign-in
                        },
                        buttonType: ButtonType.outline,
                        customStyle: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppDimens.radiusSmall,
                          ),
                        ),
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
                    AppDimens.verticalSmall,
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: AppButton(
                        key: keys.signInPage.facebookButton,
                        onPressed: () {
                          // Handle Google sign-in
                        },
                        buttonType: ButtonType.outline,
                        customStyle: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppDimens.radiusSmall,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Continue with'),
                            AppDimens.horizontalSmall,
                            SvgPicture.asset(
                              'assets/icons/facebook_icon.svg',
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
