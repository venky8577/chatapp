import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/chat_controller.dart';
import '../../models/message_model.dart';

class ChatRoomScreen extends GetView<ChatController> {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF6C63FF),
              child: Text(
                controller.otherName.isNotEmpty
                    ? controller.otherName[0].toUpperCase()
                    : '?',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(width: 10),
            Text(controller.otherName,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(
                  child: Text(
                    'No messages yet.\nSay hi! 👋',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                itemCount: controller.messages.length,
                itemBuilder: (_, i) =>
                    _MessageBubble(controller.messages[i], controller),
              );
            }),
          ),
          _InputBar(controller),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel msg;
  final ChatController ctrl;

  const _MessageBubble(this.msg, this.ctrl);

  @override
  Widget build(BuildContext context) {
    final isMe = ctrl.isMe(msg.senderId);
    final time = DateFormat('HH:mm').format(msg.createdAt);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: isMe ? () => _confirmDelete(context) : null,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72),
          decoration: BoxDecoration(
            color: isMe
                ? const Color(0xFF6C63FF)
                : const Color(0xFF16213E),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(msg.text,
                  style:
                      const TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(height: 4),
              Text(time,
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    Get.defaultDialog(
      title: 'Delete Message',
      middleText: 'Delete this message?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        ctrl.deleteMessage(msg.id);
      },
    );
  }
}

class _InputBar extends StatelessWidget {
  final ChatController ctrl;
  const _InputBar(this.ctrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF16213E),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: ctrl.messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF0F3460),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
              ),
              onSubmitted: (_) => ctrl.sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: ctrl.sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF6C63FF),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
