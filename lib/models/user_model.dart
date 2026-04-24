import 'package:firebase_database/firebase_database.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final DateTime createdAt;
  final DateTime? lastSeen;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.createdAt,
    this.lastSeen,
  });

  factory UserModel.fromSnapshot(DataSnapshot snap) {
    final data = Map<String, dynamic>.from(snap.value as Map);
    return UserModel(
      uid: snap.key!,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      lastSeen: data['lastSeen'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['lastSeen'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'displayName': displayName,
        'email': email,
        'createdAt': ServerValue.timestamp,
        'lastSeen': ServerValue.timestamp,
      };
}
