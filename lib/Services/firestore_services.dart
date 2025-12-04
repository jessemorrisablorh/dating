import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  addMessage(
    String chatRoomId,
    String messageId,
    Map<String, dynamic> messageInfoMap,
  ) async {
    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessage(
    String chatRoomId,
    Map<String, dynamic> lastMessageInfoMap,
  ) async {
    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }
}
