// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(otpUseCase)
const otpUseCaseProvider = OtpUseCaseProvider._();

final class OtpUseCaseProvider
    extends $FunctionalProvider<OtpUseCase, OtpUseCase, OtpUseCase>
    with $Provider<OtpUseCase> {
  const OtpUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otpUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otpUseCaseHash();

  @$internal
  @override
  $ProviderElement<OtpUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OtpUseCase create(Ref ref) {
    return otpUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OtpUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OtpUseCase>(value),
    );
  }
}

String _$otpUseCaseHash() => r'ced2656fa044620dee2e1711b2db20c0d0744437';
