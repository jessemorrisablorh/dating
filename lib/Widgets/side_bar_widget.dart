import 'package:dating_app/Pages/home_page.dart';
import 'package:dating_app/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSidBarWidget extends StatefulWidget {
  const UserSidBarWidget({super.key});

  @override
  State<UserSidBarWidget> createState() => _UserSidBarWidgetState();
}

class _UserSidBarWidgetState extends State<UserSidBarWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: 0.40 * height,
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
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.offAll(
                      () => HomePage(),
                      transition: Transition.noTransition,
                    );
                  },
                  child: SizedBox(
                    height: 0.060 * height,
                    child: Row(
                      children: [
                        ImageIcon(AssetImage("images/share.png")),
                        SizedBox(width: 35),
                        Text(
                          "Find people",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.060 * height,
                  child: Row(
                    children: [
                      ImageIcon(AssetImage("images/award.png")),
                      SizedBox(width: 35),
                      Text(
                        "Premium",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.060 * height,
                  child: Row(
                    children: [
                      ImageIcon(AssetImage("images/gift.png")),
                      SizedBox(width: 35),
                      Text(
                        "Gifts",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.060 * height,
                  child: Row(
                    children: [
                      ImageIcon(AssetImage("images/user.png")),
                      SizedBox(width: 35),
                      Text(
                        "Profile",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Get.offAll(
                        () => LoginPage(),
                        transition: Transition.noTransition,
                      );
                    });
                  },
                  child: SizedBox(
                    height: 0.060 * height,
                    child: Row(
                      children: [
                        ImageIcon(AssetImage("images/logout.png")),
                        SizedBox(width: 35),
                        Text(
                          "Sign out",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 3.0),
        Container(
          height: 0.43 * height,
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
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 50.0),
            child: Column(
              children: [
                Container(
                  height: 0.060 * height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 7,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Find people by",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 0.060 * height,
                  child: Row(
                    children: [
                      ImageIcon(AssetImage("images/group.png")),
                      SizedBox(width: 35),
                      Text(
                        "Age",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.060 * height,
                  child: Row(
                    children: [
                      ImageIcon(AssetImage("images/city.png")),
                      SizedBox(width: 35),
                      Text(
                        "City",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.060 * height,
                  child: Row(
                    children: [
                      ImageIcon(AssetImage("images/nearby.png")),
                      SizedBox(width: 35),
                      Text(
                        "Near by",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {},
                  child: SizedBox(
                    height: 0.060 * height,
                    child: Row(
                      children: [
                        ImageIcon(AssetImage("images/newuser.png")),
                        SizedBox(width: 35),
                        Text(
                          "Newer accounts",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Container(
            height: 0.49 * height,
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
          ),
        ),
      ],
    );
  }
}
