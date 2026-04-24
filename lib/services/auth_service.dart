import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;
    await _db.child('users/$uid').set({
      'displayName': displayName,
      'email': email,
      'createdAt': ServerValue.timestamp,
      'lastSeen': ServerValue.timestamp,
    });
    return UserModel(
      uid: uid,
      displayName: displayName,
      email: email,
      createdAt: DateTime.now(),
    );
  }

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return fetchUserProfile(_auth.currentUser!.uid);
  }

  Future<void> signOut() => _auth.signOut();

  Future<UserModel?> fetchUserProfile(String uid) async {
    final snap = await _db.child('users/$uid').get();
    if (!snap.exists) return null;
    return UserModel.fromSnapshot(snap);
  }
}
