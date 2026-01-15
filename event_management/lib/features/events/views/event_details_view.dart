import 'package:event_management/core/commom/components/components_export.dart';
import 'package:event_management/core/extensions/build_context_extension.dart';
import 'package:event_management/core/extensions/context_extensions.dart';
import 'package:event_management/core/extensions/string_extension.dart';
import 'package:event_management/features/auth/models/signup_model.dart';
import 'package:event_management/features/book_event/view_model/booke_event_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../book_event/models/book_event_request_model.dart';
import '../models/event_model.dart'; // replace with your actual path

class EventDetailScreen extends ConsumerWidget {
  final EventModel event;
  final String role;
  final int userId;

  const EventDetailScreen({
    super.key,
    required this.event,
    required this.role,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: (role == UserRole.ORGANIZER.name)
          ? FloatingActionButton.extended(
              onPressed: () {
                context.pushNamed("/editEvent", arguments: {"event": event});
              },
              label: Text(context.l10n.editEvent),
            )
          : null,
      persistentFooterButtons: [
        if (role == UserRole.USER.name)
          Consumer(
            builder: (context, ref, child) {
              final isEveentBooked = ref.watch(
                isEventBookedFuture(
                  BookEventParams(eventId: event.id, userId: userId),
                ),
              );
              return isEveentBooked.when(
                data: (isBooked) {
                  if (isBooked) {
                    return PrimaryButton(
                      label: context.l10n.attend,
                      onPressed: () {
                        context.showSnackBar(
                          "You have already booked this event.",
                        );
                      },
                    );
                  } else {
                    return PrimaryButton(
                      label: context.l10n.attend,
                      onPressed: () {
                        ref.read(
                          bookEventFuture(
                            BookEventParams(eventId: event.id, userId: userId),
                          ).future,
                        );
                        ref.invalidate(
                          isEventBookedFuture(
                            BookEventParams(eventId: event.id, userId: userId),
                          ),
                        );
                      },
                    );
                  }
                },
                loading: () =>
                    PrimaryButton(label: context.l10n.loading, loading: true),
                error: (e, _) => Text("Error"),
              );
            },
          ),
        if (event.latitude != null && event.longitude != null)
          PrimaryButton(
            label: context.l10n.maps,
            onPressed: () {
              openGoogleMapsDirections(
                context: context,
                latitude: event.latitude!,
                longitude: event.longitude!,
              );
            },
          ),
      ],
      appBar: AppBar(
        title: Text(event.eventName.capitalize()),
        actions: [
          // if (role == UserRole.ADMIN.name || role == UserRole.ORGANIZER.name)
          //   AppIconButton(
          //     icon: Icons.delete,
          //     onPressed: () {
          //       ref.read(eventNotifierProvider.notifier).deleteEvent(event.id);
          //       context.pushReplacementNamed('/dashboard');
          //     },
          //   ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Event Image
            Hero(
              tag: "event-image-${event.id}",
              child:
                  event.eventPhotoPath != null &&
                      event.eventPhotoPath!.isNotEmpty
                  ? Image.network(
                      event.eventPhotoPath!,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.event, size: 80),
                    ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Name
                  Text(
                    event.eventName.capitalize(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Date & Time
                  _rowItem(
                    Icons.date_range,
                    ' ${event.dateFrom.toMonthDay()} - ${event.dateTo.toMonthDay()}',
                  ),
                  _rowItem(
                    Icons.watch_later_sharp,
                    '${event.timeFrom.to12HourTime()} - ${event.timeTo.to12HourTime()}',
                  ),

                  // Address
                  if (event.address != null)
                    _rowItem(Icons.location_on_rounded, event.address!),

                  // Description
                  if (event.description != null)
                    Text(
                      'Description:\n${event.description!.capitalize()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _rowItem(IconData icon, String title) {
    return Row(spacing: 8, children: [Icon(icon), Text(title)]);
  }

  Future<void> openGoogleMapsDirections({
    required double latitude,
    required double longitude,
    required BuildContext context,
  }) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=$latitude,$longitude',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      context.showErrorSnackBar('Could not open Google Maps.');
    }
  }
}
