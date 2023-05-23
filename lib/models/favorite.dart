import 'package:cloud_firestore/cloud_firestore.dart';

import 'message.dart';

class Favorite {
  final String groupId;
  final String messageId;
  final DateTime savedAt;

  final String messageText;
  final String? linkTitle;
  final String? linkDescription;
  final String? linkPhotoURL;
  final DateTime sentAt;
  final String sentBy;

  const Favorite({
    required this.groupId,
    required this.messageId,
    required this.savedAt,
    required this.messageText,
    required this.linkTitle,
    required this.linkDescription,
    required this.linkPhotoURL,
    required this.sentAt,
    required this.sentBy,
  });

  Map<String, dynamic> toMap() => {
        "groupId": groupId,
        "messageId": messageId,
        "savedAt": savedAt,
        "messageText": messageText,
        "linkTitle": linkTitle,
        "linkDescription": linkDescription,
        "linkPhotoURL": linkPhotoURL,
        "sentAt": sentAt,
        "sentBy": sentBy,
      };

  Message getMessage() => Message(
        messageText: messageText,
        linkTitle: linkTitle,
        linkDescription: linkDescription,
        linkPhotoURL: linkPhotoURL,
        sentAt: sentAt,
        sentBy: sentBy,
      );

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      groupId: map['groupId'],
      messageId: map['messageId'],
      savedAt: (map['savedAt'] as Timestamp).toDate(),
      messageText: map['messageText'],
      linkTitle: map['linkTitle'],
      linkDescription: map['linkDescription'],
      linkPhotoURL: map['linkPhotoURL'],
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      sentBy: map['sentBy'],
    );
  }
}
