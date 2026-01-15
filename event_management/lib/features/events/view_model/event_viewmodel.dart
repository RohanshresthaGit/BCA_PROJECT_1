import 'package:event_management/features/events/models/create_event_model.dart';
import 'package:event_management/features/events/models/update_event_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/event_model.dart';
import '../repository/event_repository.dart';

final eventSearchQueryProvider = StateProvider<String>((ref) => '');

final eventNotifierProvider =
    AsyncNotifierProvider<EventNotifier, List<EventModel>>(EventNotifier.new);

class EventNotifier extends AsyncNotifier<List<EventModel>> {
  @override
  Future<List<EventModel>> build() async {
    return fetchEvents();
  }

  Future<List<EventModel>> fetchEvents() async {
    state = const AsyncLoading();
    final result = await EventRepository.getAllEvents();

    return result.match((l) => throw Exception(l), (r) {
      state = AsyncData(r);
      return r;
    });
  }

  /// Add new event
  Future<void> addEvent(CreateEventRequest event) async {
    state = const AsyncLoading();
    final result = await EventRepository.createEvent(event);
    result.match(
      (l) => throw Exception(l),
      (r) => state = AsyncData([r, ...state.value ?? []]),
    );
  }

  // /// Update existing event
  Future<void> updateEvent(UpdateEventModel event) async {
    state = const AsyncLoading();
    final result = await EventRepository.updateEvent(event);
    await result.match((l) => throw Exception(l), (r) async {
      final res = await fetchEvents();
      state = AsyncData(res);

      // final updatedList = state.value?.map((e) => e.id == r.id ? r : e).toList();
      // state = AsyncData(updatedList ?? []);
    });
  }

  /// Delete event
  Future<void> deleteEvent(int id) async {
    state = const AsyncLoading();
    final result = await EventRepository.deleteEvent(id);
    result.match((l) => l, (r) {
      final updatedList = state.value?.where((e) => e.id != id).toList();
      state = AsyncData(updatedList ?? []);
    });
  }
}
