import 'package:flutter/gestures.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:common/widgets/button/button.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/providers/register_flow_provider.dart';
import 'package:user_app/router/router.dart'; // Đảm bảo import đúng Router
import 'package:common/utils/demensions.dart';
import 'package:user_app/utils/device.dart';

class EmailCodeConfirmationScreen extends HookConsumerWidget {
  const EmailCodeConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minBodyHeight = DeviceUtils.getMinBodyHeight(context);

    // 1. Hooks
    final codeController = useTextEditingController();
    // Tự động rebuild khi text thay đổi -> để check enable/disable nút
    useListenable(codeController);

    final scrollController = useScrollController();

    final isSubmitLoading = useState(false);

    // 2. Riverpod State
    final asyncState = ref.watch(registerFlowProvider);

    // 4. Hàm Submit (Đã thêm Timeout)
    Future<void> submitCode() async {
      // Close keyboard
      FocusScope.of(context).unfocus();

      // Bật trạng thái loading cục bộ
      isSubmitLoading.value = true;
      try {
        final code = codeController.text;
        await ref.read(registerFlowProvider.notifier).verifyCode(code);

        if (context.mounted) {
          // Code đúng, chuyển sang màn hình tiếp theo
          context.pushReplacementNamed(FinishSignUpRoute.name);
        }
      } catch (e) {
        debugPrint('Error verifying code: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred. Please try again.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } finally {
        // Tắt trạng thái loading cục bộ
        isSubmitLoading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => EmailFormRoute().pushReplacement(context),
        ),
        title: const Text('Confirm your email'),
      ),
      // Sử dụng AsyncValue.when để handle trạng thái khởi tạo (load từ disk)
      body: SingleChildScrollView(
        padding: AppDimens.paddingAllMedium,
        controller: scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minBodyHeight),
          child: Container(
            margin: EdgeInsets.only(top: AppDimens.paddingAllSmall.vertical),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: AppDimens.paddingVerticalLarge.vertical,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter the code we sent over email to ${asyncState.value?.user?.email}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.color?.withAlpha(255),
                        ),
                      ),
                      AppDimens.verticalSmall,

                      // --- PINPUT ---
                      Pinput(
                        controller: codeController,
                        length: 5,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        // Không cần onChanged để set state nữa vì đã có useListenable
                        inputFormatters: [],
                        preFilledWidget: Text(
                          '-',
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        separatorBuilder: (index) => const SizedBox(width: 16),
                      ),

                      // ---------------
                      AppDimens.verticalMedium,
                      Text.rich(
                        TextSpan(
                          text: 'Didn\'t receive the code? ',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Send',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.apply(
                                    fontWeightDelta: 2,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Gọi hàm resend code
                                  ref
                                      .read(registerFlowProvider.notifier)
                                      .sendCode(
                                        asyncState.value?.user?.email ?? '',
                                      );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                (minBodyHeight * 0.08).verticalSpace,

                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    buttonType: ButtonType.elevated,
                    // Logic Disable: Chưa nhập đủ 5 số HOẶC đang loading
                    onPressed:
                        (codeController.text.length != 5 ||
                            isSubmitLoading.value)
                        ? null
                        : submitCode,

                    customStyle: ElevatedButton.styleFrom(
                      padding: AppDimens.paddingAllMedium,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppDimens.radiusSmall,
                      ),
                      textStyle: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    // Hiển thị Loading bên trong nút
                    isLoading: isSubmitLoading.value,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
