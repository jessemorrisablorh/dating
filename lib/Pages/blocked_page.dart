import 'package:animate_do/animate_do.dart';
import 'package:dating_app/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BlockedPage extends StatefulWidget {
  const BlockedPage({super.key});

  @override
  State<BlockedPage> createState() => _BlockedPageState();
}

class _BlockedPageState extends State<BlockedPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        child: FadeInUp(
          child: Padding(
            padding: const EdgeInsets.only(left: 150.0, right: 150.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "This account is permanently deactivated",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Your account has been blocked due to a violation of our community guidelines.\nWe take these matters seriously to maintain a safe and respectful environment for all users.\nIf you believe this action was taken in error, please contact our support team for further assistance.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 50),
                InkWell(
                  onTap: () async {
                    if (loading == false) {
                      setState(() {
                        loading = true;
                      });
                    }
                    await FirebaseAuth.instance.signOut().then((value) {
                      setState(() {
                        loading = false;
                      });
                      Get.offAll(() => LoginPage());
                    });
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
                              "Sign out",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
