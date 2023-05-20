import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadAvatar(String userId, File file) async {
    String filename = basename(file.path);
    Reference ref = _storage.ref().child(userId).child(filename);
    UploadTask task = ref.putFile(file);
    await task.whenComplete(() => {});
    return await ref.getDownloadURL();
  }
}
