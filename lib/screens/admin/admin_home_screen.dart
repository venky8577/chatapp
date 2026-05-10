import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/admin_home_controller.dart';
import '../../models/user_model.dart';

class AdminHomeScreen extends GetView<AdminHomeController> {
  const AdminHomeScreen({super.key});

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
                const Text('SVH Hostel — Admin',
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
      body: Column(
        children: [
          _SearchBar(controller),
          Expanded(child: _StudentsList(controller)),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final AdminHomeController ctrl;
  const _SearchBar(this.ctrl);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        onChanged: ctrl.onSearch,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search students by name or phone...',
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: const Icon(Icons.search, color: Colors.white38),
          filled: true,
          fillColor: const Color(0xFF16213E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }
}

class _StudentsList extends StatelessWidget {
  final AdminHomeController ctrl;
  const _StudentsList(this.ctrl);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final students = ctrl.filteredStudents;
      if (students.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.people_outline,
                  size: 64, color: Colors.white24),
              const SizedBox(height: 12),
              Text(
                ctrl.searchQuery.value.isEmpty
                    ? 'No students have logged in yet.'
                    : 'No students found.',
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),
        );
      }
      return ListView.separated(
        itemCount: students.length,
        separatorBuilder: (context, index) =>
            const Divider(color: Colors.white12, height: 1, indent: 72),
        itemBuilder: (_, i) => _StudentTile(students[i], ctrl),
      );
    });
  }
}

class _StudentTile extends StatelessWidget {
  final UserModel student;
  final AdminHomeController ctrl;
  const _StudentTile(this.student, this.ctrl);

  @override
  Widget build(BuildContext context) {
    final initials = student.displayName.isNotEmpty
        ? student.displayName[0].toUpperCase()
        : '?';
    final subtitle = student.lastSeen != null
        ? 'Last seen ${DateFormat('dd MMM, HH:mm').format(student.lastSeen!)}'
        : student.phone;

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: const Color(0xFF6C63FF),
        child: Text(initials,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      title: Text(student.displayName,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: const TextStyle(color: Colors.white54, fontSize: 12)),
      trailing: const Icon(Icons.chat_bubble_outline,
          color: Color(0xFF6C63FF), size: 20),
      onTap: () => ctrl.openChat(student),
    );
  }
}
