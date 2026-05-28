import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

enum OtpStep { phoneEntry, otpEntry }

class OtpController extends GetxController {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final Rx<OtpStep> step = OtpStep.phoneEntry.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // String _verificationId = ''; // uncomment when switching back to OTP

  // ═══════════════════════════════════════════════════════════════════════
  // TESTING MODE — login by phone number only (no OTP)
  // NOTE: Enable Email/Password sign-in in Firebase Console first.
  // To switch to real OTP: delete this block, uncomment the OTP block below.
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> sendOtp() async {
    final raw = phoneController.text.trim();
    if (raw.isEmpty) {
      error.value = 'Please enter your phone number';
      return;
    }

    // Normalise to plain 10-digit number
    final phone = raw.startsWith('+91')
        ? raw.replaceFirst('+91', '')
        : raw.startsWith('+')
            ? raw.substring(raw.length > 10 ? raw.length - 10 : 0)
            : raw;

    isLoading.value = true;
    error.value = '';

    try {
      // Tell AuthController the phone before sign-in (role check for new users)
      Get.find<AuthController>().setPendingPhone(phone);

      final email = '$phone@svh.hostel';
      const password = 'SVHtest@2024';

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' ||
            e.code == 'invalid-credential' ||
            e.code == 'INVALID_LOGIN_CREDENTIALS' ||
            e.message?.contains('no user record') == true) {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
        } else {
          rethrow;
        }
      }
    } on FirebaseAuthException catch (e) {
      error.value = e.message ?? 'Login failed. Try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // REAL OTP MODE — uncomment after testing is done
  // ═══════════════════════════════════════════════════════════════════════
  /*
  Future<void> sendOtp() async {
    final raw = phoneController.text.trim();
    if (raw.isEmpty) {
      error.value = 'Please enter your phone number';
      return;
    }
    final phone = raw.startsWith('+') ? raw : '+91$raw';
    isLoading.value = true;
    error.value = '';

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _signIn(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        isLoading.value = false;
        error.value = e.message ?? 'Verification failed. Check phone number.';
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        isLoading.value = false;
        step.value = OtpStep.otpEntry;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> verifyOtp() async {
    final code = otpController.text.trim();
    if (code.length != 6) {
      error.value = 'Enter the 6-digit OTP';
      return;
    }
    isLoading.value = true;
    error.value = '';
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: code,
      );
      await _signIn(credential);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      error.value = e.message ?? 'Invalid OTP. Try again.';
    }
  }

  Future<void> _signIn(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
    isLoading.value = false;
  }
  */

  void goBack() {
    step.value = OtpStep.phoneEntry;
    otpController.clear();
    error.value = '';
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
