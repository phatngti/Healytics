import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/widgets/button/button.dart';
import 'package:user_app/router/routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/utils/device.dart';

class OnboardScreen extends HookConsumerWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hScreen = DeviceUtils.getScreenHeight(context);
    final wScreen = DeviceUtils.getScreenWidth(context);

    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: hScreen * 0.7,
            width: double.infinity,
            decoration: BoxDecoration(
              // color: Colors.red,
              // borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/images/intro.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          (hScreen * 0.05).verticalSpace,
          Container(
            padding: AppDimens.paddingHorizontalLarge,

            child: Column(
              children: [
                AppButton(
                  key: keys.onboardPage.signInButton,
                  onPressed: () {
                    // Navigate to the next screen or perform any action
                    context.pushReplacementNamed(SignInRoute.name);
                  },
                  buttonType: ButtonType.elevated,
                  customStyle: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: Size(wScreen * double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppDimens.radiusSmall,
                    ),
                    textStyle: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Sign In'),
                ),
                (hScreen * 0.02).verticalSpace,
                AppButton(
                  key: keys.onboardPage.createAccountButton,
                  onPressed: () {
                    // Navigate to the next screen or perform any action
                    EmailFormRoute().push(context);
                  },
                  buttonType: ButtonType.outline,
                  customStyle: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: Size(wScreen * double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppDimens.radiusSmall,
                    ),
                    textStyle: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Create an account'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
