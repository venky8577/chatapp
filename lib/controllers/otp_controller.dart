import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

enum OtpStep { phoneEntry, otpEntry }

class OtpController extends GetxController {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final Rx<OtpStep> step = OtpStep.phoneEntry.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  String _verificationId = '';

  Future<void> sendOtp() async {
    final raw = phoneController.text.trim();
    if (raw.isEmpty) {
      error.value = 'Please enter your phone number';
      return;
    }
    // Prepend +91 if no country code provided
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
    // AuthController auth-state listener handles profile fetch and navigation
  }

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
