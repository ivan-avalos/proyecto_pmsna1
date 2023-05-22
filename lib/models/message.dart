import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageText;
  final DateTime sentAt;
  final String sentBy;

  const Message({
    required this.messageText,
    required this.sentAt,
    required this.sentBy,
  });

  Map<String, dynamic> toMap() {
    return {
      "messageText": messageText,
      "sentAt": sentAt,
      "sentBy": sentBy,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageText: map['messageText'],
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      sentBy: map['sentBy'],
    );
  }
}
