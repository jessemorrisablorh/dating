import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FinalRegistrationStepPage extends StatefulWidget {
  const FinalRegistrationStepPage({super.key});

  @override
  State<FinalRegistrationStepPage> createState() =>
      _FinalRegistrationStepPageState();
}

class _FinalRegistrationStepPageState extends State<FinalRegistrationStepPage> {
  Uint8List? _imageBytes;
  String? _fileName;
  String? _uploadedImageUrl;
  bool _uploading = false;
  User? user = FirebaseAuth.instance.currentUser;
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
                          "Holla,",
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
                          "You're almost there..",
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
                          "Upload an image of yourself",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 50),
                        _imageBytes != null
                            ? Container(
                              height: 250,
                              width: 250,
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
                                  image: MemoryImage(_imageBytes!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                            : Container(
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: AssetImage("images/profile.jpg"),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 7,
                                    offset: Offset(2, 3),
                                  ),
                                ],
                              ),
                            ),
                        SizedBox(height: 50),
                        // if (_imageBytes != null) ...[
                        //   SizedBox(height: 16),
                        //   Text("Preview:"),
                        //   Image.memory(_imageBytes!, width: 150, height: 150),
                        //   SizedBox(height: 16),
                        //   _uploading
                        //       ? CircularProgressIndicator()
                        //       : ElevatedButton(
                        //         onPressed: _uploadImage,
                        //         child: Text("Upload to Firebase"),
                        //       ),
                        // ],
                        // if (_uploadedImageUrl != null)
                        //   Padding(
                        //     padding: const EdgeInsets.only(top: 20),
                        //     child: Text(
                        //       "Upload complete!\nURL: $_uploadedImageUrl",
                        //     ),
                        //   ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       height: 0.070 * height,
                        //       width: 0.30 * width,

                        //       alignment: Alignment.center,

                        //       child: Padding(
                        //         padding: const EdgeInsets.only(
                        //           left: 15.0,
                        //           right: 15.0,
                        //         ),
                        //         child: Row(
                        //           children: [
                        //             Expanded(
                        //               child: TextFormField(
                        //                 onTap: () {
                        //                   if (heightcolorerror == true) {
                        //                     setState(() {
                        //                       heightcolorerror = false;
                        //                       heighthint = "Height";
                        //                     });
                        //                   }
                        //                 },
                        //                 validator: (value) {
                        //                   if (value!.isEmpty) {
                        //                     setState(() {
                        //                       heightcolorerror = true;
                        //                       heighthint = "Required";
                        //                     });

                        //                     return "";
                        //                   }
                        //                   return null;
                        //                 },
                        //                 controller: heightController,
                        //                 decoration: InputDecoration(
                        //                   errorStyle: TextStyle(fontSize: 0),
                        //                   labelText: heighthint,
                        //                   labelStyle: GoogleFonts.poppins(
                        //                     fontSize: 13,
                        //                     fontWeight: FontWeight.w500,
                        //                     color:
                        //                         heightcolorerror
                        //                             ? Colors.red
                        //                             : Colors.black,
                        //                   ),
                        //                   border: OutlineInputBorder(),
                        //                 ),
                        //               ),
                        //             ),
                        //             SizedBox(width: 15),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 10),
                        SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Visibility(
                              visible: _imageBytes != null,
                              child: InkWell(
                                onTap: _pickImage,

                                child: Icon(
                                  Icons.refresh,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            InkWell(
                              onTap:
                                  _imageBytes != null
                                      ? _uploadImage
                                      : _pickImage,
                              // if (imgURL != null) {
                              // } else {
                              //   Get.dialog(
                              //     Dialog(
                              //       child: Container(
                              //         height: 250,
                              //         width: 350,
                              //         decoration: BoxDecoration(
                              //           color: Colors.white,
                              //           borderRadius: BorderRadius.circular(15),
                              //           boxShadow: [
                              //             BoxShadow(
                              //               color: Colors.black26,
                              //               blurRadius: 7,
                              //               offset: Offset(2, 3),
                              //             ),
                              //           ],
                              //         ),

                              //         alignment: Alignment.center,
                              //         child: Column(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.center,
                              //           children: [
                              //             Padding(
                              //               padding: const EdgeInsets.only(
                              //                 left: 50.0,
                              //                 right: 50.0,
                              //                 bottom: 35.0,
                              //               ),
                              //               child: Row(
                              //                 children: [
                              //                   Icon(Icons.camera),
                              //                   SizedBox(width: 15),
                              //                   Text(
                              //                     "Take an image",
                              //                     style: GoogleFonts.poppins(
                              //                       fontSize: 13,
                              //                       fontWeight: FontWeight.w500,
                              //                       color: Colors.black,
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.only(
                              //                 left: 50.0,
                              //                 right: 50.0,
                              //               ),
                              //               child: Row(
                              //                 children: [
                              //                   Container(
                              //                     height: 4,
                              //                     color: Colors.red,
                              //                     width: 210,
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //             InkWell(
                              //               onTap: _pickImage,
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(
                              //                   top: 35.0,
                              //                   left: 50.0,
                              //                   right: 50.0,
                              //                 ),
                              //                 child: Row(
                              //                   children: [
                              //                     Icon(Icons.folder),
                              //                     SizedBox(width: 15),
                              //                     Text(
                              //                       "Upload from your device",
                              //                       style: GoogleFonts.poppins(
                              //                         fontSize: 13,
                              //                         fontWeight:
                              //                             FontWeight.w500,
                              //                         color: Colors.black,
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   );
                              // }

                              // if (formkey.currentState!.validate()) {
                              //   if (loading == false) {
                              //     setState(() {
                              //       loading = true;
                              //     });
                              //   } else {
                              //     if (loading == false) {
                              //       setState(() {
                              //         loading = true;
                              //       });
                              //     }
                              //   }
                              //   try {
                              //     await FirebaseFirestore.instance
                              //         .collection("users")
                              //         .doc(user?.uid)
                              //         .update({
                              //           //"height": heightController.text.trim(),
                              //           //  "hair_color": selectedHairColor,
                              //           //  "religion": selectedReligion,
                              //           // "ethnicity": selectedEthnicity,
                              //           //  "eyes_color": selectedEyeColor,
                              //           // "smoking": selectedSmoking,
                              //           //  "drinking": selectedAcohol,
                              //           //  "status": selectedSmoking,
                              //         });
                              //   } catch (e) {
                              //     Get.snackbar(
                              //       margin: EdgeInsets.only(bottom: 50),
                              //       snackPosition: SnackPosition.BOTTOM,
                              //       maxWidth: 0.30 * width,
                              //       "",
                              //       "",
                              //       backgroundColor: Colors.red,
                              //       titleText: Text(
                              //         "Error!",
                              //         style: GoogleFonts.poppins(
                              //           color: Colors.white,
                              //           fontSize: 13,
                              //           fontWeight: FontWeight.w500,
                              //         ),
                              //       ),
                              //       messageText: Text(
                              //         "Try again",
                              //         style: GoogleFonts.poppins(
                              //           color: Colors.white,
                              //           fontSize: 13,
                              //           fontWeight: FontWeight.w500,
                              //         ),
                              //       ),
                              //     );
                              //     setState(() {
                              //       loading = false;
                              //     });
                              //   }
                              // }
                              //},
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
                                    _uploading
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
                                          _imageBytes != null
                                              ? "Save image"
                                              : "Upload image",
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
                        if (_uploadedImageUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              "Upload complete!\nURL: $_uploadedImageUrl",
                            ),
                          ),
                        // ElevatedButton.icon(
                        //   onPressed: _pickImage,
                        //   icon: Icon(Icons.upload_file),
                        //   label: Text("Choose from Camera or Folder"),
                        // ),
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

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
      allowMultiple: false,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imageBytes = result.files.single.bytes;
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageBytes == null || _fileName == null) return;
    setState(() {
      _uploading = true;
    });

    final sanitizedFileName = _fileName!.replaceAll(RegExp(r'[^\w\d_.-]'), '_');
    final ref = FirebaseStorage.instance.ref(
      'profile_images/$sanitizedFileName',
    );
    // final ref = FirebaseStorage.instance.ref('profile_images/$_fileName');
    // ignore: unused_local_variable
    final uploadTask = await ref.putData(_imageBytes!);
    final url = await ref.getDownloadURL();

    // Save to Firestore (you can modify the document path/user ID)
    FirebaseFirestore.instance.collection("users").doc(user?.uid).set({
      'image': url,
    }, SetOptions(merge: true));
    setState(() {
      //  _uploadedImageUrl = url;
      _uploading = false;
    });
    if (!mounted) return; // ✅ Prevent calling setState on disposed widget
  }
}
