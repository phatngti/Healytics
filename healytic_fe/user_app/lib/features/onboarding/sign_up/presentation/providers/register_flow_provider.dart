import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/survey_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/usecases/otp.dart';
import 'package:user_app/features/onboarding/sign_up/domain/usecases/persistence.dart';
import 'package:user_app/features/onboarding/sign_up/domain/usecases/survey.dart';
import 'package:user_app/features/onboarding/sign_up/data/repositories/register_repository_impl.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/providers/register_usecases.provider.dart';

part 'register_flow_provider.freezed.dart';
part 'register_flow_provider.g.dart';

/// Thrown when a user attempts to register with an
/// email that is already in the system.
class EmailAlreadyExistsException implements Exception {
  EmailAlreadyExistsException(this.email);

  final String email;

  @override
  String toString() =>
      'EmailAlreadyExistsException: $email is already registered.';
}

@freezed
abstract class RegisterStateData with _$RegisterStateData {
  factory RegisterStateData({
    @Default(0) int stepIndex,
    UserEntity? user,
    @Default(<String, List<SurveyEntity>>{})
    Map<String, List<SurveyEntity>> surveys,
    @Default(false) bool isSurveyCompleted,
    @Default(false) bool isRegistrationCompleted,
    AuthTokensEntity? authTokens,
  }) = _RegisterStateData;

  factory RegisterStateData.fromJson(Map<String, dynamic> json) =>
      _$RegisterStateDataFromJson(json);
}

// Chuyển thành AsyncNotifier bằng cách trả về Future<RegisterStateData>
@riverpod
class RegisterFlowNotifier extends _$RegisterFlowNotifier {
  KeepAliveLink? _link;

  @override
  Future<RegisterStateData> build() async {
    ref.keepAlive();
    // Tự động hủy link khi provider bị dispose (phòng hờ)
    ref.onDispose(() {
      _link?.close();
    });
    // 2. Trả về state khởi tạo
    return RegisterStateData(
      stepIndex: 0,
      user: UserEntity(
        email: '',
        firstName: '',
        lastName: '',
        dateOfBirth: '',
        password: '',
      ),
      surveys: {},
      isSurveyCompleted: false,
      isRegistrationCompleted: false,
      authTokens: null,
    );
  }

  /// Helper để update state hiện tại một cách an toàn
  /// Giúp code bên dưới gọn hơn
  void _updateState(
    RegisterStateData Function(RegisterStateData current) reducer,
  ) {
    debugPrint(
      '_updateState: hasValue=${state.hasValue}, isLoading=${state.isLoading}, hasError=${state.hasError}',
    );
    if (state.hasValue) {
      final newState = reducer(state.requireValue);
      state = AsyncData(newState);
      debugPrint('_updateState: state updated');
    } else {
      debugPrint('_updateState: state has no value, cannot update');
    }
  }

  Future<void> saveProgress() async {
    final currentState = state.value;
    if (currentState != null) {
      await ref
          .read(savePartialDataProvider)
          .call(currentState.user, currentState.stepIndex);
    }
  }

  Future<void> clearProgress() async {
    await ref.read(clearPartialDataProvider).call();
    // Reset về mặc định
    state = AsyncData(RegisterStateData());
  }

  /// Checks whether an email is already registered.
  ///
  /// Returns `true` if the email already exists.
  Future<bool> checkEmailExists(String email) async {
    final repository = ref.read(registerRepositoryProvider);
    return repository.checkEmailExists(email: email);
  }

  Future<void> sendCode(String email) async {
    // 1. Update Email vào state trước

    try {
      _updateState((current) {
        return current.copyWith(
          user: current.user?.copyWith(email: email),
        );
      });

      // 2. Check if email already exists before sending OTP
      final exists = await checkEmailExists(email);
      if (exists) {
        throw EmailAlreadyExistsException(email);
      }

      await ref.read(otpUseCaseProvider).sendOTP(email: email);
      await saveProgress();
    } catch (e, stack) {
      state = AsyncError<RegisterStateData>(e, stack);
      rethrow;
    }
  }

  Future<void> verifyCode(String code) async {
    final email = state.value?.user?.email;
    if (email == null) throw Exception("Email cannot be null");
    try {
      await ref.read(otpUseCaseProvider).verifyCode(email: email, code: code);
      await saveProgress();
    } catch (e, stack) {
      state = AsyncError<RegisterStateData>(e, stack);
      rethrow;
    }
  }

  Future<void> completeRegistration(UserEntity updatedUser) async {
    try {
      debugPrint('completeRegistration: started');
      final email = state.value?.user?.email;
      if (email == null) throw Exception("Email cannot be null");
      final authenTokens = await ref
          .read(completedRegistrationUseCaseProvider)
          .call(user: updatedUser.copyWith(email: email));

      debugPrint('completeRegistration: got tokens');

      // Cập nhật user hoàn chỉnh vào state
      _updateState(
        (current) => current.copyWith(
          authTokens: authenTokens,
          isRegistrationCompleted: true,
        ),
      );
      await saveProgress();
    } catch (e, stack) {
      debugPrint('completeRegistration: error $e');
      state = AsyncError<RegisterStateData>(e, stack);
      rethrow;
    }
  }

  Future<void> updateSurvey(String stepKey, List<SurveyEntity> surveys) async {
    if (state.value?.isRegistrationCompleted ?? false) {
      return;
    }

    final currentSurveys = state.value?.surveys ?? {};
    final updatedSurveys = {...currentSurveys, stepKey: surveys};

    final currentStepIndex = state.value?.stepIndex == 4
        ? 4
        : (state.value?.stepIndex ?? 0) + 1;
    _updateState(
      (current) => current.copyWith(
        surveys: updatedSurveys,
        stepIndex: currentStepIndex,
        isRegistrationCompleted: currentStepIndex == 4,
      ),
    );
    await saveProgress();
  }

  Future<void> completeSurvey() async {
    try {
      debugPrint(
        'isRegistrationCompleted ${state.value?.isRegistrationCompleted}',
      );
      if (state.value?.isRegistrationCompleted ?? false) {
        final surveys = state.value?.surveys ?? <String, List<SurveyEntity>>{};
        await ref.read(surveyUseCaseProvider).completeSurvey(surveys: surveys);
        await saveProgress();
        ref.invalidateSelf();
      }
    } catch (e, stack) {
      state = AsyncError<RegisterStateData>(e, stack);
      rethrow;
    }
  }

  void goToNextStep() {
    _updateState(
      (current) => current.copyWith(stepIndex: current.stepIndex + 1),
    );
    saveProgress();
  }

  void goToPreviousStep() {
    final currentIndex = state.value?.stepIndex ?? 0;
    if (currentIndex > 0) {
      _updateState((current) => current.copyWith(stepIndex: currentIndex - 1));
      saveProgress();
    }
  }
}
