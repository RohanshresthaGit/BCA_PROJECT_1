import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_management/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Widget? placeholder;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.radius = 24.0,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        radius: radius,
        child:
            placeholder ??
            Icon(
              Icons.person,
              size: radius - 10,
              color: context.theme.colorScheme.inversePrimary,
            ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: null,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: radius * 2 - 10,
          height: radius * 2 - 10,
          fit: BoxFit.cover,
          placeholder: (_, __) =>
              placeholder ??
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          errorWidget: (_, __, ___) => Icon(
            Icons.person,
            size: radius - 10,
            color: context.theme.colorScheme.inversePrimary,
          ),
        ),
      ),
    );
  }
}
