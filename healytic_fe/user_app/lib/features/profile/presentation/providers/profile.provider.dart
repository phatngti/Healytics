import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user_account.entity.dart';
import '../../domain/entities/profile_summary.entity.dart';
import '../../data/provider/profile.provider.dart';

part 'profile.provider.g.dart';

@riverpod
Future<UserAccountEntity> accountMe(Ref ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getAccountMe();
}

final profileSummaryProvider = FutureProvider<ProfileSummaryEntity>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getProfileSummary();
});
