import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/otp_controller.dart';

class PhoneLoginScreen extends GetView<OtpController> {
  const PhoneLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Obx(() => controller.step.value == OtpStep.phoneEntry
                ? _PhoneEntry(controller)
                : _OtpEntry(controller)),
          ),
        ),
      ),
    );
  }
}

class _PhoneEntry extends StatelessWidget {
  final OtpController ctrl;
  const _PhoneEntry(this.ctrl);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.apartment_rounded, size: 72, color: Color(0xFF6C63FF)),
        const SizedBox(height: 16),
        const Text(
          'SVH Hostel',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        const Text(
          'Maintenance Portal',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.white54),
        ),
        const SizedBox(height: 40),
        _inputField(
          controller: ctrl.phoneController,
          label: 'Phone Number',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          hint: '+91XXXXXXXXXX',
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter your phone number with country code (+91 added automatically if omitted)',
          style: TextStyle(color: Colors.white38, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Obx(() {
          final err = ctrl.error.value;
          if (err.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(err,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                textAlign: TextAlign.center),
          );
        }),
        Obx(() => ElevatedButton(
              onPressed: ctrl.isLoading.value ? null : ctrl.sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: ctrl.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Send OTP',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
            )),
      ],
    );
  }
}

class _OtpEntry extends StatelessWidget {
  final OtpController ctrl;
  const _OtpEntry(this.ctrl);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.sms_rounded, size: 64, color: Color(0xFF6C63FF)),
        const SizedBox(height: 16),
        const Text(
          'Enter OTP',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Obx(() => Text(
              'OTP sent to ${ctrl.phoneController.text.trim()}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            )),
        const SizedBox(height: 32),
        _inputField(
          controller: ctrl.otpController,
          label: '6-digit OTP',
          icon: Icons.lock_outline,
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        const SizedBox(height: 8),
        Obx(() {
          final err = ctrl.error.value;
          if (err.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(err,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                textAlign: TextAlign.center),
          );
        }),
        Obx(() => ElevatedButton(
              onPressed: ctrl.isLoading.value ? null : ctrl.verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: ctrl.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Verify OTP',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
            )),
        const SizedBox(height: 12),
        TextButton(
          onPressed: ctrl.goBack,
          child: const Text('Change Phone Number',
              style: TextStyle(color: Color(0xFF6C63FF))),
        ),
      ],
    );
  }
}

Widget _inputField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  String? hint,
  int? maxLength,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    maxLength: maxLength,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white54),
      hintStyle: const TextStyle(color: Colors.white24),
      prefixIcon: Icon(icon, color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF16213E),
      counterStyle: const TextStyle(color: Colors.white38),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
