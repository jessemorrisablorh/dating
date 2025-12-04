import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Pages/loading_page.dart';
import 'package:dating_app/Pages/single_user_messages_page.dart';
import 'package:dating_app/Widgets/header_widget.dart';
import 'package:dating_app/Widgets/side_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserMessagesPage extends StatefulWidget {
  const UserMessagesPage({super.key});

  @override
  State<UserMessagesPage> createState() => _UserMessagesPageState();
}

class _UserMessagesPageState extends State<UserMessagesPage> {
  int currentPage = 0;
  final int itemsPerPage = 3;
  final int maxVisibleButtons = 4;
  String searchQuery = '';

  /// Generate chatId from two UIDs (same both sides)
  User? user = FirebaseAuth.instance.currentUser;
  String chatIdFor(String uid1, String uid2) {
    final a = uid1.trim();
    final b = uid2.trim();
    return a.compareTo(b) < 0 ? '${a}_$b' : '${b}_$a';
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
            //====================== HEADER ======================= //
            DesktopHeader(),

            //====================== HEADER ======================= //
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(flex: 2, child: UserSidBarWidget()),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        Container(
                          height: 1.32 * height,
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
                            padding: const EdgeInsets.fromLTRB(
                              30.0,
                              80.0,
                              30.0,
                              0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Messages",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(7),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 7,
                                            offset: Offset(1, 2),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          15.0,
                                          15.0,
                                          15.0,
                                          15.0,
                                        ),
                                        child: Text(
                                          "Subscribe to Premium today and unlock all the exclusive benefits our website has to offer!",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                StreamBuilder(
                                  stream:
                                      FirebaseFirestore.instance
                                          .collection("chatList")
                                          .doc(user?.uid)
                                          .collection("users")
                                          .orderBy(
                                            "timestamp",
                                            descending: true,
                                          )
                                          .snapshots(),

                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return LoadingPage();
                                    }
                                    var chats = snapshot.data!.docs;

                                    if (chats.isEmpty) {
                                      return const Center(
                                        child: Text("No chats yet"),
                                      );
                                    }
                                    final allDocs = snapshot.data!.docs;
                                    // // Filter data by search query
                                    // final allDocs =
                                    //     snapshot.data!.docs.where((doc) {
                                    //       final data =
                                    //           doc.data()
                                    //               as Map<String, dynamic>;
                                    //       final name =
                                    //           data['name']
                                    //               ?.toString()
                                    //               .toLowerCase() ??
                                    //           '';
                                    //       return name.contains(searchQuery);
                                    //     }).toList();

                                    if (allDocs.isEmpty) {
                                      return Center(
                                        child: Text("No users found."),
                                      );
                                    }

                                    final totalPages =
                                        (allDocs.length / itemsPerPage).ceil();
                                    currentPage = currentPage.clamp(
                                      0,
                                      totalPages - 1,
                                    );

                                    final startIndex =
                                        currentPage * itemsPerPage;
                                    final endIndex = (startIndex + itemsPerPage)
                                        .clamp(0, allDocs.length);
                                    final visibleDocs = allDocs.sublist(
                                      startIndex,
                                      endIndex,
                                    );

                                    // Adjust page buttons
                                    int startBtn = 0;
                                    int endBtn = totalPages;
                                    if (totalPages > maxVisibleButtons) {
                                      if (currentPage <= 1) {
                                        startBtn = 0;
                                        endBtn = maxVisibleButtons;
                                      } else if (currentPage >=
                                          totalPages - 2) {
                                        startBtn =
                                            totalPages - maxVisibleButtons;
                                        endBtn = totalPages;
                                      } else {
                                        startBtn = currentPage - 1;
                                        endBtn = currentPage + 3;
                                      }
                                    }
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 0.56 * height,
                                          child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: visibleDocs.length,
                                            itemBuilder: (context, index) {
                                              var chat = chats[index];
                                              var chatData = chat.data();
                                              bool isRead =
                                                  chatData["isRead"] ??
                                                  true; // default to true if missing

                                              return InkWell(
                                                onTap: () {
                                                  String chatId = chatIdFor(
                                                    "${user?.uid}",
                                                    visibleDocs[index]["uid"],
                                                  );
                                                  Get.to(
                                                    () => SingleUserMessagesPage(
                                                      chatId: chatId,
                                                      currentUserId:
                                                          "${user?.uid}",
                                                      otherUserId:
                                                          visibleDocs[index]["uid"],
                                                    ),
                                                    transition:
                                                        Transition.noTransition,
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 3.0,
                                                      ),
                                                  child: Container(
                                                    //  height: 0.075 * height,
                                                    width: width,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 7,
                                                          offset: Offset(2, 2),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                      color: Colors.white,
                                                      // color: Colors.grey[700],
                                                    ),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 20.0,
                                                            right: 20.0,
                                                            top: 30.0,
                                                            bottom: 35.0,
                                                          ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          StreamBuilder(
                                                            stream:
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                      "users",
                                                                    )
                                                                    .doc(
                                                                      visibleDocs[index]["uid"],
                                                                    )
                                                                    .snapshots(),
                                                            builder: (
                                                              context,
                                                              receiversnapshot,
                                                            ) {
                                                              if (!receiversnapshot
                                                                  .hasData) {
                                                                return Text("");
                                                              }
                                                              return Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            0.050 *
                                                                            height,
                                                                        width:
                                                                            0.040 *
                                                                            width,
                                                                        decoration: BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          image: DecorationImage(
                                                                            image: NetworkImage(
                                                                              receiversnapshot.data?["image"],
                                                                            ),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10.0,
                                                                      ),
                                                                      Text(
                                                                        receiversnapshot
                                                                            .data?["name"],
                                                                        style: GoogleFonts.poppins(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    "",
                                                                    //   "${chats[index]["daycreated"]} - ${chats[index]["monthcreated"]} - ${chats[index]["yearcreated"]}",
                                                                    style: GoogleFonts.poppins(
                                                                      color:
                                                                          Colors
                                                                              .black,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(height: 20),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 10.0,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  visibleDocs[index]["lastMessage"],
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFonts.poppins(
                                                                    color:
                                                                        Colors
                                                                            .black,
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 20.0,
                                                              ),
                                                              !isRead
                                                                  ? Padding(
                                                                    padding:
                                                                        const EdgeInsets.only(
                                                                          right:
                                                                              20.0,
                                                                        ),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color:
                                                                            Colors.red,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              7,
                                                                            ),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black12,
                                                                            blurRadius:
                                                                                7,
                                                                            offset: Offset(
                                                                              1,
                                                                              2,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.fromLTRB(
                                                                          15.0,
                                                                          10.0,
                                                                          15.0,
                                                                          10.0,
                                                                        ),
                                                                        child: Text(
                                                                          "New",
                                                                          style: GoogleFonts.poppins(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                  : SizedBox(
                                                                    width: 20.0,
                                                                  ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (currentPage > 0)
                                                InkWell(
                                                  onTap:
                                                      () => setState(
                                                        () => currentPage--,
                                                      ),
                                                  child: Container(
                                                    height: 0.060 * height,
                                                    width: 0.035 * width,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            7,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 7,
                                                          offset: Offset(2, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.arrow_left,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),

                                              //===
                                              for (
                                                int i = startBtn;
                                                i < endBtn;
                                                i++
                                              )
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                      ),
                                                  child: InkWell(
                                                    onTap:
                                                        () => setState(
                                                          () => currentPage = i,
                                                        ),
                                                    child: Container(
                                                      height: 0.060 * height,
                                                      width: 0.035 * width,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.red,
                                                          width: 1,
                                                          style:
                                                              BorderStyle.solid,
                                                        ),
                                                        color:
                                                            i == currentPage
                                                                ? Colors.red
                                                                : Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              7,
                                                            ),
                                                        // boxShadow: [
                                                        //   BoxShadow(
                                                        //     color:
                                                        //         Colors
                                                        //             .black12,
                                                        //     blurRadius: 7,
                                                        //     offset: Offset(
                                                        //       2,
                                                        //       3,
                                                        //     ),
                                                        //   ),
                                                        // ],
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "${i + 1}",
                                                        style: GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                          color:
                                                              i == currentPage
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(width: 5),
                                              if (currentPage < totalPages - 1)
                                                InkWell(
                                                  onTap:
                                                      () => setState(
                                                        () => currentPage++,
                                                      ),
                                                  child: Container(
                                                    height: 0.060 * height,
                                                    width: 0.035 * width,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            7,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 7,
                                                          offset: Offset(2, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.arrow_right,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
