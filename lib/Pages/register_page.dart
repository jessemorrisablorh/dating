import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Pages/screen_controller_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String emailhint = "Email";
  String passwordhint = "Password";
  bool emailerror = false;
  bool passworderror = false;
  bool loading = false;
  bool hidepassword = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: formkey,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            height: height,
            width: width,
            color: Colors.black26,
            alignment: Alignment.center,
            child: FadeInUp(
              child: Container(
                height: 0.65 * height,
                width: 0.30 * width,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 7,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                      child: Container(
                        height: 0.12 * height,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50.0,
                        right: 50.0,
                        top: 40.0,
                      ),
                      child: Container(
                        height: 0.065 * height,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: Row(
                            children: [
                              ImageIcon(
                                AssetImage("images/email.png"),
                                size: 20,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: TextFormField(
                                  onTap: () {
                                    if (emailerror == true) {
                                      setState(() {
                                        emailerror = false;
                                        email.clear();
                                        emailhint = "Email";
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        emailerror = true;
                                        email.clear();
                                        emailhint = "Required";
                                      });
                                      return "Required";
                                    }
                                    if (email.text.isEmail == false) {
                                      setState(() {
                                        emailerror = true;
                                        email.clear();
                                        emailhint = "Invalid email";
                                      });
                                      return "Invalid email";
                                    }

                                    return null;
                                  },
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                  cursorHeight: 13,
                                  cursorColor: Colors.black,
                                  cursorErrorColor: Colors.black,
                                  controller: email,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(fontSize: 0.01),
                                    hintText: emailhint,
                                    hintStyle: GoogleFonts.poppins(
                                      color:
                                          emailerror
                                              ? Colors.red
                                              : Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50.0,
                        right: 50.0,
                        top: 20.0,
                      ),
                      child: Container(
                        height: 0.070 * height,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: Row(
                            children: [
                              ImageIcon(
                                AssetImage("images/password.png"),
                                size: 21,
                                color: Colors.black,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: TextFormField(
                                  onTap: () {
                                    if (passworderror == true) {
                                      setState(() {
                                        passworderror = false;
                                        password.clear();
                                        passwordhint = "Password";
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        passworderror = true;
                                        passwordhint = "Required";
                                      });
                                      return "Required";
                                    }
                                    if (value.length <= 8) {
                                      setState(() {
                                        passworderror = true;
                                        password.clear();
                                        passwordhint = "Weak password";
                                      });
                                      return "Weak password";
                                    }

                                    return null;
                                  },
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                  cursorHeight: 13,
                                  cursorColor: Colors.black,
                                  cursorErrorColor: Colors.black,
                                  controller: password,
                                  obscureText: hidepassword,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(fontSize: 0.01),
                                    hintText: passwordhint,
                                    hintStyle: GoogleFonts.poppins(
                                      color:
                                          passworderror
                                              ? Colors.red
                                              : Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              InkWell(
                                onTap: () {
                                  if (hidepassword == true) {
                                    setState(() {
                                      hidepassword = false;
                                    });
                                  } else {
                                    if (hidepassword == false) {
                                      setState(() {
                                        hidepassword = true;
                                      });
                                    }
                                  }
                                },
                                child: ImageIcon(
                                  AssetImage(
                                    hidepassword
                                        ? "images/visibility.png"
                                        : "images/visible.png",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (formkey.currentState!.validate()) {
                          if (loading == false) {
                            setState(() {
                              loading = true;
                            });
                          } else {
                            if (loading == true) {
                              setState(() {
                                loading = false;
                              });
                            }
                          }
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                  email: email.text.trim(),
                                  password: password.text.trim(),
                                )
                                .then((value) {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(value.user?.uid)
                                      .set({
                                        "uid": value.user?.uid,
                                        "email": email.text.trim(),
                                        "password": password.text.trim(),
                                        "role": "user",
                                        "name": "",
                                        "image": "",
                                        "sex": "",
                                        "looking_for": "",
                                        "interested_in": "",
                                        "date_of_birth": "",
                                        "age": "",
                                        "height": "",
                                        "drinking": "",
                                        "smoking": "",
                                        "hair_color": "",
                                        "eyes_color": "",
                                        "body_type": "",
                                        "religion": "",
                                        "ethnicity": "",
                                        "status": "",
                                        "premium": false,
                                        "short_description": "",
                                        "premium_subscription_date":
                                            DateTime.now(),
                                        "premium_subscription_day":
                                            DateTime.now().day,
                                        "premium_subscription_month":
                                            DateTime.now().month,
                                        "premium_subscription_year":
                                            DateTime.now().year,
                                        "premium_subscription_end_date":
                                            DateTime.now(),
                                        "premium_subscription_end_day":
                                            DateTime.now().day,
                                        "premium_subscription_end_month":
                                            DateTime.now().month,
                                        "premium_subscription_end_year":
                                            DateTime.now().year,
                                        "blocked": false,
                                        "hobbies": [],
                                        "liked_profiles": [],
                                        "matches": [],
                                        "datecreated": DateTime.now(),
                                        "daycreated": DateTime.now().day,
                                        "monthcreated": DateTime.now().month,
                                        "yearcreated": DateTime.now().year,
                                        "last_seen": DateTime.now(),
                                        "last_seen_day": DateTime.now().day,
                                        "last_seen_month": DateTime.now().month,
                                        "last_Seen_year": DateTime.now().year,
                                      });
                                  setState(() {
                                    loading = false;
                                  });
                                  Get.offAll(
                                    () => ScreenControllerPage(),
                                    transition: Transition.noTransition,
                                  );
                                });
                          } catch (e) {
                            if (kDebugMode) {
                              print(e.toString());
                            }
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
                                "Invalid email / password",
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
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                          right: 50.0,
                          top: 25.0,
                        ),
                        child: Container(
                          height: 0.065 * height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(5),
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
                                    "Create account",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                          right: 50.0,
                          top: 15.0,
                        ),
                        child: Container(
                          height: 0.050 * height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Back to sign in",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
