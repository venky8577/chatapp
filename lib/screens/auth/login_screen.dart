import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.chat_bubble_rounded,
                        size: 64, color: Color(0xFF6C63FF)),
                    const SizedBox(height: 16),
                    Text(
                      controller.isSignUp.value ? 'Create Account' : 'Welcome Back',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (controller.isSignUp.value)
                      _field(
                        controller: controller.nameController,
                        label: 'Display Name',
                        icon: Icons.person,
                      ),

                    const SizedBox(height: 12),

                    _field(
                      controller: controller.emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 12),

                    Obx(() => _field(
                          controller: controller.passwordController,
                          label: 'Password',
                          icon: Icons.lock,
                          obscure: controller.obscurePassword.value,
                          suffix: IconButton(
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white54,
                            ),
                            onPressed: controller.togglePassword,
                          ),
                        )),

                    const SizedBox(height: 24),

                    Obx(() {
                      final isLoading =
                          Get.find<AuthController>().isLoading.value;
                      return ElevatedButton(
                        onPressed: isLoading ? null : controller.submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : Text(
                                controller.isSignUp.value
                                    ? 'Sign Up'
                                    : 'Login',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                      );
                    }),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: controller.toggleMode,
                      child: Obx(() => Text(
                            controller.isSignUp.value
                                ? 'Already have an account? Login'
                                : "Don't have an account? Sign Up",
                            style: const TextStyle(color: Color(0xFF6C63FF)),
                          )),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFF16213E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
