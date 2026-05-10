import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  /// Reads admin phone numbers from /config/adminPhones in Firebase.
  /// Store them there (via Firebase Console) as a list or map of E.164 strings.
  Future<List<String>> fetchAdminPhones() async {
    final snap = await _db.child('config/adminPhones').get();
    if (!snap.exists || snap.value == null) return [];
    final data = snap.value;
    if (data is List) return data.whereType<String>().toList();
    if (data is Map) return data.values.whereType<String>().toList();
    return [];
  }

  Future<UserModel?> fetchUserProfile(String uid) async {
    final snap = await _db.child('users/$uid').get();
    if (!snap.exists) return null;
    return UserModel.fromSnapshot(snap);
  }

  Future<UserModel> createProfile({
    required String uid,
    required String phone,
    required String role,
    required String displayName,
  }) async {
    await _db.child('users/$uid').set({
      'displayName': displayName,
      'phone': phone,
      'role': role,
      'createdAt': ServerValue.timestamp,
      'lastSeen': ServerValue.timestamp,
    });
    return UserModel(
      uid: uid,
      displayName: displayName,
      phone: phone,
      role: role,
      createdAt: DateTime.now(),
    );
  }

  Future<void> updateLastSeen(String uid) async {
    await _db.child('users/$uid/lastSeen').set(ServerValue.timestamp);
  }

  Future<void> signOut() => _auth.signOut();
}
