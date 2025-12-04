import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Pages/loading_page.dart';
import 'package:dating_app/Pages/user_details_page.dart';
import 'package:dating_app/Widgets/footer_widget.dart';
import 'package:dating_app/Widgets/header_widget.dart';
import 'package:dating_app/Widgets/side_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return const DesktopHomePage();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth > 1200) {
          return const DesktopHomePage();
        } else {
          return const MobileHomePage();
        }
      },
    );
  }
}

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String searchQuery = '';
  final TextEditingController search = TextEditingController();

  int currentPage = 0;
  final int itemsPerPage = 8;
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
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: UserSidBarWidget()),
                      SizedBox(width: 3.0),
                      Expanded(
                        flex: 7,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 7,
                                offset: Offset(2, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 50.0,
                                  right: 50.0,
                                  top: 50.0,
                                ),
                                child: StreamBuilder<QuerySnapshot>(
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
                                    return SizedBox(
                                      height: 1.2 * height,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 0.065 * height,
                                            width: width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 7,
                                                  offset: Offset(1, 2),
                                                ),
                                              ],
                                              color: Colors.grey[300],
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 0.065 * height,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  7,
                                                                ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  7,
                                                                ),
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 15.0,
                                                            right: 15.0,
                                                          ),
                                                      child: TextField(
                                                        onChanged:
                                                            (value) => setState(
                                                              () =>
                                                                  searchQuery =
                                                                      value
                                                                          .toLowerCase(),
                                                            ),
                                                        controller: search,
                                                        cursorHeight: 13,
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                        decoration: InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Search for people",
                                                          helperStyle:
                                                              GoogleFonts.poppins(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors
                                                                        .black26,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 0.065 * height,
                                                  width: 0.15 * width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                7,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                7,
                                                              ),
                                                        ),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Search",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 50.0),

                                          Expanded(
                                            child: GridView.builder(
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
                                                    Get.to(
                                                      () => UserDetailsPage(
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
                                                      transition:
                                                          Transition.fadeIn,
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                                    Colors
                                                                        .black12,
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
                                                                style: GoogleFonts.poppins(
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                  fontSize: 14,
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
                                                                color:
                                                                    Colors.red,
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
                                                                style: GoogleFonts.poppins(
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
                                          ),
                                          SizedBox(height: 50.0),
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
                                                      alignment:
                                                          Alignment.center,
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
                                                            () =>
                                                                currentPage = i,
                                                          ),
                                                      child: Container(
                                                        height: 0.060 * height,
                                                        width: 0.035 * width,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.red,
                                                            width: 1,
                                                            style:
                                                                BorderStyle
                                                                    .solid,
                                                          ),
                                                          color:
                                                              i == currentPage
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .white,
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
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                SizedBox(width: 5),
                                                if (currentPage <
                                                    totalPages - 1)
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
                                                      alignment:
                                                          Alignment.center,
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
                                      ),
                                    );
                                  },
                                ),
                              ),

                              SizedBox(height: 51.9),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                UserDesktopFooterWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          //=================== HEADER ========================//
          MobileHeader(),
          //================== HEADER =========================//
          Expanded(
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
                  itemCount: asyncSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(
                          () => UserDetailsPage(
                            name: asyncSnapshot.data!.docs[index]["name"],
                            image: asyncSnapshot.data!.docs[index]["image"],
                            age: asyncSnapshot.data!.docs[index]["age"],
                            id: asyncSnapshot.data!.docs[index]["uid"],
                            description:
                                asyncSnapshot
                                    .data!
                                    .docs[index]["short_description"],
                            premium: asyncSnapshot.data!.docs[index]["premium"],
                            sex: asyncSnapshot.data!.docs[index]["sex"],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 30.0,
                                right: 30.0,
                              ),
                              child: Container(
                                height: 0.40 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      asyncSnapshot.data!.docs[index]["image"],
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 30.0,
                                right: 30.0,
                                top: 20.0,
                              ),
                              child: Text(
                                asyncSnapshot.data!.docs[index]["name"],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 30.0,
                                right: 30.0,
                                top: 5.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${asyncSnapshot.data!.docs[index]['age']} years",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
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
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
