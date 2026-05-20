import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user_account.entity.dart';
import '../../domain/entities/profile_summary.entity.dart';
import '../../domain/entities/account_address.entity.dart';
import '../../data/provider/profile.provider.dart';

part 'profile.provider.g.dart';

@riverpod
Future<UserAccountEntity> accountMe(Ref ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getAccountMe();
}

final accountLocationProvider = FutureProvider<String?>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getAccountLocation();
});

final accountAddressProvider = FutureProvider<AccountAddressEntity?>((
  ref,
) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getAccountAddress();
});

@riverpod
Future<ProfileSummaryEntity> profileSummary(Ref ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getProfileSummary();
}
