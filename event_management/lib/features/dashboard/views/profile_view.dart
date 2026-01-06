import 'package:event_management/core/commom/components/components_export.dart';
import 'package:event_management/core/extensions/context_extensions.dart';
import 'package:event_management/features/dashboard/view_model/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/localization/language_provider.dart';
import '../../../config/themes/theme_provider.dart';
import '../../../core/commom/utils/spacing.dart';
import '../../../core/extensions/build_context_extension.dart';
import '../../../core/extensions/string_role_extension.dart';
import '../../auth/models/signup_model.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key, required this.userId});
  final int userId; // Example user ID

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(futureProfileModelProvider(widget.userId));
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          AppIconButton(
            icon: Icons.dark_mode,
            onPressed: () {
              final currentTheme = ref.read(themeProvider);
              ref.read(themeProvider.notifier).switchMode(!currentTheme);
            },
          ),
          AppIconButton(
            icon: Icons.language,
            onPressed: () {
              final currentLocale = ref.read(languageProvider);
              final newLocale = currentLocale.languageCode == 'en'
                  ? const Locale('ne')
                  : const Locale('en');
              ref
                  .read(languageProvider.notifier)
                  .changeLanguage(newLocale.languageCode);
            },
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          context.l10n.profile,
          style: context.theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: profile.when(
        data: (data) => data.match(
          (error) => Center(child: Text(error)),
          (success) => SingleChildScrollView(
            child: Column(
              children: [
                _profileHeader(context, success.profilePicture ?? ''),
                Spaces.h4,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      success.fullName ?? 'N/A',
                      style: context.theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (success.role.toUserRole() != UserRole.USER) ...[
                      Spaces.w8,
                      const Icon(Icons.verified, color: Colors.blue, size: 20),
                    ],
                  ],
                ),
                Spaces.h16,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.personalInformation,
                        style: context.theme.textTheme.titleLarge,
                      ),
                      AppTextButtonIcon(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.edit),
                        label: context.l10n.editProfile,
                        onPressed: () {
                          context.pushNamed(
                            '/editProfile',
                            arguments: {'userId': widget.userId.toString()},
                          );
                        },
                        end: true,
                      ),
                    ],
                  ),
                ),
                _infoCard(success),
              ],
            ),
          ),
        ),
        loading: () => _loading(),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }

  Center _loading() {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          Spaces.h16,
          Text('Loading profile...'),
        ],
      ),
    );
  }

  Stack _profileHeader(BuildContext context, String profilePicture) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.inversePrimary,
                borderRadius: BorderRadius.only(
                  bottomLeft: BorderCurve.md,
                  bottomRight: BorderCurve.md,
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
        Positioned(
          bottom: 0,
          left: context.width / 2 - 50,
          child: ProfileAvatar(radius: 50, imageUrl: profilePicture),
        ),
      ],
    );
  }

  Widget _infoCard(dynamic profile) {
    // profile is UserProfileModel
    final email = profile.email ?? 'N/A';
    final phone = profile.phone ?? 'N/A';
    final gender = profile.gender ?? 'N/A';
    final events = profile.eventsAttended?.toString() ?? '0';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.email),
                title: Text(context.l10n.email),
                subtitle: Text(email),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.phone),
                title: Text(context.l10n.phone),
                subtitle: Text(phone),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person_2),
                title: Text(context.l10n.gender),
                subtitle: Text(gender),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: Text(context.l10n.eventsAttended),
                subtitle: Text(events),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
