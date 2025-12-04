import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Widgets/header_widget.dart';
import 'package:dating_app/Widgets/side_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SingleUserMessagesPage extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;
  const SingleUserMessagesPage({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  State<SingleUserMessagesPage> createState() => _SingleUserMessagesPageState();
}

class _SingleUserMessagesPageState extends State<SingleUserMessagesPage> {
  final TextEditingController _controller = TextEditingController();
  bool sendingmessage = false;

  /// Send a message to Firestore
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();

    final chatRef = FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatId);

    final timestamp = FieldValue.serverTimestamp();

    // 1. Add to messages subcollection
    await chatRef.collection("messages").add({
      "fromUid": widget.currentUserId,
      "toUid": widget.otherUserId,
      "message": text,
      "timestamp": timestamp,
    });

    // 2. Update sender’s chat list
    await FirebaseFirestore.instance
        .collection("chatList")
        .doc(widget.currentUserId)
        .collection("users")
        .doc(widget.otherUserId)
        .set({
          "uid": widget.otherUserId,
          "lastMessage": text,
          "timestamp": timestamp,
          "isRead": true, // sender already "read" it
        }, SetOptions(merge: true));

    // 3. Update receiver’s chat list
    await FirebaseFirestore.instance
        .collection("chatList")
        .doc(widget.otherUserId)
        .collection("users")
        .doc(widget.currentUserId)
        .set({
          "uid": widget.currentUserId,
          "lastMessage": text,
          "timestamp": timestamp,
          "isRead": false, // 🚨 mark as unread for receiver
        }, SetOptions(merge: true));
  }

  @override
  void initState() {
    super.initState();

    // mark chat as read for current user
    FirebaseFirestore.instance
        .collection("chatList")
        .doc(widget.currentUserId)
        .collection("users")
        .doc(widget.otherUserId)
        .set({"isRead": true}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SingleChildScrollView(
        child: Column(
          children: [
            DesktopHeader(),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(flex: 2, child: UserSidBarWidget()),
                SizedBox(width: 8),
                Expanded(
                  flex: 7,
                  child: Container(
                    height: 1.32 * height,
                    // width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 7,
                          offset: Offset(2, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7.0),
                        bottomLeft: Radius.circular(7.0),
                      ),
                    ),
                    child: StreamBuilder(
                      stream:
                          FirebaseFirestore.instance
                              .collection("chats")
                              .doc(widget.chatId)
                              .collection("messages")
                              .orderBy("timestamp", descending: true)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("dskgnsd");
                        }
                        final docs = snapshot.data!.docs;
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 100.0,
                            right: 100.0,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 50.0),
                              StreamBuilder(
                                stream:
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(widget.otherUserId)
                                        .snapshots(),
                                builder: (context, receiversnapshot) {
                                  if (!receiversnapshot.hasData) {
                                    return Text("");
                                  }
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 0.050 * height,
                                            width: 0.040 * width,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  receiversnapshot
                                                      .data?["image"],
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                            receiversnapshot.data?["name"],
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "",
                                        //   "${chats[index]["daycreated"]} - ${chats[index]["monthcreated"]} - ${chats[index]["yearcreated"]}",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),

                              SizedBox(height: 20),
                              SizedBox(
                                height: 0.60 * height,
                                child: ListView.builder(
                                  reverse: true,
                                  itemCount: docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final msg = docs[index];
                                    final isMe =
                                        msg["fromUid"] == widget.currentUserId;
                                    return Align(
                                      alignment:
                                          isMe
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color:
                                              isMe
                                                  ? Colors.blueAccent
                                                  : Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          msg["message"],
                                          style: GoogleFonts.poppins(
                                            color:
                                                isMe
                                                    ? Colors.white
                                                    : Colors.black87,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                height: 0.070 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        controller: _controller,
                                        cursorHeight: 15,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Message",
                                          hintStyle: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    InkWell(
                                      onTap: () async {
                                        if (_controller.text.isEmpty) {
                                          Get.dialog(
                                            Dialog(
                                              child: Container(
                                                height: 200,
                                                width: 400,
                                                color: Colors.red,
                                              ),
                                            ),
                                          );
                                        } else {
                                          if (sendingmessage == false) {
                                            setState(() {
                                              sendingmessage = true;
                                            });
                                          } else {
                                            if (sendingmessage == true) {
                                              setState(() {
                                                sendingmessage = false;
                                              });
                                            }
                                          }

                                          _sendMessage();
                                        }
                                      },
                                      child:
                                          sendingmessage
                                              ? SizedBox(
                                                height: 13,
                                                width: 13,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.red,
                                                      strokeWidth: 3,
                                                    ),
                                              )
                                              : Icon(
                                                Icons.send,
                                                color: Colors.red,
                                              ),
                                    ),
                                    SizedBox(width: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
