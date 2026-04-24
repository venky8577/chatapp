class ChatModel {
  final String chatId;
  final String otherUid;
  final String otherName;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatModel({
    required this.chatId,
    required this.otherUid,
    required this.otherName,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  static String buildChatId(String uid1, String uid2) {
    final ids = [uid1, uid2]..sort();
    return '${ids[0]}_${ids[1]}';
  }
}
