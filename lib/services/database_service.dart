import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';

class DatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  String chatId(String uid1, String uid2) {
    final ids = [uid1, uid2]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  // All students — used by admin home screen
  Stream<List<UserModel>> allStudents(String currentUid) {
    return _db
        .child('users')
        .orderByChild('role')
        .equalTo('student')
        .onValue
        .map((event) {
      final snap = event.snapshot;
      if (!snap.exists || snap.value == null) return [];
      final map = Map<String, dynamic>.from(snap.value as Map);
      return map.keys
          .where((key) => key != currentUid)
          .map((key) => UserModel.fromSnapshot(snap.child(key)))
          .toList()
        ..sort((a, b) => a.displayName.compareTo(b.displayName));
    });
  }

  // All admins — used by student home screen
  Stream<List<UserModel>> adminUsers() {
    return _db
        .child('users')
        .orderByChild('role')
        .equalTo('admin')
        .onValue
        .map((event) {
      final snap = event.snapshot;
      if (!snap.exists || snap.value == null) return [];
      final map = Map<String, dynamic>.from(snap.value as Map);
      return map.keys
          .map((key) => UserModel.fromSnapshot(snap.child(key)))
          .toList()
        ..sort((a, b) => a.displayName.compareTo(b.displayName));
    });
  }

  Future<void> updateLastSeen(String uid) async {
    await _db.child('users/$uid/lastSeen').set(ServerValue.timestamp);
  }

  Stream<List<MessageModel>> messages(String cId) {
    return _db
        .child('chats/$cId/messages')
        .orderByChild('createdAt')
        .onValue
        .map((event) {
      final snap = event.snapshot;
      if (!snap.exists || snap.value == null) return [];
      final map = Map<String, dynamic>.from(snap.value as Map);
      return map.keys
          .map((key) => MessageModel.fromSnapshot(snap.child(key)))
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    });
  }

  Future<void> sendMessage({
    required String cId,
    required String text,
    required String senderId,
    required String senderName,
  }) async {
    final msgRef = _db.child('chats/$cId/messages').push();
    await msgRef.set({
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'createdAt': ServerValue.timestamp,
    });
    await _db.child('chats/$cId/lastMessage').set({
      'text': text,
      'senderId': senderId,
      'createdAt': ServerValue.timestamp,
    });
  }

  Future<void> deleteMessage(String cId, String messageId) async {
    await _db.child('chats/$cId/messages/$messageId').remove();
  }
}
