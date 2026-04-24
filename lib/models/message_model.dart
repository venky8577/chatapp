import 'package:firebase_database/firebase_database.dart';

class MessageModel {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.createdAt,
  });

  factory MessageModel.fromSnapshot(DataSnapshot snap) {
    final data = Map<String, dynamic>.from(snap.value as Map);
    return MessageModel(
      id: snap.key!,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toMap() => {
        'text': text,
        'senderId': senderId,
        'senderName': senderName,
        'createdAt': ServerValue.timestamp,
      };
}
