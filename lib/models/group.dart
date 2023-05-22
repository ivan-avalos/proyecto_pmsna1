import 'package:cloud_firestore/cloud_firestore.dart';

import 'message.dart';

class Group {
  final String? id;
  final String? name;
  final Message? recentMessage;
  final List<String> members;
  final String createdBy;
  final DateTime createdAt;

  const Group({
    this.id,
    this.name,
    this.recentMessage,
    this.members = const [],
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "recentMessage": recentMessage,
      "members": members,
      "createdBy": createdBy,
      "createdAt": createdAt,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map, String id) {
    List<dynamic> members = map['members'];
    return Group(
      id: id,
      name: map['name'],
      recentMessage: map['recentMessage'] != null
          ? Message.fromMap(map['recentMessage'])
          : null,
      members: members.map((m) => m.toString()).toList(),
      createdBy: map['createdBy'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
