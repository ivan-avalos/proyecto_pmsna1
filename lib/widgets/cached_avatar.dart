import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedAvatar extends StatelessWidget {
  final String? avatarUrl;
  const CachedAvatar(this.avatarUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage:
          avatarUrl != null ? CachedNetworkImageProvider(avatarUrl!) : null,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: avatarUrl == null
          ? Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onPrimary,
            )
          : null,
    );
  }
}
