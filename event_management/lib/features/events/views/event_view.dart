import 'package:event_management/core/commom/utils/spacing.dart';
import 'package:event_management/core/extensions/context_extensions.dart';
import 'package:event_management/core/extensions/string_extension.dart';
import 'package:event_management/features/auth/models/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/build_context_extension.dart';
import '../view_model/event_viewmodel.dart';

class EventScreen extends ConsumerWidget {
  const EventScreen({super.key, required this.role, required this.userId});
  final String role;
  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(eventNotifierProvider);

    return Scaffold(
      floatingActionButton: (role == UserRole.ORGANIZER.name)
          ? FloatingActionButton.extended(
              onPressed: () {
                context.pushNamed('/createEventScreen');
              },
              label: Text(context.l10n.createEvent),
            )
          : null,
      appBar: AppBar(title: Text(context.l10n.events)),
      body: eventsState.when(
        data: (events) {
          if (events.isEmpty) {
            return Center(child: Text(context.l10n.noEventsFound));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: events.length + 2,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7, // taller for image + text
              ),
              itemBuilder: (context, index) {
                if (index == events.length || index == events.length + 1) {
                  return const SizedBox();
                }
                final event = events[index];
                return GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      '/eventDetailsScreen',
                      arguments: {'event': event, "role": role, "userId": userId},
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Image
                        Expanded(
                          flex: 2,
                          child: Hero(
                            tag: "event-image-${event.id}",
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child:
                                  event.eventPhotoPath != null &&
                                      event.eventPhotoPath!.isNotEmpty
                                  ? Image.network(
                                      event.eventPhotoPath!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Container(
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.event, size: 50),
                                    ),
                            ),
                          ),
                        ),
                        Spaces.h16,
                        // Event Name and Details
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.eventName.capitalize(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),

                              Text(
                                'Date: ${event.dateFrom.toMonthDay()} - ${event.dateTo.toMonthDay()}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Time: ${event.timeFrom.to12HourTime()} - ${event.timeTo.to12HourTime()}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Spaces.h8,
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 30,
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(24),
                              ),
                            ),
                            child: Text(
                              context.l10n.free,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
