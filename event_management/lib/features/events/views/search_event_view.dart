import 'package:event_management/core/extensions/build_context_extension.dart';
import 'package:event_management/core/extensions/context_extensions.dart';
import 'package:event_management/core/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/event_viewmodel.dart';

class EventSearchPage extends ConsumerWidget {
  const EventSearchPage({super.key, required this.role, required this.userId});
  final String role;
  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventNotifierProvider.notifier).state;
    final searchQuery = ref.watch(eventSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.searchEvent)),
      body: Column(
        children: [
          // 🔍 Search Field
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: '${context.l10n.searchEvent}...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref.read(eventSearchQueryProvider.notifier).state = value;
              },
            ),
          ),

          // 📋 Event List
          Expanded(
            child: eventState.when(
              data: (events) {
                final filteredEvents = events.where((event) {
                  return event.eventName.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
                }).toList();

                if (filteredEvents.isEmpty) {
                  return const Center(child: Text('No events found'));
                }

                return ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];

                    return ListTile(
                      leading: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Hero(
                          tag: 'event-image-${event.id}',
                          child:
                              event.eventPhotoPath != null &&
                                  event.eventPhotoPath!.isNotEmpty
                              ? Image.network(
                                  event.eventPhotoPath!,
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 40,
                                  width: 40,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.event, size: 30),
                                ),
                        ),
                      ),
                      title: Text(event.eventName.capitalize()),
                      subtitle: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.redAccent),
                          Text('${event.address}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.pushNamed(
                          '/eventDetailsScreen',
                          arguments: {"event": event, "role": role, "userId": userId},
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
