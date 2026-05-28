import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/student_home_controller.dart';
import '../../models/user_model.dart';

class StudentHomeScreen extends GetView<StudentHomeController> {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('VHostel',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text(
                  authCtrl.currentUser.value?.displayName ?? '',
                  style:
                      const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: authCtrl.signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)));
        }
        if (controller.admins.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.support_agent, size: 64, color: Colors.white24),
                SizedBox(height: 12),
                Text('No admins available yet.',
                    style: TextStyle(color: Colors.white54)),
                SizedBox(height: 4),
                Text('Please contact the hostel office.',
                    style: TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                'HOSTEL ADMINS',
                style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.admins.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _AdminCard(
                  admin: controller.admins[i],
                  onTap: () => controller.openChat(controller.admins[i]),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Color(0xFF6C63FF), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Report hostel maintenance issues, complaints, or requests directly to any admin.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final UserModel admin;
  final VoidCallback onTap;
  const _AdminCard({required this.admin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final initials =
        admin.displayName.isNotEmpty ? admin.displayName[0].toUpperCase() : 'A';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF6C63FF),
              child: Text(initials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(admin.displayName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Hostel Admin',
                      style: TextStyle(
                          color: Color(0xFF6C63FF), fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chat_bubble_rounded,
                color: Color(0xFF6C63FF)),
          ],
        ),
      ),
    );
  }
}
