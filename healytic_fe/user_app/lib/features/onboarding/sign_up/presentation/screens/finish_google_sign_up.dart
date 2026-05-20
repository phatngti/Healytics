import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/widgets/toast.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/entities/app_exception.dart';
import 'package:user_app/core/utils/form_validators.dart';
import 'package:user_app/features/authenticate/presentation/providers/google_sign_in_just_completed.provider.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/providers/finish_google_sign_up.provider.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/widgets/finish_sign_up/address_section.widget.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/widgets/finish_sign_up/date_of_birth_section.widget.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/widgets/finish_sign_up/legal_name_section.widget.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/widgets/finish_sign_up/terms_and_submit_section.widget.dart';
import 'package:user_app/router/routes.dart';
import 'package:user_app/utils/device.dart';

/// Final step of the Google sign-in flow for first-time
/// users. Mirrors [FinishSignUpScreen] minus the password
/// section: the Google account already proves email
/// ownership, so no password is collected.
///
/// Pre-fills `first_name` and `last_name` from the
/// Google display name passed via [googleDisplayName]
/// (Req 5.2, 5.3, 5.10). The user-supplied profile is
/// posted through [CompleteGoogleProfileNotifier] which
/// also rotates the auth tokens before navigating to
/// `SurveyScreenRoute` (Req 6.4, 6.5).
class FinishGoogleSignUpScreen extends HookConsumerWidget {
  /// Creates a [FinishGoogleSignUpScreen].
  const FinishGoogleSignUpScreen({
    super.key,
    this.googleDisplayName,
    this.googleEmail,
  });

  /// Google account display name. Used to pre-fill the
  /// legal name fields per the splitting rule in
  /// [_splitName].
  final String? googleDisplayName;

  /// Google account email. Forwarded into the
  /// [UserEntity] submitted to
  /// `completeGoogleProfile` so the backend can match
  /// the existing Google account record.
  final String? googleEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minBodyHeight = DeviceUtils.getMinBodyHeight(context);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final isFilledAll = useState(false);
    final scrollController = useScrollController();

    final split = _splitName(googleDisplayName);
    final initialValue = useMemoized(
      () => <String, dynamic>{
        'first_name': split.first,
        'last_name': split.last,
      },
      [split.first, split.last],
    );

    final isSubmitLoading =
        ref.watch(completeGoogleProfileProvider).isLoading;

    // Reset the "fresh Google sign-in" flag when this
    // screen unmounts so that any subsequent direct
    // navigation to /finish_google_sign_up is sent back
    // to /signin by the redirect guard (Req 5.12).
    useEffect(() {
      return () {
        // ignore: invalid_use_of_protected_member, invalid_use_of_internal_member
        ref.read(googleSignInJustCompletedProvider.notifier).state = false;
      };
    }, const []);

    ref.listen(completeGoogleProfileProvider, (previous, next) {
      // Only react to the resolution of an in-flight
      // submission; ignore the initial build emission
      // and any unrelated state changes.
      if (previous?.isLoading != true) return;

      next.when(
        data: (data) {
          if (!data.isProfileCompleted) return;
          if (!context.mounted) return;
          AppToast.success(context, 'Registration completed successfully.');
          const SurveyScreenRoute().go(context);
        },
        error: (err, _) {
          if (!context.mounted) return;
          AppToast.error(context, _profileErrorToast(err));
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => {OnboardingRoute().push(context)},
        ),
        title: Text(
          'Finish Sign Up',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        controller: scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minBodyHeight),
          child: Container(
            margin: EdgeInsets.only(top: AppDimens.paddingAllSmall.vertical),
            child: FormBuilder(
              key: formKey,
              initialValue: initialValue,
              onChanged: () =>
                  _checkFormFilled(formKey: formKey, isFilledAll: isFilledAll),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LegalNameSection(),
                  AppDimens.verticalLarge,
                  const DateOfBirthSection(),
                  AppDimens.verticalLarge,
                  const AddressSection(),
                  AppDimens.verticalLarge,
                  TermsAndSubmitSection(
                    isEnabled: isFilledAll.value && !isSubmitLoading,
                    isLoading: isSubmitLoading,
                    onSubmit: () => _submit(
                      context: context,
                      ref: ref,
                      formKey: formKey,
                    ),
                  ),
                  AppDimens.verticalExtraLarge,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Re-evaluates whether every required field is
  /// non-empty and valid, then updates [isFilledAll]
  /// (mirrors `FinishSignUpScreen._checkFormFilled`).
  void _checkFormFilled({
    required GlobalKey<FormBuilderState> formKey,
    required ValueNotifier<bool> isFilledAll,
  }) {
    final formState = formKey.currentState;
    if (formState == null) return;

    formState.save();
    final isValid = _isFormDataValid(formState.value);

    if (isFilledAll.value != isValid) {
      isFilledAll.value = isValid;
    }
  }

  /// Mirror of `FinishSignUpScreen._isFormDataValid`
  /// minus the `password` and `confirm_password`
  /// validators (Req 5.6, 5.7).
  bool _isFormDataValid(Map<String, dynamic> formData) {
    final validators = <String? Function()>[
      () => FormValidators.fullName(
        formData['first_name'],
        fieldName: 'First name',
      ),
      () => FormValidators.fullName(
        formData['last_name'],
        fieldName: 'Last name',
      ),
      () => FormValidators.dateOfBirth(formData['date_of_birth'], minAge: 16),
      () => FormValidators.requiredField(
        formData['city_or_province'],
        fieldName: 'province or city',
      ),
      () => FormValidators.requiredField(
        formData['district'],
        fieldName: 'district',
      ),
      () => FormValidators.requiredField(formData['ward'], fieldName: 'ward'),
      () => FormValidators.requiredField(
        formData['street_address'],
        fieldName: 'street address',
      ),
    ];

    return validators.every((validator) => validator() == null);
  }

  /// Validates the form and forwards the user-entered
  /// profile to [CompleteGoogleProfileNotifier]. On a
  /// failed validation the entered values are kept
  /// intact and a warning toast is shown (Req 5.11).
  void _submit({
    required BuildContext context,
    required WidgetRef ref,
    required GlobalKey<FormBuilderState> formKey,
  }) {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final formData = formKey.currentState?.value ?? {};
      if (formData.isEmpty) return;

      final dobValue = formData['date_of_birth'];
      String dobString = '';
      if (dobValue is DateTime) {
        dobString = dobValue.toIso8601String();
      } else if (dobValue is String) {
        dobString = dobValue;
      }

      final profile = UserEntity(
        email: googleEmail ?? '',
        password: '',
        firstName: (formData['first_name'] as String?) ?? '',
        lastName: (formData['last_name'] as String?) ?? '',
        dateOfBirth: dobString,
        address: AddressEntity(
          streetAddress: _asString(formData['street_address']),
          provinceId: _asString(formData['city_or_province']),
          districtId: _asString(formData['district']),
          wardId: _asString(formData['ward']),
        ),
      );

      ref
          .read(completeGoogleProfileProvider.notifier)
          .completeGoogleProfile(profile);
    } else {
      AppToast.warning(
        context,
        'Please complete all required '
        'fields correctly.',
      );
    }
  }

  /// Splits a Google display name into `first`/`last`
  /// per the rule documented in design §3.3:
  /// trim → empty becomes both blank; no whitespace →
  /// the full string in `first`; otherwise split on
  /// the first whitespace and `lTrim` the remainder.
  ({String first, String last}) _splitName(String? raw) {
    final value = raw?.trim() ?? '';
    if (value.isEmpty) return (first: '', last: '');
    final i = value.indexOf(RegExp(r'\s'));
    if (i < 0) return (first: value, last: '');
    return (first: value.substring(0, i), last: value.substring(i).trimLeft());
  }

  /// Maps an error from
  /// [CompleteGoogleProfileNotifier] to a user-facing
  /// toast message per the matrix in Req 6.6 / 6.7 /
  /// 6.8 / 6.9.
  String _profileErrorToast(Object err) {
    if (err is NetworkException) {
      return 'Network error. Please check your connection and try again.';
    }
    if (err is ServerException) {
      final code = err.statusCode;
      if (code >= 400 && code < 500) {
        final message = err.message.trim();
        if (message.isNotEmpty) return message;
      }
      if (code >= 500 && code < 600) {
        return 'Server error. Please try again later.';
      }
    }
    if (err is UnexpectedException) {
      return "We couldn't refresh your session. Please try again.";
    }
    return 'Could not complete profile. Please try again.';
  }

  String _asString(Object? value) {
    return value?.toString().trim() ?? '';
  }
}
