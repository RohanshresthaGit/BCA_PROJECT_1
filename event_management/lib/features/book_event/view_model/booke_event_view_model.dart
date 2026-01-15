import 'package:event_management/features/book_event/service/book_event_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fpdart/fpdart.dart';

import '../models/book_event_request_model.dart';

final bookEventLoading = StateProvider<bool>((ref) => false);

final bookEventFuture =
    FutureProvider.family<Either<String, String>, BookEventParams>((
      ref,
      params,
    ) async {
      return await BookEventRepository.bookEvent(params.eventId, params.userId);
    });

final isEventBookedFuture = FutureProvider.family<bool, BookEventParams>((
  ref,
  params,
) async {
  return await BookEventRepository.isEventBooked(params.eventId, params.userId);
});
