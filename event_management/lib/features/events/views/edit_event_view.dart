import 'dart:io';

import 'package:event_management/core/commom/components/components_export.dart';
import 'package:event_management/features/events/models/event_model.dart';
import 'package:event_management/features/events/models/update_event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/extensions/build_context_extension.dart';
import '../view_model/event_viewmodel.dart';

class UpdateEventPage extends ConsumerStatefulWidget {
  final EventModel event;

  const UpdateEventPage({super.key, required this.event});

  @override
  ConsumerState<UpdateEventPage> createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends ConsumerState<UpdateEventPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateFromController = TextEditingController();
  TextEditingController _dateToController = TextEditingController();
  TextEditingController _timeFromController = TextEditingController();
  TextEditingController _timeToController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _latitude = TextEditingController();
  TextEditingController _longitude = TextEditingController();

  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController = TextEditingController(text: widget.event.eventName);
      _descriptionController = TextEditingController(
        text: widget.event.description,
      );
      _dateFromController = TextEditingController(text: widget.event.dateFrom);
      _dateToController = TextEditingController(text: widget.event.dateTo);
      _timeFromController = TextEditingController(text: widget.event.timeFrom);
      _timeToController = TextEditingController(text: widget.event.timeTo);
      _addressController = TextEditingController(text: widget.event.address);

      _latitude = TextEditingController(
        text: widget.event.latitude.toString() ?? '0',
      );
      _longitude = TextEditingController(
        text: widget.event.longitude.toString() ?? '0',
      );
      setState(() {});
    });

    // ref.read(updateEventProvider.notifier).loadEvent(widget.event);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dateFromController.dispose();
    _dateToController.dispose();
    _timeFromController.dispose();
    _timeToController.dispose();
    _addressController.dispose();
    _latitude.dispose();
    _longitude.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _latitude.text = position.latitude.toString();
      _longitude.text = position.longitude.toString();
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedEvent = UpdateEventModel(
        id: widget.event.id,
        eventName: _nameController.text,
        description: _descriptionController.text,
        dateFrom: _dateFromController.text,
        dateTo: _dateToController.text,
        timeFrom: _timeFromController.text,
        timeTo: _timeToController.text,
        address: _addressController.text,
        latitude: double.parse(_latitude.text),
        longitude: double.parse(_longitude.text),
        eventPhotoFile: _pickedImage,
        eventPhotoPath: widget.event.eventPhotoPath,
      );

      ref.read(eventNotifierProvider.notifier).updateEvent(updatedEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventNotifierProvider);
    ref.listen(eventNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (msg) {
          context.showSuccessSnackBar("Event Edited succesfully.");
          Navigator.pop(context); // go back to profile
          Navigator.pop(context); // go back to profile
        },
        error: (e, _) {
          context.showErrorSnackBar(e.toString());
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Update Event")),
      body: state.when(
        data: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 8,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(50),
                    child: _pickedImage != null
                        ? Image.file(
                            _pickedImage!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : widget.event.eventPhotoPath != null &&
                              widget.event.eventPhotoPath!.isNotEmpty
                        ? Image.network(
                            widget.event.eventPhotoPath!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.camera_alt),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nameController,
                  label: "Event Name",
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),
                CustomTextField(
                  controller: _descriptionController,
                  label: "Description",
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _dateFromController,

                        label: "Date From",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        controller: _dateToController,
                        label: "Date To",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _timeFromController,

                        label: "Time From",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        controller: _timeToController,
                        label: "Time To",
                      ),
                    ),
                  ],
                ),
                CustomTextField(
                  controller: _addressController,
                  label: "Address",
                ),
                Row(
                  spacing: 4,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Latitude',
                        controller: _latitude,
                      ),
                    ),
                    Expanded(
                      child: CustomTextField(
                        label: 'Longitude',
                        controller: _longitude,
                      ),
                    ),
                    AppIconButton(
                      icon: Icons.location_searching_rounded,
                      onPressed: _getCurrentLocation,
                    ),
                  ],
                ),
                // ElevatedButton.icon(
                //   onPressed: _getCurrentLocation,
                //   icon: const Icon(Icons.location_on),
                //   label: const Text("Use Current Location"),
                // ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text("Update Event"),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }
}
