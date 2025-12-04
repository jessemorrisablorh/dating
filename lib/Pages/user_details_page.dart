import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Pages/loading_page.dart';
import 'package:dating_app/Pages/send_message_page.dart';
import 'package:dating_app/Widgets/footer_widget.dart';
import 'package:dating_app/Widgets/header_widget.dart';
import 'package:dating_app/Widgets/side_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDetailsPage extends StatefulWidget {
  final String? name;
  final String? image;
  final int? age;
  final String? id;
  final String? description;
  final bool? premium;
  final String? sex;
  const UserDetailsPage({
    super.key,
    @required this.name,
    @required this.image,
    @required this.age,
    @required this.id,
    @required this.description,
    @required this.premium,
    @required this.sex,
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return DesktopUserDetailsPage(
            id: widget.id,
            name: widget.name,
            age: widget.age,
            image: widget.image,
            description: widget.description,
            premium: widget.premium,
            sex: widget.sex,
          );
        } else if (constraints.maxWidth > 800 && constraints.maxWidth > 1200) {
          return DesktopUserDetailsPage(
            id: widget.id,
            name: widget.name,
            age: widget.age,
            image: widget.image,
            description: widget.description,
            premium: widget.premium,
            sex: widget.sex,
          );
        } else {
          return MobileUserDetailsPage(
            id: widget.id,
            name: widget.name,
            age: widget.age,
            image: widget.image,
            description: widget.description,
            premium: widget.premium,
            sex: widget.sex,
          );
        }
      },
    );
  }
}

class DesktopUserDetailsPage extends StatefulWidget {
  final String? name;
  final String? image;
  final int? age;
  final String? id;
  final String? description;
  final bool? premium;
  final String? sex;
  const DesktopUserDetailsPage({
    super.key,
    @required this.name,
    @required this.image,
    @required this.age,
    @required this.id,
    @required this.description,
    @required this.premium,
    @required this.sex,
  });

  @override
  State<DesktopUserDetailsPage> createState() => _DesktopUserDetailsPageState();
}

class _DesktopUserDetailsPageState extends State<DesktopUserDetailsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  String searchQuery = '';
  final TextEditingController search = TextEditingController();

  int currentPage = 0;
  final int itemsPerPage = 4;
  final int maxVisibleButtons = 4;

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection("users")
              .doc(user?.uid)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingPage();
        }
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
                      SizedBox(width: 8.0),
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
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 63.0,
                              left: 80.0,
                              right: 80.0,
                            ),
                            child: Column(
                              children: [
                                //======================== USER PROFILE DETAILS ===========================//
                                Row(
                                  children: [
                                    Container(
                                      height: 0.6 * height,
                                      width: 0.3 * width,
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
                                            widget.image.toString(),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 35),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              7,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Online",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 25),
                                        SizedBox(
                                          width: 0.30 * width,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  widget.name.toString(),
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Visibility(
                                                visible: widget.premium == true,
                                                child: ImageIcon(
                                                  AssetImage(
                                                    "images/award.png",
                                                  ),
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 35),
                                        SizedBox(
                                          width: 0.30 * width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  ImageIcon(
                                                    AssetImage(
                                                      "images/sex.png",
                                                    ),
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(width: 15),
                                                  Text(
                                                    widget.sex.toString(),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  ImageIcon(
                                                    AssetImage(
                                                      "images/city.png",
                                                    ),
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(width: 15),
                                                  Text(
                                                    "Texas",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  ImageIcon(
                                                    AssetImage(
                                                      "images/group.png",
                                                    ),
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(width: 15),
                                                  Text(
                                                    "${widget.age.toString()} years",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 35),

                                        SizedBox(
                                          width: 0.30 * width,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  widget.description.toString(),

                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        InkWell(
                                          onTap: () {},
                                          child: Text(
                                            "View more details",
                                            style: GoogleFonts.poppins(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Container(
                                              width: 0.15 * width,
                                              height: 0.070 * height,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ImageIcon(
                                                    AssetImage(
                                                      "images/gift.png",
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 15),
                                                  Text(
                                                    "Send gift",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            InkWell(
                                              onTap: () {
                                                Get.to(
                                                  transition:
                                                      Transition.noTransition,
                                                  () => SendMessagePage(
                                                    profileimage:
                                                        widget.image.toString(),
                                                    username:
                                                        widget.name.toString(),
                                                    userid:
                                                        widget.id.toString(),
                                                    age: int.parse(
                                                      widget.age.toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: 0.15 * width,
                                                height: 0.070 * height,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                                child: Row(
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
                                                                FontWeight.w600,
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
                                  ],
                                ),
                                //======================== USER PROFILE DETAILS ===========================//
                                SizedBox(height: 40),
                                Row(
                                  children: [
                                    Text(
                                      "Find more people",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                //======================== MORE PEOPLE ===========================//
                                StreamBuilder<QuerySnapshot>(
                                  stream:
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .orderBy('name')
                                          //.limit(_currentPage * _perPage)
                                          .snapshots(),
                                  builder: (context, usersnapshot) {
                                    if (!usersnapshot.hasData) {
                                      return Text("");
                                    }
                                    if (!usersnapshot.hasData ||
                                        usersnapshot.data!.docs.isEmpty) {
                                      return Center(
                                        child: Text("No users found"),
                                      );
                                    }

                                    // Filter data by search query
                                    final allDocs =
                                        usersnapshot.data!.docs.where((doc) {
                                          final data =
                                              doc.data()
                                                  as Map<String, dynamic>;
                                          final name =
                                              data['name']
                                                  ?.toString()
                                                  .toLowerCase() ??
                                              '';
                                          return name.contains(searchQuery);
                                        }).toList();

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

                                    // // Adjust page buttons
                                    // int startBtn = 0;
                                    // int endBtn = totalPages;
                                    // if (totalPages > maxVisibleButtons) {
                                    //   if (currentPage <= 1) {
                                    //     startBtn = 0;
                                    //     endBtn = maxVisibleButtons;
                                    //   } else if (currentPage >=
                                    //       totalPages - 2) {
                                    //     startBtn =
                                    //         totalPages - maxVisibleButtons;
                                    //     endBtn = totalPages;
                                    //   } else {
                                    //     startBtn = currentPage - 1;
                                    //     endBtn = currentPage + 3;
                                    //   }
                                    // }
                                    return Column(
                                      children: [
                                        GridView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.all(16),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                childAspectRatio: 2 / 3.2,
                                              ),
                                          itemCount: visibleDocs.length,
                                          itemBuilder: (context, index) {
                                            final user =
                                                visibleDocs[index].data()
                                                    as Map<String, dynamic>;
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => UserDetailsPage(
                                                          id: user["uid"],
                                                          name: user['name'],
                                                          image: user['image'],
                                                          age: user["age"],
                                                          description:
                                                              user['short_description'],
                                                          premium:
                                                              user["premium"],
                                                          sex: user["sex"],
                                                        ),
                                                  ),
                                                );
                                                // Get.to(
                                                //   () => UserDetailsPage(
                                                //     id: user["uid"],
                                                //     name: user['name'],
                                                //     image: user['image'],
                                                //     age: user["age"],
                                                //     description:
                                                //         user['short_description'],
                                                //     premium: user["premium"],
                                                //     sex: user["sex"],
                                                //   ),
                                                //   transition: Transition.fadeIn,
                                                // );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 10.0,
                                                  left: 10.0,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 0.35 * height,
                                                      width: 0.25 * width,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            user["image"],
                                                            // usersnapshot
                                                            //     .data!
                                                            //     .docs[index]["image"],
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 7,
                                                            offset: Offset(
                                                              2,
                                                              3,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    SizedBox(height: 15.0),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            user['name'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Visibility(
                                                          visible:
                                                              user['premium'] ==
                                                              true,
                                                          child: ImageIcon(
                                                            AssetImage(
                                                              "images/award.png",
                                                            ),
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "${user['age']} years",
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(
                                        //     vertical: 8,
                                        //   ),
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.center,
                                        //     children: [
                                        //       if (currentPage > 0)
                                        //         InkWell(
                                        //           onTap:
                                        //               () => setState(
                                        //                 () => currentPage--,
                                        //               ),
                                        //           child: Container(
                                        //             height: 0.060 * height,
                                        //             width: 0.035 * width,
                                        //             decoration: BoxDecoration(
                                        //               color: Colors.red,
                                        //               borderRadius:
                                        //                   BorderRadius.circular(
                                        //                     7,
                                        //                   ),
                                        //               boxShadow: [
                                        //                 BoxShadow(
                                        //                   color: Colors.black12,
                                        //                   blurRadius: 7,
                                        //                   offset: Offset(2, 3),
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //             alignment: Alignment.center,
                                        //             child: Icon(
                                        //               Icons.arrow_left,
                                        //               color: Colors.white,
                                        //             ),
                                        //           ),
                                        //         ),

                                        //       //===
                                        //       for (
                                        //         int i = startBtn;
                                        //         i < endBtn;
                                        //         i++
                                        //       )
                                        //         Padding(
                                        //           padding:
                                        //               const EdgeInsets.symmetric(
                                        //                 horizontal: 4,
                                        //               ),
                                        //           child: InkWell(
                                        //             onTap:
                                        //                 () => setState(
                                        //                   () => currentPage = i,
                                        //                 ),
                                        //             child: Container(
                                        //               height: 0.060 * height,
                                        //               width: 0.035 * width,
                                        //               decoration: BoxDecoration(
                                        //                 border: Border.all(
                                        //                   color: Colors.red,
                                        //                   width: 1,
                                        //                   style:
                                        //                       BorderStyle.solid,
                                        //                 ),
                                        //                 color:
                                        //                     i == currentPage
                                        //                         ? Colors.red
                                        //                         : Colors.white,
                                        //                 borderRadius:
                                        //                     BorderRadius.circular(
                                        //                       7,
                                        //                     ),
                                        //                 // boxShadow: [
                                        //                 //   BoxShadow(
                                        //                 //     color:
                                        //                 //         Colors
                                        //                 //             .black12,
                                        //                 //     blurRadius: 7,
                                        //                 //     offset: Offset(
                                        //                 //       2,
                                        //                 //       3,
                                        //                 //     ),
                                        //                 //   ),
                                        //                 // ],
                                        //               ),
                                        //               alignment:
                                        //                   Alignment.center,
                                        //               child: Text(
                                        //                 "${i + 1}",
                                        //                 style: GoogleFonts.poppins(
                                        //                   fontWeight:
                                        //                       FontWeight.w500,
                                        //                   fontSize: 14,
                                        //                   color:
                                        //                       i == currentPage
                                        //                           ? Colors.white
                                        //                           : Colors
                                        //                               .black,
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       SizedBox(width: 5),
                                        //       if (currentPage < totalPages - 1)
                                        //         InkWell(
                                        //           onTap:
                                        //               () => setState(
                                        //                 () => currentPage++,
                                        //               ),
                                        //           child: Container(
                                        //             height: 0.060 * height,
                                        //             width: 0.035 * width,
                                        //             decoration: BoxDecoration(
                                        //               color: Colors.red,
                                        //               borderRadius:
                                        //                   BorderRadius.circular(
                                        //                     7,
                                        //                   ),
                                        //               boxShadow: [
                                        //                 BoxShadow(
                                        //                   color: Colors.black12,
                                        //                   blurRadius: 7,
                                        //                   offset: Offset(2, 3),
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //             alignment: Alignment.center,
                                        //             child: Icon(
                                        //               Icons.arrow_right,
                                        //               color: Colors.white,
                                        //             ),
                                        //           ),
                                        //         ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    );
                                  },
                                ),

                                //======================== MORE PEOPLE ===========================//  Padding(
                              ],
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
      },
    );
  }
}

class MobileUserDetailsPage extends StatefulWidget {
  final String? name;
  final String? image;
  final int? age;
  final String? id;
  final String? description;
  final bool? premium;
  final String? sex;
  const MobileUserDetailsPage({
    super.key,
    @required this.name,
    @required this.image,
    @required this.age,
    @required this.id,
    @required this.description,
    @required this.premium,
    @required this.sex,
  });

  @override
  State<MobileUserDetailsPage> createState() => _MobileUserDetailsPageState();
}

class _MobileUserDetailsPageState extends State<MobileUserDetailsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  String searchQuery = '';
  final TextEditingController search = TextEditingController();

  int currentPage = 0;
  final int itemsPerPage = 4;
  final int maxVisibleButtons = 4;

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection("users")
              .doc(user?.uid)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingPage();
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              //====================== HEADER ======================= //
              MobileHeader(),

              //====================== HEADER ======================= //
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 0.40 * height,
                            width: width,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 7,
                                  offset: Offset(1, 2),
                                ),
                              ],
                              image: DecorationImage(
                                image: NetworkImage(widget.image.toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                                right: 15.0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Online",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.name.toString(),
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Visibility(
                                visible: widget.premium == true,
                                child: ImageIcon(
                                  AssetImage("images/award.png"),
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20,
                          top: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ImageIcon(
                                  AssetImage("images/sex.png"),
                                  size: 22,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 15),
                                Text(
                                  widget.sex.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ImageIcon(
                                  AssetImage("images/city.png"),
                                  color: Colors.red,
                                  size: 22,
                                ),
                                SizedBox(width: 15),
                                Text(
                                  "Texas",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ImageIcon(
                                  AssetImage("images/group.png"),
                                  size: 22,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 15),
                                Text(
                                  "${widget.age.toString()} years",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20,
                          top: 20.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.description.toString(),
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20,
                          top: 20.0,
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(
                                "View more details",
                                style: GoogleFonts.poppins(
                                  color: Colors.red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20,
                          top: 20.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: 0.15 * width,
                                height: 0.060 * height,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ImageIcon(
                                      AssetImage("images/gift.png"),
                                      size: 22,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Send gift",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.to(
                                    transition: Transition.noTransition,
                                    () => SendMessagePage(
                                      profileimage: widget.image.toString(),
                                      username: widget.name.toString(),
                                      userid: widget.id.toString(),
                                      age: int.parse(widget.age.toString()),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 0.15 * width,
                                  height: 0.060 * height,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ImageIcon(
                                        AssetImage("images/message.png"),
                                        size: 22,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Send message",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20,
                          top: 25.0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Find more people",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        height: 0.50 * height,
                        width: width,
                        child: StreamBuilder(
                          stream:
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .orderBy('name')
                                  //.limit(_currentPage * _perPage)
                                  .snapshots(),
                          builder: (context, asyncSnapshot) {
                            if (!asyncSnapshot.hasData) {
                              return Container();
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: asyncSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => UserDetailsPage(
                                        name:
                                            asyncSnapshot
                                                .data!
                                                .docs[index]["name"],
                                        image:
                                            asyncSnapshot
                                                .data!
                                                .docs[index]["image"],
                                        age:
                                            asyncSnapshot
                                                .data!
                                                .docs[index]["age"],
                                        id:
                                            asyncSnapshot
                                                .data!
                                                .docs[index]["uid"],
                                        description:
                                            asyncSnapshot
                                                .data!
                                                .docs[index]["short_description"],
                                        premium:
                                            asyncSnapshot
                                                .data!
                                                .docs[index]["premium"],
                                        sex:
                                            asyncSnapshot
                                                .data!
                                                .docs[index]["sex"],
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 0.35 * height,
                                          width: 0.70 * width,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                asyncSnapshot
                                                    .data!
                                                    .docs[index]["image"],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 7,
                                                offset: Offset(2, 3),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 30.0,
                                            right: 30.0,
                                            top: 20.0,
                                          ),
                                          child: Text(
                                            asyncSnapshot
                                                .data!
                                                .docs[index]["name"],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 30.0,
                                            right: 30.0,
                                            top: 8.0,
                                          ),
                                          child: Text(
                                            "${asyncSnapshot.data!.docs[index]['age']} years",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomBar(),
        );
      },
    );
  }
}
