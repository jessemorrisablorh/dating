import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/Pages/blocked_page.dart';
import 'package:dating_app/Pages/final_registration_step_page.dart';
import 'package:dating_app/Pages/home_page.dart';
import 'package:dating_app/Pages/loading_page.dart';
import 'package:dating_app/Pages/sex_page.dart';
import 'package:dating_app/Pages/user_body_type_details_page.dart';
import 'package:dating_app/Pages/welcome_user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScreenControllerPage extends StatefulWidget {
  const ScreenControllerPage({super.key});

  @override
  State<ScreenControllerPage> createState() => _ScreenControllerPageState();
}

class _ScreenControllerPageState extends State<ScreenControllerPage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
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

        return snapshot.data?["blocked"] == true
            ? BlockedPage()
            : snapshot.data?["sex"] == "" && snapshot.data?["looking_for"] == ""
            ? SexPage()
            : snapshot.data?["name"] == "" &&
                snapshot.data?["date_of_birth"] == "" &&
                snapshot.data?["short_description"] == ""
            ? WelcomeUserPage()
            : snapshot.data?["ethnicity"] == "" &&
                snapshot.data?["hair_color"] == "" &&
                snapshot.data?["eyes_color"] == "" &&
                snapshot.data?["status"] == "" &&
                snapshot.data?["religion"] == "" &&
                snapshot.data?["smoking"] == "" &&
                snapshot.data?["drinking"] == "" &&
                snapshot.data?["height"] == ""
            ? UserBodyTypeDetailsPage()
            : snapshot.data?["image"] == ""
            ? FinalRegistrationStepPage()
            : HomePage();
      },
    );
  }
}
