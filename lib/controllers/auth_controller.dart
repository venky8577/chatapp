import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  // Held between OTP sign-in and name setup for new users
  String _pendingPhone = '';
  String _pendingRole = '';

  @override
  void onInit() {
    super.onInit();
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      currentUser.value = null;
      if (Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed(AppRoutes.login);
      }
      return;
    }

    isLoading.value = true;
    try {
      final adminPhones = await _authService.fetchAdminPhones();
      final phone = firebaseUser.phoneNumber ?? '';
      final role = adminPhones.contains(phone) ? 'admin' : 'student';

      final profile = await _authService.fetchUserProfile(firebaseUser.uid);

      if (profile == null) {
        // New user — collect name first
        _pendingPhone = phone;
        _pendingRole = role;
        Get.offAllNamed(AppRoutes.setupName);
      } else {
        await _authService.updateLastSeen(firebaseUser.uid);
        currentUser.value = profile;
        _navigateHome(profile.isAdmin);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Called by SetupNameController after the user enters their display name.
  Future<void> completeSetup(String displayName) async {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser == null) return;
    isLoading.value = true;
    try {
      final profile = await _authService.createProfile(
        uid: firebaseUser.uid,
        phone: _pendingPhone,
        role: _pendingRole,
        displayName: displayName,
      );
      currentUser.value = profile;
      _navigateHome(profile.isAdmin);
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateHome(bool isAdmin) {
    final target = isAdmin ? AppRoutes.adminHome : AppRoutes.studentHome;
    if (Get.currentRoute != target) Get.offAllNamed(target);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
