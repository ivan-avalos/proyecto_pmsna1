import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkchat/models/favorite.dart';
import 'package:linkchat/models/group.dart';
import 'package:linkchat/models/message.dart';
import 'package:simple_link_preview/simple_link_preview.dart';

import '../models/user.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //
  // USERS
  //

  Future<FsUser?> getUserById(String uid) async {
    var snap = await _firestore.collection('users').doc(uid).get();
    return snap.data() != null ? FsUser.fromMap(snap.data()!) : null;
  }

  Stream<List<FsUser>> getAllUsers() {
    return _firestore.collection('users').snapshots().map<List<FsUser>>((e) {
      return e.docs.map((e) {
        return FsUser.fromMap(e.data());
      }).toList();
    });
  }

  Future<void> saveUser(FsUser user) async {
    await _firestore.collection('users').doc(user.uid).set({
      "uid": user.uid,
      "displayName": user.displayName,
      "photoUrl": user.photoUrl,
      "email": user.email,
    });
  }

  //
  // GROUPS
  //

  Stream<List<Group>> getGroupsByUserID(String uid) {
    return _firestore
        .collection('groups')
        .where('members', arrayContains: uid)
        .snapshots()
        .map<List<Group>>((e) {
      return e.docs.map((e) {
        return Group.fromMap(e.data(), e.id);
      }).toList();
    });
  }

  Future<void> saveGroup(Group group) async {
    await _firestore.collection('groups').add(group.toMap());
  }

  //
  // MESSAGES
  //

  Stream<List<Message>> getMessagesByGroupId(String id) {
    return _firestore
        .collection('messages')
        .doc(id)
        .collection('messages')
        .orderBy('sentAt')
        .snapshots()
        .map<List<Message>>((e) {
      return e.docs.map((e) {
        return Message.fromMap(e.data(), e.id);
      }).toList();
    });
  }

  Future<void> saveMessage(Message msg, String groupId) async {
    LinkPreview? preview = await SimpleLinkPreview.getPreview(msg.messageText);
    await _firestore
        .collection('messages')
        .doc(groupId)
        .collection('messages')
        .add(msg.toMap(preview: preview));
    await _firestore.collection('groups').doc(groupId).update({
      "recentMessage": msg.toMap(preview: preview),
    });
  }

  //
  // FAVORITES
  //

  Stream<List<Favorite>> getFavoritesByUserID(String uid) {
    return _firestore
        .collection('favorites')
        .doc(uid)
        .collection('favorites')
        .orderBy('savedAt', descending: true)
        .snapshots()
        .map<List<Favorite>>(
          (e) => e.docs.map((e) => Favorite.fromMap(e.data())).toList(),
        );
  }

  Stream<bool> hasFavoriteForMessage(String userId, String? messageId) {
    return _firestore
        .collection('favorites')
        .doc(userId)
        .collection('favorites')
        .where('messageId', isEqualTo: messageId)
        .snapshots()
        .map<bool>((e) => e.docs.isNotEmpty);
  }

  Future<void> saveFavorite(Favorite favorite, String userId) {
    return _firestore
        .collection('favorites')
        .doc(userId)
        .collection('favorites')
        .add(favorite.toMap());
  }

  Future<void> removeFavorite(String userId, String? messageId) async {
    CollectionReference reference =
        _firestore.collection('favorites').doc(userId).collection('favorites');
    var favorites =
        await reference.where('messageId', isEqualTo: messageId).get();
    for (var e in favorites.docs) {
      reference.doc(e.id).delete();
    }
  }
}
