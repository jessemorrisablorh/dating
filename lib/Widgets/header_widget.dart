import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Pages/home_page.dart';
import 'package:dating_app/Pages/login_page.dart';
import 'package:dating_app/Pages/message_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopHeader extends StatefulWidget {
  const DesktopHeader({super.key});

  @override
  State<DesktopHeader> createState() => _DesktopHeaderState();
}

class _DesktopHeaderState extends State<DesktopHeader> {
  User? user = FirebaseAuth.instance.currentUser;
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
          return Container(
            height: 0.15 * height,
            width: width,
            decoration: BoxDecoration(color: Colors.white),
          );
        }
        return Container(
          height: 0.15 * height,
          width: width,
          decoration: BoxDecoration(color: Colors.white),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.offAll(
                      () => HomePage(),
                      transition: Transition.noTransition,
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 7,
                              offset: Offset(2, 3),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data?["image"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Hello ${snapshot.data?["name"]},",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        ImageIcon(AssetImage("images/notification.png")),
                        SizedBox(width: 15),
                        Text(
                          "Notifications",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 35),
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => UserMessagesPage(),
                          transition: Transition.noTransition,
                        );
                      },
                      child: Row(
                        children: [
                          ImageIcon(AssetImage("images/message.png")),
                          SizedBox(width: 15),
                          Text(
                            "Messages",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 35),
                    ImageIcon(AssetImage("images/settings.png")),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MobileHeader extends StatefulWidget {
  const MobileHeader({super.key});

  @override
  State<MobileHeader> createState() => _MobileHeaderState();
}

class _MobileHeaderState extends State<MobileHeader> {
  User? user = FirebaseAuth.instance.currentUser;
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
          return Container(
            height: 0.15 * height,
            width: width,
            decoration: BoxDecoration(color: Colors.white),
          );
        }
        return Container(
          height: 0.15 * height,
          width: width,
          decoration: BoxDecoration(color: Colors.white),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.offAll(
                      () => HomePage(),
                      transition: Transition.noTransition,
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 7,
                              offset: Offset(2, 3),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data?["image"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Hello ${snapshot.data?["name"]},",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // Row(
                    //   children: [
                    //     ImageIcon(AssetImage("images/notification.png")),
                    //     // SizedBox(width: 15),
                    //     // Text(
                    //     //   "Notifications",
                    //     //   style: GoogleFonts.poppins(
                    //     //     color: Colors.black,
                    //     //     fontSize: 13,
                    //     //     fontWeight: FontWeight.w600,
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),
                    //SizedBox(width: 35),
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => UserMessagesPage(),
                          transition: Transition.noTransition,
                        );
                      },
                      child: Row(
                        children: [
                          ImageIcon(AssetImage("images/message.png")),
                          // SizedBox(width: 15),
                          // Text(
                          //   "Messages",
                          //   style: GoogleFonts.poppins(
                          //     color: Colors.black,
                          //     fontSize: 13,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // SizedBox(width: 35),
                    // ImageIcon(AssetImage("images/settings.png")),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

//   bool menupressed = false;
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         Container(
//           height: 0.15 * height,
//           width: width,
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.only(left: 25.0, right: 15.0),
//             child: Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     if (menupressed == false) {
//                       setState(() {
//                         menupressed = true;
//                       });
//                     } else {
//                       if (menupressed == true) {
//                         setState(() {
//                           menupressed = false;
//                         });
//                       }
//                     }
//                   },
//                   child: Icon(menupressed == true ? Icons.close : Icons.menu),
//                 ),
//                 SizedBox(width: 20),
//                 InkWell(
//                   onTap: () {
//                     // Get.offAll(
//                     //   () => MainHomePage(),
//                     //   transition: Transition.noTransition,
//                     // );
//                   },
//                   child: Image.asset("images/hsbc.png", height: 0.10 * height),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Visibility(
//           visible: menupressed == true,
//           child: Column(
//             children: [
//               InkWell(
//                 onTap: () {
//                   // Get.offAll(
//                   //   () => MainHomePage(),
//                   //   transition: Transition.noTransition,
//                   // );
//                 },
//                 child: SizedBox(
//                   height: 0.055 * height,
//                   child: Text(
//                     "Home",
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   // Get.offAll(
//                   //   () => UserAboutPage(),
//                   //   transition: Transition.noTransition,
//                   // );
//                 },
//                 child: SizedBox(
//                   height: 0.055 * height,
//                   child: Text(
//                     "About us",
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   // Get.offAll(
//                   //   () => UserContactUsPage(),
//                   //   transition: Transition.noTransition,
//                   // );
//                 },
//                 child: SizedBox(
//                   height: 0.055 * height,
//                   child: Text(
//                     "Contact us",
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Get.offAll(
//                     () => LoginPage(),
//                     transition: Transition.noTransition,
//                   );
//                 },
//                 child: Container(
//                   height: 0.060 * height,
//                   width: 0.25 * width,
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     "Login",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
