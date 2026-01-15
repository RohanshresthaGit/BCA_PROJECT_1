import 'dart:io';

import 'package:event_management/core/commom/components/components_export.dart';
import 'package:event_management/core/commom/services/image_picker_service.dart';
import 'package:event_management/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/storage/shared_prefs_service.dart';
import '../../../core/commom/utils/spacing.dart';
import '../models/create_event_model.dart';
import '../view_model/event_viewmodel.dart';

class CreateEventPage extends ConsumerStatefulWidget {
  const CreateEventPage({super.key});

  @override
  ConsumerState<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends ConsumerState<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();

  final _eventNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateFromController = TextEditingController();
  final _dateToController = TextEditingController();
  final _timeFromController = TextEditingController();
  final _timeToController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();

  File? _pickedImage;

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  @override
  void dispose() {
    _eventNameController.dispose();
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

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _latitude.text = position.latitude.toString();
      _longitude.text = position.longitude.toString();
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final organizerId = SharedPrefsService.instance.getUserId() ?? 0;

    final request = CreateEventRequest(
      eventName: _eventNameController.text,
      description: _descriptionController.text,
      organizerId: organizerId.toString(), // hardcoded for example
      dateFrom: _dateFromController.text,
      dateTo: _dateToController.text,
      timeFrom: _timeFromController.text,
      timeTo: _timeToController.text,
      address: _addressController.text,
      latitude: double.parse(_latitude.text),
      longitude: double.parse(_longitude.text),
      eventPhotoPath: _pickedImage,
    );

    ref.read(eventNotifierProvider.notifier).addEvent(request);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventNotifierProvider);

    ref.listen<AsyncValue>(eventNotifierProvider, (previous, next) {
      next.when(
        data: (res) {
          if (res.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Event created successfully!")),
            );
            Navigator.pop(context);
          } else if (res.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(res.message!)));
          }
        },
        loading: () {},
        error: (e, st) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString()))),
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text("Create Event")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 8,
            children: [
              GestureDetector(
                onTap: () async {
                  _pickedImage = await ImagePickerService.instance
                      .pickImageFromCamera();
                  setState(() {});
                },
                child: _pickedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(50),
                        child: Image.file(
                          _pickedImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusGeometry.circular(50),

                          color: context.theme.colorScheme.primaryContainer,
                        ),
                        child: Icon(Icons.event),
                      ),
              ),
              Spaces.h24,
              CustomTextField(
                controller: _eventNameController,
                label: "Event Name",
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              CustomTextField(
                controller: _descriptionController,
                label: "Description",
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              CustomTextField(
                controller: _dateFromController,
                label: "Date From (YYYY-MM-DD)",
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              CustomTextField(
                controller: _dateToController,
                label: "Date To (YYYY-MM-DD)",
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              CustomTextField(
                controller: _timeFromController,
                label: "Time From (HH:MM)",
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              CustomTextField(
                controller: _timeToController,
                label: "Time To (HH:MM)",
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              CustomTextField(controller: _addressController, label: "Address"),
              Row(
                spacing: 6,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _latitude,
                      label: 'Latitude',
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller: _longitude,
                      label: 'Longiude',
                    ),
                  ),
                  AppIconButton(
                    icon: Icons.location_searching_sharp,
                    onPressed: _getCurrentLocation,
                  ),
                ],
              ),
              // const SizedBox(height: 10),
              // Row(
              //   children: [
              //     ElevatedButton.icon(
              //       onPressed: _pickImage,
              //       icon: Icon(Icons.image),
              //       label: Text("Pick Image"),
              //     ),
              //     const SizedBox(width: 10),
              //     ElevatedButton.icon(
              //       onPressed: _getCurrentLocation,
              //       icon: Icon(Icons.location_on),
              //       label: Text("Current Location"),
              //     ),
              //   ],
              // ),
              // if (_pickedImage != null)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 8),
              //     child: Image.file(_pickedImage!, height: 150),
              //   ),
              const SizedBox(height: 20),
              state.when(
                data: (_) => ElevatedButton(
                  onPressed: _submit,
                  child: Text("Create Event"),
                ),
                loading: () => CircularProgressIndicator(),
                error: (_, __) =>
                    ElevatedButton(onPressed: _submit, child: Text("Retry")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
