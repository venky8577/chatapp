import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';
import '../services/database_service.dart';
import 'auth_controller.dart';

class ChatController extends GetxController {
  final DatabaseService _db = DatabaseService();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  late final String chatId;
  late final String otherName;
  late final String otherUid;

  AuthController get _auth => Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    chatId = args['chatId'];
    otherName = args['otherName'];
    otherUid = args['otherUid'];

    _db.messages(chatId).listen((msgs) {
      messages.value = msgs;
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    final user = _auth.currentUser.value!;
    messageController.clear();
    await _db.sendMessage(
      cId: chatId,
      text: text,
      senderId: user.uid,
      senderName: user.displayName,
    );
  }

  Future<void> deleteMessage(String messageId) async {
    await _db.deleteMessage(chatId, messageId);
  }

  bool isMe(String senderId) => senderId == _auth.currentUser.value?.uid;

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
