import 'package:event_management/features/dashboard/view_model/repository/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../model/user_profile_model.dart';

final futureProfileModelProvider =
    FutureProvider.family<Either<String, UserProfileModel>, int>((ref, int userId) async {
      return await ProfileRepository.fetchProfile(userId);
    });
