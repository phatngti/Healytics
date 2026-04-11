import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_openapi/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_me.provider.g.dart';

/// Fetches the current authenticated user's account
/// details from the `/account/me` endpoint.
///
/// Kept alive so the header doesn't refetch on every
/// rebuild. Invalidate manually after profile edits.
@Riverpod(keepAlive: true)
Future<AccountMeResponseDto?> accountMe(Ref ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.accountApi.accountControllerGetMe();
}
