import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserBodyTypeDetailsPage extends StatefulWidget {
  const UserBodyTypeDetailsPage({super.key});

  @override
  State<UserBodyTypeDetailsPage> createState() =>
      _UserBodyTypeDetailsPageState();
}

class _UserBodyTypeDetailsPageState extends State<UserBodyTypeDetailsPage> {
  final List<String> ethnicity = [
    "Asian",
    "Black",
    "Indigenous",
    "Hispanic / Latino",
    "Middle Eastern",
    "Mixed / Multiracial",
    "Native American",
    "Pacific Islander",
    "White",
    "Other",
  ];
  final List<String> bodytype = [
    "Athletic",
    "Average",
    "Curvy",
    "Muscular",
    "Plus-size",
    "Other",
  ];

  final List<String> haircolors = [
    'Auburn',
    'Black',
    'Blonde',
    'Dark Brown',
    'Gray',
    'White',
    'Other',
  ];
  final List<String> eyeColors = [
    'Amber',
    'Aqua',
    'Black',
    'Blue',
    'Brown',
    'Dark Brown',
    'Gray',
    'Green',
    'Hazel',
    'Honey',
    'Lavender',
    'Light Brown',
    'Red / Pink',
    'Turquoise',
    'Violet',
    'Other',
  ];
  final List<String> alcohol = ["Very Much", "Occassionally", "Never"];
  final List<String> smoking = ["Very Much", "Occassionally", "Never"];

  final List<String> religion = [
    "Agnostic",
    "Atheist",
    "Christian",
    "Buddhist",
    "Hindu",
    "Jewish",
    "Muslim",
    "Not religious",
    "Other",
  ];

  final List<String> status = [
    "Engaged",
    "Divorced",
    "Separated",
    "Single",
    "Widowed",
  ];
  String? selectedEthnicity;
  String? selectedBodyType;
  String? selectedHairColor;
  String? selectedEyeColor;
  String? selectedAcohol;
  String? selectedReligion;
  String? selectedSmoking;
  String? selectedStatus;

  String ethnicityhint = "Ethnicity";
  String religionhint = "Religion";
  String bodytypehint = "Body Type";
  String haircolorhint = "Hair Color";
  String alcoholhint = "Do you drink alcohol ?";
  String smokinghint = "Do you smoke ?";
  String eyecolorhint = "Eyes Color";
  String statushint = "Status";
  bool ethnicityerror = false;
  bool religionerror = false;
  bool bodytypeerror = false;
  bool haircolorerror = false;
  bool smokingerror = false;
  bool alcoholerror = false;
  bool eyescolorerror = false;
  bool statuserror = false;
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController heightController = TextEditingController();
  bool heightcolorerror = false;
  String heighthint = "Height";
  final formkey = GlobalKey<FormState>();

  bool dateofbirtherror = false;
  String dateofbirthhint = "Date of birth";
  bool shortdescriptionerror = false;
  String shortdescriptionhint = "Tell everyone about yourself";

  bool loading = false;

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
                            "Okay,",
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
                            "All about yourself ..",
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
                            "Tell us more",
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
                                alignment: Alignment.center,

                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          iconSize: 0,
                                          onTap: () {
                                            if (religionerror == true) {
                                              setState(() {
                                                religionerror = false;
                                                religionhint = "Religion";
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              setState(() {
                                                religionerror = true;
                                                religionhint = "Required";
                                              });
                                              return "";
                                            }
                                            return null;
                                          },
                                          dropdownColor: Colors.white,
                                          decoration: InputDecoration(
                                            labelText: religionhint,
                                            errorStyle: TextStyle(fontSize: 0),
                                            labelStyle: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  religionerror
                                                      ? Colors.red
                                                      : Colors.black,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                          value: selectedReligion,
                                          items:
                                              religion.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(
                                                    type,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedReligion = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          onTap: () {
                                            if (ethnicityerror == true) {
                                              setState(() {
                                                ethnicityerror = false;
                                                ethnicityhint = "Ethnicity";
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              ethnicityerror = true;
                                              ethnicityhint = "Required";
                                              return "";
                                            }
                                            return null;
                                          },
                                          iconSize: 0,
                                          dropdownColor: Colors.white,
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(fontSize: 0),
                                            labelText: ethnicityhint,
                                            labelStyle: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  ethnicityerror
                                                      ? Colors.red
                                                      : Colors.black,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                          value: selectedEthnicity,
                                          items:
                                              ethnicity.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(
                                                    type,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedEthnicity = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
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

                                alignment: Alignment.center,

                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          iconSize: 0,
                                          onTap: () {
                                            if (haircolorerror == true) {
                                              setState(() {
                                                haircolorerror = false;
                                                haircolorhint = "Hair Color";
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              haircolorerror = true;
                                              haircolorhint = "Required";
                                              return "";
                                            }
                                            return null;
                                          },
                                          dropdownColor: Colors.white,
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(fontSize: 0),
                                            labelText: haircolorhint,
                                            labelStyle: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  haircolorerror
                                                      ? Colors.red
                                                      : Colors.black,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                          value: selectedHairColor,
                                          items:
                                              haircolors.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(
                                                    type,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedHairColor = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          iconSize: 0,
                                          onTap: () {
                                            if (eyescolorerror == true) {
                                              setState(() {
                                                eyescolorerror = false;
                                                eyecolorhint = "Eyes color";
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              eyescolorerror = true;
                                              eyecolorhint = "Required";
                                              return "";
                                            }
                                            return null;
                                          },
                                          dropdownColor: Colors.white,
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(fontSize: 0),
                                            labelText: eyecolorhint,
                                            labelStyle: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  eyescolorerror
                                                      ? Colors.red
                                                      : Colors.black,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                          value: selectedEyeColor,
                                          items:
                                              eyeColors.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(
                                                    type,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedEyeColor = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
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

                                alignment: Alignment.center,

                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          onTap: () {
                                            if (alcoholerror == true) {
                                              setState(() {
                                                alcoholerror = false;
                                                alcoholhint =
                                                    "Do you drink alcohol ?";
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              alcoholerror = true;
                                              alcoholhint = "Required";
                                              return "";
                                            }
                                            return null;
                                          },
                                          iconSize: 0,
                                          dropdownColor: Colors.white,
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(fontSize: 0),
                                            labelText: alcoholhint,
                                            labelStyle: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  alcoholerror
                                                      ? Colors.red
                                                      : Colors.black,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                          value: selectedAcohol,
                                          items:
                                              alcohol.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(
                                                    type,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedAcohol = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          iconSize: 0,
                                          onTap: () {
                                            if (smokingerror == true) {
                                              setState(() {
                                                smokingerror = false;
                                                smokinghint = "Do you smoke ?";
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              smokingerror = true;
                                              smokinghint = "Required";
                                              return "";
                                            }
                                            return null;
                                          },
                                          dropdownColor: Colors.white,
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(fontSize: 0),
                                            labelText: smokinghint,
                                            labelStyle: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  smokingerror
                                                      ? Colors.red
                                                      : Colors.black,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                          value: selectedSmoking,
                                          items:
                                              smoking.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(
                                                    type,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedSmoking = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
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

                                alignment: Alignment.center,

                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          iconSize: 0,
                                          onTap: () {
                                            if (statuserror == true) {
                                              setState(() {
                                                statuserror = false;
                                                statushint = "Status";
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              statuserror = true;
                                              statushint = "Required";
                                              return "";
                                            }
                                            return null;
                                          },
                                          dropdownColor: Colors.white,
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(fontSize: 0),
                                            labelText: statushint,
                                            labelStyle: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  statuserror
                                                      ? Colors.red
                                                      : Colors.black,
                                            ),
                                            border: OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          value: selectedStatus,
                                          items:
                                              status.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(type),
                                                );
                                              }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedStatus = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: TextFormField(
                                          onTap: () {
                                            if (heightcolorerror == true) {
                                              setState(() {
                                                heightcolorerror = false;
                                                heighthint = "Height";
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              heightcolorerror = true;
                                              heighthint = "Required";
                                              return "";
                                            }
                                            return null;
                                          },
                                          controller: heightController,
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(fontSize: 0),
                                            labelText: heighthint,
                                            labelStyle: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  heightcolorerror
                                                      ? Colors.red
                                                      : Colors.black,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // TextFormField(
                                  //   onTap: () {
                                  //     if (nameerror == true) {
                                  //       setState(() {
                                  //         nameerror = false;
                                  //         name.clear();
                                  //         namehint = "Name";
                                  //       });
                                  //     }
                                  //   },
                                  //   validator: (value) {
                                  //     if (value!.isEmpty) {
                                  //       setState(() {
                                  //         nameerror = true;
                                  //         name.clear();
                                  //         namehint = "Required";
                                  //       });
                                  //       return "Required";
                                  //     }

                                  //     return null;
                                  //   },
                                  //   style: GoogleFonts.poppins(
                                  //     color: Colors.black,
                                  //     fontWeight: FontWeight.w500,
                                  //     fontSize: 13,
                                  //   ),
                                  //   cursorHeight: 13,
                                  //   cursorColor: Colors.black,
                                  //   cursorErrorColor: Colors.black,
                                  //   controller: name,
                                  //   decoration: InputDecoration(
                                  //     errorStyle: TextStyle(fontSize: 0.01),
                                  //     hintText: namehint,
                                  //     hintStyle: GoogleFonts.poppins(
                                  //       color:
                                  //           nameerror
                                  //               ? Colors.red
                                  //               : Colors.black,
                                  //       fontWeight: FontWeight.w500,
                                  //       fontSize: 13,
                                  //     ),
                                  //     border: InputBorder.none,
                                  //   ),
                                  // ),
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
                                        "hair_color": selectedHairColor,
                                        "religion": selectedReligion,
                                        "ethnicity": selectedEthnicity,
                                        "eyes_color": selectedEyeColor,
                                        "smoking": selectedSmoking,
                                        "drinking": selectedAcohol,
                                        "status": selectedSmoking,
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
