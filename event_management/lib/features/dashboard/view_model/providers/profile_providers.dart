import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../model/update_profile_model.dart';
import '../../model/user_profile_model.dart';
import '../repository/profile_repository.dart';

final fetchProfileProvider =
    FutureProvider.family<Either<String, UserProfileModel>, int>(
  (ref, userId) async {
    return ProfileRepository.fetchProfile(userId);
  },
);

final deleteProfileProvider =
    FutureProvider.family<Either<String, String>, int>(
  (ref, userId) async {
    return ProfileRepository.deleteProfile(userId);
  },
);

/// Profile state notifier
final profileNotifierProvider =
    AsyncNotifierProvider<ProfileNotifier, String?>(
  ProfileNotifier.new,
);

class ProfileNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    // Initially fetch profile if needed
    return null;
  }

  // /// Fetch profile by userId
  // Future<void> getProfile(int userId) async {
  //   state = const AsyncLoading();
  //   final result = await ProfileRepository.fetchProfile(userId);

  //   result.match(
  //     (error) => state = AsyncError(error, StackTrace.current),
  //     (profile) => state = AsyncData(profile),
  //   );
  // }

  /// Update profile and refresh automatically
  Future<void> updateProfile(UpdateProfileRequest request) async {
    state = AsyncLoading(); // optional: show loading for entire profile

    final result = await ProfileRepository.updateProfile(
      request.userId,
      request.toFormFields(),
      request.profilePhoto,
    );

    result.match(
      (error) {
        state = AsyncError(error, StackTrace.current);
      },
      (successMsg) async {
        // After successful update, fetch profile again
        state = AsyncData(successMsg);
        // await getProfile(request.userId);
      },
    );
  }
}
