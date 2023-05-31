class Chat {
  final String chatID;
  final String senderID;
  final String senderImage;
  final String lastMessage;
  final String senderName;
  final bool isRead;

  Chat({
    required this.chatID,
    required this.senderID,
    required this.senderName,
    required this.senderImage,
    required this.lastMessage,
    required this.isRead,
  });

  factory Chat.fromJSON({required Map<String, dynamic> dataMap}) {
    return Chat(
      chatID: dataMap["chat_id"],
      senderID: dataMap["sender_id"],
      senderName: dataMap["sender_name"],
      senderImage: dataMap["sender_image"],
      lastMessage: dataMap["last_message"],
      isRead: dataMap["is_read"] ?? false,
    );
  }
}
