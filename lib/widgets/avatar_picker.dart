import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatelessWidget {
  final ImagePicker picker = ImagePicker();
  final XFile? avatar;
  final Function(XFile? avatar) onAvatarPicked;

  AvatarPicker({
    super.key,
    required this.avatar,
    required this.onAvatarPicked,
  });

  File? _getAvatarFile() {
    return avatar == null ? null : File(avatar!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50.0,
          backgroundImage:
              _getAvatarFile() == null ? null : FileImage(_getAvatarFile()!),
          child: _getAvatarFile() == null
              ? const Icon(Icons.person, size: 50.0)
              : null,
        ),
        const SizedBox(width: 18.0),
        Column(
          children: [
            FilledButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Cámara'),
              onPressed: () {
                picker.pickImage(source: ImageSource.camera).then((image) {
                  onAvatarPicked(image);
                });
              },
            ),
            const SizedBox(height: 16.0),
            FilledButton.icon(
              icon: const Icon(Icons.collections),
              label: const Text('Galería'),
              onPressed: () {
                picker.pickImage(source: ImageSource.gallery).then((image) {
                  onAvatarPicked(image);
                });
              },
            )
          ],
        )
      ],
    );
  }
}
