import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Widgets/header_widget.dart';
import 'package:dating_app/Widgets/side_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class SendMessagePage extends StatefulWidget {
  final String username;
  final String userid;
  final int age;
  final String profileimage;

  const SendMessagePage({
    super.key,
    required this.username,
    required this.userid,
    required this.age,
    required this.profileimage,
  });

  @override
  State<SendMessagePage> createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController message = TextEditingController();
  bool sendingmessage = false;
  String? chatRoomId;
  String? messageId;
  var uuid = Uuid();

  /// Generate chatId (unique for 2 users, order doesn't matter)
  String _chatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? "${uid1}_$uid2" : "${uid2}_$uid1";
  }

  // /// Start a new message (or continue chat if it already exists)
  // Future<void> sendMessage(String receiverId, String messageText) async {
  //   // final currentUser = _auth.currentUser;
  //   // if (currentUser == null) return;

  //   final senderId = user?.uid;
  //   final chatId = _chatId(senderId.toString(), widget.userid);

  //   final messageRef =
  //       FirebaseFirestore.instance
  //           .collection("chats")
  //           .doc(chatId)
  //           .collection("messages")
  //           .doc();

  //   await messageRef.set({
  //     "id": messageRef.id,
  //     "senderId": senderId,
  //     "receiverId": receiverId,
  //     "text": messageText,
  //     "timestamp": FieldValue.serverTimestamp(),
  //   });

  //   // optional: keep a chatList for showing last messages (like WhatsApp)
  //   await FirebaseFirestore.instance
  //       .collection("chatList")
  //       .doc(senderId)
  //       .collection("users")
  //       .doc(receiverId)
  //       .set({
  //         "lastMessage": messageText,
  //         "timestamp": FieldValue.serverTimestamp(),
  //         "uid": receiverId,
  //       });

  //   await FirebaseFirestore.instance
  //       .collection("chatList")
  //       .doc(receiverId)
  //       .collection("users")
  //       .doc(senderId)
  //       .set({
  //         "lastMessage": messageText,
  //         "timestamp": FieldValue.serverTimestamp(),
  //         "uid": senderId,
  //       });
  // }

  //========

  Future<void> _sendMessage() async {
    final text = message.text.trim();
    if (text.isEmpty) return;

    message.clear();

    final chatRef = FirebaseFirestore.instance
        .collection("chats")
        .doc(_chatId(user!.uid, widget.userid));

    final timestamp = FieldValue.serverTimestamp();

    // 1. Add to messages subcollection
    await chatRef.collection("messages").add({
      "fromUid": user?.uid,
      "toUid": widget.userid,
      "message": text,
      "timestamp": timestamp,
    });

    // 2. Update sender’s chat list
    await FirebaseFirestore.instance
        .collection("chatList")
        .doc(user?.uid)
        .collection("users")
        .doc(widget.userid)
        .set({
          "uid": widget.userid,
          "lastMessage": text,
          "timestamp": timestamp,
          "isRead": true, // sender already "read" it
        }, SetOptions(merge: true));

    // 3. Update receiver’s chat list
    await FirebaseFirestore.instance
        .collection("chatList")
        .doc(widget.userid)
        .collection("users")
        .doc(user?.uid)
        .set({
          "uid": user?.uid,
          "lastMessage": text,
          "timestamp": timestamp,
          "isRead": false, // 🚨 mark as unread for receiver
        }, SetOptions(merge: true));
  }

  //=========

  // /// Send a message to Firestore
  // Future<void> _sendMessage() async {
  //   final text = message.text.trim();
  //   if (text.isEmpty) return;

  //   message.clear();

  //   final chatRef = FirebaseFirestore.instance
  //       .collection("chats")
  //       .doc(widget.userid);

  //   final timestamp = FieldValue.serverTimestamp();

  //   // 1. Add to messages subcollection
  //   await chatRef.collection("messages").add({
  //     "fromUid": user?.uid,
  //     "toUid": widget.userid,
  //     "message": text,
  //     "timestamp": timestamp,
  //   });

  //   // 2. Update sender’s chat list
  //   await FirebaseFirestore.instance
  //       .collection("chatList")
  //       .doc(user?.uid)
  //       .collection("users")
  //       .doc(widget.userid)
  //       .set({
  //         "uid": widget.userid,
  //         "lastMessage": text,
  //         "timestamp": timestamp,
  //         "isRead": true, // sender already "read" it
  //       }, SetOptions(merge: true));

  //   // 3. Update receiver’s chat list
  //   await FirebaseFirestore.instance
  //       .collection("chatList")
  //       .doc(widget.userid)
  //       .collection("users")
  //       .doc(widget.userid)
  //       .set({
  //         "uid": widget.userid,
  //         "lastMessage": text,
  //         "timestamp": timestamp,
  //         "isRead": false, // 🚨 mark as unread for receiver
  //       }, SetOptions(merge: true));
  // }

  // getChatRoomId() {
  //   //createChatRoom(widget.userid, user?.uid);
  //   chatRoomId = createChatRoom(widget.userid, user?.uid);
  // }

  // createChatRoom(String? froumuid, String? touid) async {
  //   if (froumuid!.substring(0, 1).codeUnitAt(0) >
  //       touid!.substring(0, 1).codeUnitAt(0)) {
  //     return "${touid}_$froumuid";
  //   } else {
  //     return "${froumuid}_$touid";
  //   }
  // }

  // SendMessage(bool sendClicked) async {
  //   getChatRoomId();
  //   if (message.text != "") {
  //     String chatMessage = message.text;
  //     message.clear();
  //     DateTime now = DateTime.now();
  //     String formattedDate = DateFormat('h:mma').format(now);
  //     Map<String, dynamic> messageInfoMap = {
  //       "message": chatMessage,
  //       "sendby": user?.uid,
  //       "ts": formattedDate,
  //       "time": FieldValue.serverTimestamp(),
  //       "imgrul": "",
  //     };
  //     messageId = uuid.v4();
  //     await FirestoreServices()
  //         .addMessage(chatRoomId!, messageId.toString(), messageInfoMap)
  //         .then((value) {
  //           Map<String, dynamic> lastMessageInfo = {
  //             "lastmessage": chatMessage,
  //             "lastmessagesenderts": formattedDate,
  //             "time": FieldValue.serverTimestamp(),
  //             "lastmessagesendby": user?.uid,
  //           };
  //           FirestoreServices().updateLastMessage(chatRoomId!, lastMessageInfo);
  //           if (sendClicked) {
  //             message.clear();
  //           }
  //         });
  //   }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SingleChildScrollView(
        child: Column(
          children: [
            //====================== HEADER ======================= //
            DesktopHeader(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(flex: 2, child: UserSidBarWidget()),
                  SizedBox(width: 8.0),
                  Expanded(
                    flex: 7,
                    child: SizedBox(
                      height: 1.32 * height,
                      child: Scaffold(
                        body: Container(
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
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 50.0,
                              right: 50.0,
                              top: 50.0,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 0.10 * height,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 7,
                                        offset: Offset(1, 2),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "images/warning.png",
                                        color: Colors.white,
                                        height: 0.050 * height,
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        "Scam or phishing messages are strictly forbidden. Offenders will have their accounts permanently blocked.",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 40),
                                Row(
                                  children: [
                                    Container(
                                      height: 0.15 * height,
                                      width: 0.08 * width,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 7,
                                            offset: Offset(1, 2),
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            widget.profileimage.toString(),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.username,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          widget.username,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Row(
                                  children: [
                                    Text(
                                      "Send ${widget.username} a message",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Container(
                                  height: 0.30 * height,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 7,
                                        offset: Offset(1, 2),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: TextField(
                                      cursorColor: Colors.black,
                                      cursorHeight: 15,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      maxLines: 20,
                                      controller: message,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Message",
                                        hintStyle: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        _sendMessage();
                                        //   SendMessage(true);
                                        //   if (message.text.isEmpty) {
                                        //     Get.dialog(
                                        //       Dialog(
                                        //         child: Container(
                                        //           height: 200,
                                        //           width: 400,
                                        //           color: Colors.red,
                                        //         ),
                                        //       ),
                                        //     );
                                        //   } else {
                                        //     if (sendingmessage == false) {
                                        //       setState(() {
                                        //         sendingmessage = true;
                                        //       });
                                        //     } else {
                                        //       if (sendingmessage == true) {
                                        //         setState(() {
                                        //           sendingmessage = false;
                                        //         });
                                        //       }
                                        //     }

                                        //     try {
                                        //       DocumentReference
                                        //       documentReference =
                                        //           FirebaseFirestore.instance
                                        //               .collection("messages")
                                        //               .doc();
                                        //       await documentReference
                                        //           .set({
                                        //             "id": documentReference.id,
                                        //             "fromuid": user?.uid,
                                        //             "touid": widget.userid,
                                        //             "message":
                                        //                 message.text.trim(),

                                        //             "datecreated": DateTime.now(),
                                        //             "daycreated":
                                        //                 DateTime.now().day,
                                        //             "monthcreated":
                                        //                 DateTime.now().month,
                                        //             "yearcreated":
                                        //                 DateTime.now().year,
                                        //             "hourcreated":
                                        //                 DateTime.now().hour,
                                        //             "minutecreated":
                                        //                 DateTime.now().minute,
                                        //             "secondcreated":
                                        //                 DateTime.now().second,
                                        //           })
                                        //           .then((value) async {
                                        //             final messagesRef =
                                        //                 await FirebaseFirestore
                                        //                     .instance
                                        //                     .collection(
                                        //                       "recentmessages",
                                        //                     )
                                        //                     .where(
                                        //                       "fromuid",
                                        //                       isEqualTo:
                                        //                           user?.uid,
                                        //                     )
                                        //                     .where(
                                        //                       "touid",
                                        //                       isEqualTo:
                                        //                           widget.userid,
                                        //                     )
                                        //                     .get();
                                        //             if (messagesRef
                                        //                 .docs
                                        //                 .isEmpty) {
                                        //               print("shit is empty");
                                        //               try {
                                        //                 DocumentReference
                                        //                 recentReference =
                                        //                     FirebaseFirestore
                                        //                         .instance
                                        //                         .collection(
                                        //                           "recentmessages",
                                        //                         )
                                        //                         .doc();
                                        //                 recentReference.set({
                                        //                   "id":
                                        //                       recentReference.id,
                                        //                   "fromuid": user?.uid,
                                        //                   "touid": widget.userid,
                                        //                   "message": message.text,
                                        //                   "datecreated":
                                        //                       DateTime.now(),
                                        //                   "daycreated":
                                        //                       DateTime.now().day,
                                        //                   "monthcreated":
                                        //                       DateTime.now()
                                        //                           .month,
                                        //                   "yearcreated":
                                        //                       DateTime.now().year,
                                        //                   "hourcreated":
                                        //                       DateTime.now().hour,
                                        //                   "minutecreated":
                                        //                       DateTime.now()
                                        //                           .minute,
                                        //                   "secondcreated":
                                        //                       DateTime.now()
                                        //                           .second,
                                        //                 });
                                        //               } catch (e) {
                                        //                 print(
                                        //                   "ERROR CREATING RECENT MESSAGE WITH DETAILS :: $e",
                                        //                 );
                                        //               }
                                        //             } else {
                                        //               print("shit is not empty");
                                        //               print(
                                        //                 "this is the is ${messagesRef.docs[0]["id"]}",
                                        //               );
                                        //               try {
                                        //                 FirebaseFirestore.instance
                                        //                     .collection(
                                        //                       "recentmessages",
                                        //                     )
                                        //                     .doc(
                                        //                       messagesRef
                                        //                           .docs[0]["id"],
                                        //                     )
                                        //                     .update({
                                        //                       "fromuid":
                                        //                           user?.uid,
                                        //                       "touid":
                                        //                           widget.userid,
                                        //                       "message":
                                        //                           message.text,
                                        //                       "datecreated":
                                        //                           DateTime.now(),
                                        //                       "daycreated":
                                        //                           DateTime.now()
                                        //                               .day,
                                        //                       "monthcreated":
                                        //                           DateTime.now()
                                        //                               .month,
                                        //                       "yearcreated":
                                        //                           DateTime.now()
                                        //                               .year,
                                        //                       "hourcreated":
                                        //                           DateTime.now()
                                        //                               .hour,
                                        //                       "minutecreated":
                                        //                           DateTime.now()
                                        //                               .minute,
                                        //                       "secondcreated":
                                        //                           DateTime.now()
                                        //                               .second,
                                        //                     })
                                        //                     .then((newvalue) {
                                        //                       setState(() {
                                        //                         sendingmessage =
                                        //                             false;
                                        //                         message.clear();
                                        //                       });
                                        //                     });
                                        //               } catch (e) {
                                        //                 print(
                                        //                   "ERROR UPDATING RECENT MESSAGE WITH DETAILS :: $e",
                                        //                 );
                                        //               }
                                        //             }
                                        //           });

                                        //       // DocumentReference
                                        //       // documentReference =
                                        //       //     FirebaseFirestore.instance
                                        //       //         .collection("messages")
                                        //       //         .doc();
                                        //       // await documentReference
                                        //       //     .set({
                                        //       //       "id": documentReference.id,
                                        //       //       "fromuid": user?.uid,
                                        //       //       "touid": widget.userid,
                                        //       //       "message":
                                        //       //           message.text.trim(),
                                        //       //       "lastchat":
                                        //       //           message.text.trim(),
                                        //       //       "datecreated": DateTime.now(),
                                        //       //       "daycreated":
                                        //       //           DateTime.now().day,
                                        //       //       "monthcreated":
                                        //       //           DateTime.now().month,
                                        //       //       "yearcreated":
                                        //       //           DateTime.now().year,
                                        //       //       "hourcreated":
                                        //       //           DateTime.now().hour,
                                        //       //       "minutecreated":
                                        //       //           DateTime.now().minute,
                                        //       //       "secondcreated":
                                        //       //           DateTime.now().second,
                                        //       //     })
                                        //       //     .then((value) async {
                                        //       //       // final messagesRef =
                                        //       //       //     FirebaseFirestore.instance
                                        //       //       //         .collection(
                                        //       //       //           "messages",
                                        //       //       //         );
                                        //       //       // final existing =
                                        //       //       //     await messagesRef
                                        //       //       //         .where(
                                        //       //       //           "fromuid",
                                        //       //       //           isEqualTo:
                                        //       //       //               user?.uid,
                                        //       //       //         )
                                        //       //       //         .where(
                                        //       //       //           "touid",
                                        //       //       //           isEqualTo:
                                        //       //       //               widget.userid,
                                        //       //       //         )
                                        //       //       //         .limit(
                                        //       //       //           1,
                                        //       //       //         ) // Faster, we only need to know if one exists
                                        //       //       //         .get();
                                        //       //       // if (existing.docs.isEmpty) {
                                        //       //       //   // 2️⃣ Create new document if it doesn't exist
                                        //       //       //   // await messagesRef.add({
                                        //       //       //   //   "fromuid": fromUid,
                                        //       //       //   //   "touid": toUid,
                                        //       //       //   //   "message": text,
                                        //       //       //   //   "timestamp": FieldValue.serverTimestamp(),
                                        //       //       //   // });
                                        //       //       //   print("✅ Message created");
                                        //       //       // } else {
                                        //       //       //   print(
                                        //       //       //     "⚠️ Document already exists between these two users",
                                        //       //       //   );
                                        //       //       // }
                                        //       //       // FirebaseFirestore.instance.collection("recentchats").doc()
                                        //       //       // FirebaseFirestore.instance
                                        //       //       //     .collection("chatList")
                                        //       //       //     .doc(user?.uid)
                                        //       //       //     .collection("users")
                                        //       //       //     .doc(widget.userid)
                                        //       //       //     .set({
                                        //       //       //       "lastMessage":
                                        //       //       //           message.text.trim(),
                                        //       //       //       "timestamp":
                                        //       //       //           FieldValue.serverTimestamp(),
                                        //       //       //       "userid": widget.userid,
                                        //       //       //       "otherUserId":
                                        //       //       //           user?.uid,
                                        //       //       //       "datecreated":
                                        //       //       //           DateTime.now(),
                                        //       //       //       "daycreated":
                                        //       //       //           DateTime.now().day,
                                        //       //       //       "monthcreated":
                                        //       //       //           DateTime.now()
                                        //       //       //               .month,
                                        //       //       //       "yearcreated":
                                        //       //       //           DateTime.now().year,
                                        //       //       //       "hourcreated":
                                        //       //       //           DateTime.now().hour,
                                        //       //       //       "minutecreated":
                                        //       //       //           DateTime.now()
                                        //       //       //               .minute,
                                        //       //       //       "secondcreated":
                                        //       //       //           DateTime.now()
                                        //       //       //               .second,
                                        //       //       //     })
                                        //       //       //     .then((newvalue) {
                                        //       //       //       FirebaseFirestore
                                        //       //       //           .instance
                                        //       //       //           .collection(
                                        //       //       //             "chatList",
                                        //       //       //           )
                                        //       //       //           .doc(widget.userid)
                                        //       //       //           .collection("users")
                                        //       //       //           .doc(user?.uid)
                                        //       //       //           .set({
                                        //       //       //             "lastMessage":
                                        //       //       //                 message.text
                                        //       //       //                     .trim(),
                                        //       //       //             "timestamp":
                                        //       //       //                 FieldValue.serverTimestamp(),
                                        //       //       //             "userid":
                                        //       //       //                 user?.uid,
                                        //       //       //             "otherUserId":
                                        //       //       //                 widget.userid,
                                        //       //       //             "datecreated":
                                        //       //       //                 DateTime.now(),
                                        //       //       //             "daycreated":
                                        //       //       //                 DateTime.now()
                                        //       //       //                     .day,
                                        //       //       //             "monthcreated":
                                        //       //       //                 DateTime.now()
                                        //       //       //                     .month,
                                        //       //       //             "yearcreated":
                                        //       //       //                 DateTime.now()
                                        //       //       //                     .year,
                                        //       //       //             "hourcreated":
                                        //       //       //                 DateTime.now()
                                        //       //       //                     .hour,
                                        //       //       //             "minutecreated":
                                        //       //       //                 DateTime.now()
                                        //       //       //                     .minute,
                                        //       //       //             "secondcreated":
                                        //       //       //                 DateTime.now()
                                        //       //       //                     .second,
                                        //       //       //           });
                                        //       //       //     })
                                        //       //       // .then((newnewvalue) {
                                        //       //       //   setState(() {
                                        //       //       //     sendingmessage =
                                        //       //       //         false;
                                        //       //       //     message.clear();
                                        //       //       //   });
                                        //       //       //   Get.snackbar(
                                        //       //       //     "",
                                        //       //       //     "",
                                        //       //       //     backgroundColor:
                                        //       //       //         Colors.green,
                                        //       //       //     snackPosition:
                                        //       //       //         SnackPosition.TOP,
                                        //       //       //     titleText: Text(
                                        //       //       //       "Message sent successfully",
                                        //       //       //       style:
                                        //       //       //           GoogleFonts.poppins(
                                        //       //       //             color:
                                        //       //       //                 Colors
                                        //       //       //                     .white,
                                        //       //       //             fontSize: 13,
                                        //       //       //             fontWeight:
                                        //       //       //                 FontWeight
                                        //       //       //                     .w500,
                                        //       //       //           ),
                                        //       //       //     ),
                                        //       //       //     messageText: Text(
                                        //       //       //       "${widget.username} might reply you",
                                        //       //       //       style:
                                        //       //       //           GoogleFonts.poppins(
                                        //       //       //             color:
                                        //       //       //                 Colors
                                        //       //       //                     .white,
                                        //       //       //             fontSize: 13,
                                        //       //       //             fontWeight:
                                        //       //       //                 FontWeight
                                        //       //       //                     .w500,
                                        //       //       //           ),
                                        //       //       //     ),
                                        //       //       //     maxWidth: 500,
                                        //       //       //   );
                                        //       //       // });
                                        //       //     });
                                        //     } catch (e) {
                                        //       setState(() {
                                        //         sendingmessage = false;
                                        //         message.clear();
                                        //       });
                                        //       Get.snackbar(
                                        //         "",
                                        //         "",
                                        //         backgroundColor: Colors.red,
                                        //         snackPosition: SnackPosition.TOP,
                                        //         titleText: Text(
                                        //           "Error!!",
                                        //           style: GoogleFonts.poppins(
                                        //             color: Colors.white,
                                        //             fontSize: 13,
                                        //             fontWeight: FontWeight.w500,
                                        //           ),
                                        //         ),
                                        //         messageText: Text(
                                        //           "Try again",
                                        //           style: GoogleFonts.poppins(
                                        //             color: Colors.white,
                                        //             fontSize: 13,
                                        //             fontWeight: FontWeight.w500,
                                        //           ),
                                        //         ),
                                        //         maxWidth: 500,
                                        //       );
                                        //     }
                                        //   }
                                      },
                                      child: Container(
                                        width: 0.15 * width,
                                        height: 0.070 * height,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 7,
                                              offset: Offset(2, 3),
                                            ),
                                          ],
                                          color: Colors.red,
                                        ),
                                        alignment: Alignment.center,
                                        child:
                                            sendingmessage
                                                ? SizedBox(
                                                  height: 14,
                                                  width: 14,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 3,
                                                      ),
                                                )
                                                : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    ImageIcon(
                                                      AssetImage(
                                                        "images/message.png",
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 15),
                                                    Text(
                                                      "Send message",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
