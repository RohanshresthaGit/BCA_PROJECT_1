import 'dart:convert';
import 'dart:io';

import 'package:event_management/core/commom/components/components_export.dart';
import 'package:event_management/core/commom/services/image_picker_service.dart';
import 'package:event_management/core/commom/utils/spacing.dart';
import 'package:event_management/features/dashboard/model/update_profile_model.dart';
import 'package:event_management/features/dashboard/view_model/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/storage/shared_prefs_service.dart';
import '../../../core/constants/shared_constants.dart';
import '../../../core/extensions/build_context_extension.dart';
import '../../../core/extensions/context_extensions.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key, required this.userId});
  final int userId;

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final ValueNotifier<String> _gender;
  String? _profilePicturePath;
  File? _newProfilePicture;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _gender = ValueNotifier<String>("Male");
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSavedProfile());
  }

  void _pickProfilePicture() async {
    final pickedFile = await ImagePickerService.instance.pickImageFromCamera();
    if (pickedFile != null) {
      setState(() {
        _newProfilePicture = pickedFile;
      });
    }
  }

  Future<void> _loadSavedProfile() async {
    await SharedPrefsService.instance.init();
    // Try to load full user details if stored as JSON
    final userJson = SharedPrefsService.instance.getString(
      SharedConstants.userDetails,
    );
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(userJson);
        final fullName = data['fullName'] as String?;
        final email = data['email'] as String?;
        final phone = data['phone'] as String?;
        final gender = data['gender'] as String?;
        _profilePicturePath = data['profilePicture'] as String?;
        if (fullName != null) _nameController.text = fullName;
        if (email != null) _emailController.text = email;
        if (phone != null) _phoneController.text = phone;
        if (gender != null) _gender.value = gender;
        return;
      } catch (_) {}
    }

    // Fallback to individual saved values
    final savedEmail = SharedPrefsService.instance.getEmail();
    if (savedEmail != null) _emailController.text = savedEmail;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _gender.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.showSuccessSnackBar('Profile saved');
    }
    final req = UpdateProfileRequest(
      userId: widget.userId,
      fullName: _nameController.text.trim(),
      phoneNumber: _phoneController.text,
      gender: _gender.value,
      profilePhoto: _newProfilePicture,
    );
    ref.read(profileNotifierProvider.notifier).updateProfile(req);
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return null; // optional field

    final value = v.trim();

    final nepaliPhoneRegex = RegExp(r'^(?:\+977|977)?9[78]\d{8}$');

    if (!nepaliPhoneRegex.hasMatch(value)) {
      return 'Invalid Nepali phone number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(profileNotifierProvider);
    ref.listen(profileNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (msg) {
          if (msg == null) return;
          context.showSuccessSnackBar(msg);
          Navigator.pop(context); // go back to profile
        },
        error: (e, _) {
          context.showErrorSnackBar(e.toString());
        },
      );
    });
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.editProfile)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickProfilePicture,
                  child: (_newProfilePicture != null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _newProfilePicture!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : (_profilePicturePath != null &&
                            _profilePicturePath!.isNotEmpty)
                      ? ProfileAvatar(
                          radius: 50,
                          imageUrl: _profilePicturePath!,
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.primary
                                .withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                ),
                Spaces.h24,
                CustomTextField(
                  controller: _nameController,
                  label: context.l10n.fullName,
                  hintText: 'John Doe',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Name is required';
                    }
                    if (v.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  readOnly: true,
                  controller: _emailController,
                  label: context.l10n.email,
                  hintText: 'user@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _phoneController,
                  label: context.l10n.phone,
                  hintText: '+1234567890',
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: _gender,
                  builder: (context, value, child) {
                    return SizedBox(
                      height: 50,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: context.l10n.gender,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            padding: EdgeInsets.zero,
                            value: value,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(
                                value: "Male",
                                child: Text(context.l10n.male),
                              ),
                              DropdownMenuItem(
                                value: "Female",
                                child: Text(context.l10n.female),
                              ),
                              DropdownMenuItem(
                                value: "Other",
                                child: Text(context.l10n.other),
                              ),
                            ],
                            onChanged: (value) =>
                                _gender.value = value ?? _gender.value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: updateState.isLoading
                      ? context.l10n.saving
                      : context.l10n.save,
                  loading: updateState.isLoading,
                  onPressed: updateState.isLoading ? null : _saveProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
