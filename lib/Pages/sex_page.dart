import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SexPage extends StatefulWidget {
  const SexPage({super.key});

  @override
  State<SexPage> createState() => _SexPageState();
}

class _SexPageState extends State<SexPage> {
  User? user = FirebaseAuth.instance.currentUser;

  String sex = "";
  String lookingfor = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background_2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                height: height,
                width: width,
                color: Colors.black45,
                child: Padding(
                  padding: const EdgeInsets.only(left: 100.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInLeft(
                        child: Text(
                          "Welcome,",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      FadeInLeft(
                        child: Text(
                          "Before we get started ..",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Container(
                  height: height,
                  width: width,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "You are a",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                sex = "male";
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color:
                                      sex == "male" ? Colors.red : Colors.black,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Male",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 50),
                          InkWell(
                            onTap: () {
                              setState(() {
                                sex = "female";
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color:
                                      sex == "female"
                                          ? Colors.red
                                          : Colors.black,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Female",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Looking for a",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                lookingfor = "male";
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color:
                                      lookingfor == "male"
                                          ? Colors.red
                                          : Colors.black,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Male",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 50),
                          InkWell(
                            onTap: () {
                              setState(() {
                                lookingfor = "female";
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color:
                                      lookingfor == "female"
                                          ? Colors.red
                                          : Colors.black,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Female",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 20),
                          InkWell(
                            onTap: () async {
                              if (sex != "" && lookingfor != "") {
                                if (loading == false) {
                                  setState(() {
                                    loading = true;
                                  });
                                } else {
                                  if (loading == false) {
                                    setState(() {
                                      loading = true;
                                    });
                                  }
                                }
                                try {
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(user?.uid)
                                      .update({
                                        "sex": sex,
                                        "looking_for": lookingfor,
                                      });
                                } catch (e) {
                                  Get.snackbar(
                                    margin: EdgeInsets.only(bottom: 50),
                                    snackPosition: SnackPosition.BOTTOM,
                                    maxWidth: 0.30 * width,
                                    "",
                                    "",
                                    backgroundColor: Colors.red,
                                    titleText: Text(
                                      "Error!",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    messageText: Text(
                                      "Your details are required",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              } else {
                                Get.snackbar(
                                  margin: EdgeInsets.only(bottom: 50),
                                  snackPosition: SnackPosition.BOTTOM,
                                  maxWidth: 0.30 * width,
                                  "",
                                  "",
                                  backgroundColor: Colors.red,
                                  titleText: Text(
                                    "Error!",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  messageText: Text(
                                    "Your details are required",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 0.070 * height,
                              width: 0.15 * width,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 7,
                                    offset: Offset(1, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child:
                                  loading
                                      ? Container(
                                        height: 13,
                                        width: 13,
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                      : Text(
                                        "Continue",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                FadeInDown(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0, top: 50.0),
                    child: Image.asset(
                      "images/red_heart.png",
                      height: 0.15 * height,
                    ),
                  ),
                ),
                FadeInRight(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 50.0, bottom: 50.0),
                      child: Image.asset(
                        "images/red_heart.png",
                        height: 0.15 * height,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
