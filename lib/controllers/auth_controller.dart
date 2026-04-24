import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _authService.authStateChanges.listen(
        (User? u) => _onAuthStateChanged(u));
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      currentUser.value = null;
      if (Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed(AppRoutes.login);
      }
    } else {
      UserModel? profile =
          await _authService.fetchUserProfile(firebaseUser.uid);

      // profile లేకపోతే (new signup race condition) — fallback UserModel
      if (profile == null) {
        await FirebaseDatabase.instance
            .ref('users/${firebaseUser.uid}')
            .set({
          'displayName': firebaseUser.displayName ?? firebaseUser.email ?? 'User',
          'email': firebaseUser.email ?? '',
          'createdAt': ServerValue.timestamp,
          'lastSeen': ServerValue.timestamp,
        });
        profile = UserModel(
          uid: firebaseUser.uid,
          displayName: firebaseUser.displayName ??
              firebaseUser.email ??
              'User',
          email: firebaseUser.email ?? '',
          createdAt: DateTime.now(),
        );
      }

      currentUser.value = profile;
      if (Get.currentRoute != AppRoutes.usersList) {
        Get.offAllNamed(AppRoutes.usersList);
      }
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.signIn(email: email, password: password);
    } catch (e) {
      Get.snackbar('Login Failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String email, String password, String displayName) async {
    try {
      isLoading.value = true;
      await _authService.signUp(
          email: email, password: password, displayName: displayName);
    } catch (e) {
      Get.snackbar('Sign Up Failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
