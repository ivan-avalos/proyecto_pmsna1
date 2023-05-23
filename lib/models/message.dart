import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_link_preview/simple_link_preview.dart';

class Message {
  final String? id;
  final String messageText;
  final String? linkTitle;
  final String? linkDescription;
  final String? linkPhotoURL;
  final DateTime sentAt;
  final String sentBy;

  const Message({
    this.id,
    required this.messageText,
    this.linkTitle,
    this.linkDescription,
    this.linkPhotoURL,
    required this.sentAt,
    required this.sentBy,
  });

  Map<String, dynamic> toMap({LinkPreview? preview}) {
    return {
      "messageText": messageText,
      "linkTitle": preview?.title,
      "linkDescription": preview?.description,
      "linkPhotoURL": preview?.image,
      "sentAt": sentAt,
      "sentBy": sentBy,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map, String? id) {
    return Message(
      id: id,
      messageText: map['messageText'],
      linkTitle: map['linkTitle'],
      linkDescription: map['linkDescription'],
      linkPhotoURL: map['linkPhotoURL'],
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      sentBy: map['sentBy'],
    );
  }
}
