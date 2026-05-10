import 'package:firebase_database/firebase_database.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String phone;
  final String role; // 'admin' | 'student'
  final DateTime createdAt;
  final DateTime? lastSeen;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.phone,
    required this.role,
    required this.createdAt,
    this.lastSeen,
  });

  bool get isAdmin => role == 'admin';

  factory UserModel.fromSnapshot(DataSnapshot snap) {
    final data = Map<String, dynamic>.from(snap.value as Map);
    return UserModel(
      uid: snap.key!,
      displayName: data['displayName'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'student',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      lastSeen: data['lastSeen'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['lastSeen'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'displayName': displayName,
        'phone': phone,
        'role': role,
        'createdAt': ServerValue.timestamp,
        'lastSeen': ServerValue.timestamp,
      };
}
