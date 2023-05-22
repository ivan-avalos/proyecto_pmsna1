import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkchat/models/group.dart';
import 'package:linkchat/models/message.dart';

import '../models/user.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Stream<List<Message>> getMessagesByGroupId(String id) {
    return _firestore
        .collection('messages')
        .doc(id)
        .collection('messages')
        .orderBy('sentAt')
        .snapshots()
        .map<List<Message>>((e) {
      return e.docs.map((e) {
        return Message.fromMap(e.data());
      }).toList();
    });
  }

  Future<void> saveMessage(Message msg, String groupId) async {
    await _firestore
        .collection('messages')
        .doc(groupId)
        .collection('messages')
        .add(msg.toMap());
    await _firestore.collection('groups').doc(groupId).update({
      "recentMessage": msg.toMap(),
    });
  }

  Future<void> saveGroup(Group group) async {
    await _firestore.collection('groups').add(group.toMap());
  }
}
