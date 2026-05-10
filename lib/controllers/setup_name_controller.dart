import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class SetupNameController extends GetxController {
  final nameController = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<void> save() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Required', 'Please enter your name',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isLoading.value = true;
    await Get.find<AuthController>().completeSetup(name);
    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
