import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final RxBool isSignUp = false.obs;
  final RxBool obscurePassword = true.obs;

  AuthController get _auth => Get.find<AuthController>();

  void toggleMode() => isSignUp.value = !isSignUp.value;
  void togglePassword() => obscurePassword.value = !obscurePassword.value;

  Future<void> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and password are required',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (isSignUp.value) {
      final name = nameController.text.trim();
      if (name.isEmpty) {
        Get.snackbar('Error', 'Display name is required',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      await _auth.signUp(email, password, name);
    } else {
      await _auth.signIn(email, password);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
