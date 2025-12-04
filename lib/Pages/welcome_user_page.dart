import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeUserPage extends StatefulWidget {
  const WelcomeUserPage({super.key});

  @override
  State<WelcomeUserPage> createState() => _WelcomeUserPageState();
}

class _WelcomeUserPageState extends State<WelcomeUserPage> {
  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController name = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TextEditingController shortdescription = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool nameerror = false;
  String namehint = "Name";
  bool dateofbirtherror = false;
  String dateofbirthhint = "Date of birth";
  bool shortdescriptionerror = false;
  String shortdescriptionhint = "Tell everyone about yourself";

  bool loading = false;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDay = pickedDate.day;
        selectedMonth = pickedDate.month;
        selectedYear = pickedDate.year;
        dateController.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formkey,
        child: Row(
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
                            "Great,",
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
                            "Create a profile ..",
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
                    alignment: Alignment.center,
                    child: SlideInRight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Fill this form",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 0.070 * height,
                                width: 0.30 * width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
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
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: TextFormField(
                                    onTap: () {
                                      if (nameerror == true) {
                                        setState(() {
                                          nameerror = false;
                                          name.clear();
                                          namehint = "Name";
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        setState(() {
                                          nameerror = true;
                                          name.clear();
                                          namehint = "Required";
                                        });
                                        return "Required";
                                      }

                                      return null;
                                    },
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                    cursorHeight: 13,
                                    cursorColor: Colors.black,
                                    cursorErrorColor: Colors.black,
                                    controller: name,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(fontSize: 0.01),
                                      hintText: namehint,
                                      hintStyle: GoogleFonts.poppins(
                                        color:
                                            nameerror
                                                ? Colors.red
                                                : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 0.070 * height,
                                width: 0.30 * width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
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
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: TextFormField(
                                    onTap: () {
                                      if (dateofbirtherror == true) {
                                        setState(() {
                                          dateofbirtherror = false;
                                          dateController.clear();
                                          dateofbirthhint = "Date of birth";
                                        });
                                        selectDate(context);
                                      } else {
                                        selectDate(context);
                                      }
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        setState(() {
                                          dateofbirtherror = true;
                                          dateController.clear();
                                          dateofbirthhint = "Required";
                                        });
                                        return "Required";
                                      }

                                      return null;
                                    },
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                    cursorHeight: 13,
                                    cursorColor: Colors.black,
                                    cursorErrorColor: Colors.black,
                                    controller: dateController,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(fontSize: 0.01),
                                      hintText: dateofbirthhint,
                                      hintStyle: GoogleFonts.poppins(
                                        color:
                                            dateofbirtherror
                                                ? Colors.red
                                                : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 0.15 * height,
                                width: 0.30 * width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
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
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: TextFormField(
                                    maxLines: 20,
                                    onTap: () {
                                      if (shortdescriptionerror == true) {
                                        setState(() {
                                          shortdescriptionerror = false;
                                          shortdescription.clear();
                                          shortdescriptionhint =
                                              "Tell everyone about yourself";
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        setState(() {
                                          shortdescriptionerror = true;
                                          shortdescription.clear();
                                          shortdescriptionhint = "Required";
                                        });
                                        return "Required";
                                      }

                                      return null;
                                    },
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                    cursorHeight: 13,
                                    cursorColor: Colors.black,
                                    cursorErrorColor: Colors.black,
                                    controller: shortdescription,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        top: 25.0,
                                      ),
                                      errorStyle: TextStyle(fontSize: 0.01),
                                      hintText: shortdescriptionhint,
                                      hintStyle: GoogleFonts.poppins(
                                        color:
                                            shortdescriptionerror
                                                ? Colors.red
                                                : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25.0),
                          InkWell(
                            onTap: () async {
                              if (formkey.currentState!.validate()) {
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
                                        "name": name.text.trim(),
                                        "date_of_birth":
                                            dateController.text.trim(),
                                        "age":
                                            int.parse(
                                              DateTime.now().year.toString(),
                                            ) -
                                            int.parse(selectedYear.toString()),
                                        "short_description":
                                            shortdescription.text.trim(),
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
                                      "Try again",
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
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
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
                        padding: const EdgeInsets.only(
                          right: 50.0,
                          bottom: 50.0,
                        ),
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
      ),
    );
  }
}
