import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/users_list_controller.dart';
import '../../models/user_model.dart';

class UsersListScreen extends GetView<UsersListController> {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Obx(() => Text(
              authCtrl.currentUser.value?.displayName ?? 'Chats',
              style: const TextStyle(color: Colors.white),
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: authCtrl.signOut,
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(controller),
          Expanded(child: _UsersList(controller)),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final UsersListController ctrl;
  const _SearchBar(this.ctrl);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        onChanged: ctrl.onSearch,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search users...',
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

class _UsersList extends StatelessWidget {
  final UsersListController ctrl;
  const _UsersList(this.ctrl);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final users = ctrl.filteredUsers;
      if (users.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.white24),
              SizedBox(height: 12),
              Text(
                'No users found.',
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
        );
      }
      return ListView.separated(
        itemCount: users.length,
        separatorBuilder: (context, index) =>
            const Divider(color: Colors.white12, height: 1, indent: 72),
        itemBuilder: (_, i) => _UserTile(users[i], ctrl),
      );
    });
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final UsersListController ctrl;
  const _UserTile(this.user, this.ctrl);

  @override
  Widget build(BuildContext context) {
    final initials = user.displayName.isNotEmpty
        ? user.displayName[0].toUpperCase()
        : '?';
    final lastSeenText = user.lastSeen != null
        ? 'Last seen ${DateFormat('HH:mm').format(user.lastSeen!)}'
        : 'Tap to chat';

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
      title: Text(
        user.displayName,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        lastSeenText,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
      trailing: const Icon(Icons.chat_bubble_outline,
          color: Color(0xFF6C63FF), size: 20),
      onTap: () => ctrl.openChat(user),
    );
  }
}
