import 'package:event_management/features/dashboard/model/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/localization/language_provider.dart';
import '../../../config/storage/shared_prefs_service.dart';
import '../../../config/themes/theme_provider.dart';
import '../../../core/commom/components/app_icon_button.dart';
import '../../../core/commom/components/primary_button.dart';
import '../../../core/commom/components/profile_avatar.dart';
import '../../../core/commom/utils/spacing.dart';
import '../../../core/extensions/build_context_extension.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/string_role_extension.dart';
import '../../auth/models/signup_model.dart';
import '../view_model/providers/profile_providers.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key, required this.userId});
  final int userId;

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(fetchProfileProvider(widget.userId));
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(deleteProfileProvider(widget.userId).future).whenComplete(
            () {
              SharedPrefsService.instance.clearAll();
              Navigator.pushReplacementNamed(context, '/login');
            },
          );
        },
        label: Text(context.l10n.delete),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: AppIconButton(
          icon: Icons.logout,
          onPressed: () {
            SharedPrefsService.instance.clearAll();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        actions: [
          AppIconButton(
            icon: Icons.dark_mode,
            onPressed: () {
              final currentTheme = ref.read(themeProvider);
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          AppIconButton(
            icon: Icons.language,
            onPressed: () {
              final currentLocale = ref.read(languageProvider);
              final newLocale = currentLocale.asData?.value.languageCode == 'en'
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
      body: profileState.when(
        loading: () => _loading(),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (data) => data.match(
          (l) => Center(child: Text(l)),
          (data) => RefreshIndicator.adaptive(
            onRefresh: () async {
              ref.refresh(fetchProfileProvider(widget.userId));
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _profileHeader(context, data.profilePicture ?? ''),
                  Spaces.h4,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.fullName ?? 'N/A',
                        style: context.theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (data.role.toUserRole() != UserRole.USER) ...[
                        Spaces.w8,
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 20,
                        ),
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
                  _infoCard(data),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center _loading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _infoCard(UserProfileModel? profile) {
    final email = profile?.email ?? 'N/A';
    final phone = profile?.phone ?? 'N/A';
    final gender = profile?.gender ?? 'N/A';
    final events = profile?.eventsAttended?.toString() ?? '0';

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
              if (profile?.role == UserRole.USER.name)
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
