import 'package:dating_app/Pages/login_page.dart';
import 'package:dating_app/Pages/screen_controller_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Very important!
  final box = GetStorage();
  final isLoggedIn = box.read('isLoggedIn') ?? false;
  if (kDebugMode) {
    print("this is it :: ::$isLoggedIn");
  }
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAQTU5RUYxNtGW8gGh8L1rZSDtGldXlLGU",
      authDomain: "dimm-1c792.firebaseapp.com",
      projectId: "dimm-1c792",
      storageBucket: "dimm-1c792.appspot.com",
      messagingSenderId: "701795711995",
      appId: "1:701795711995:web:3d988c568546561523e95e",
      measurementId: "G-VYG3L394LC",
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user = FirebaseAuth.instance.currentUser;

  // bool checked = false;
  // checkAuthentication() {
  //   bool loggedin = box.read("loggedin");
  //   setState(() {
  //     checked = loggedin;
  //   });
  //   print("checked :: $checked");
  // }

  //bool loggedin = box.read("loggedin");

  // final box = GetStorage();
  // box.write("loggedin", false);
  // This widget is the root of your application.
  // @override
  // void initState() {
  //   super.initState();
  //   checkAuthentication();
  // }

  printit() {
    if (kDebugMode) {
      print("THIS IS THE USER ID :: :: ${user?.uid}");
    }
  }

  @override
  void initState() {
    super.initState();
    printit();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Online dating',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: widget.isLoggedIn == true ? ScreenControllerPage() : LoginPage(),
    );
  }
}
