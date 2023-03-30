import 'package:child_vaccination/helper/helperFunction.dart';
import 'package:child_vaccination/screen/LoginPage.dart';
import 'package:child_vaccination/screen/MyHomePage.dart';
import 'package:child_vaccination/screen/pages/Profile.dart';
import 'package:child_vaccination/screen/splashScreen.dart';
import 'package:child_vaccination/shared/Constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // run the intialozation for web
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    // run the intiialization for android
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 160, 195, 224),
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/images/SplashImg.png'),
        duration: 1500,
        splashTransition: SplashTransition.fadeTransition,
        splashIconSize: 1000,
        backgroundColor: Colors.white,
        nextScreen: _isSignedIn ? const MyHomePage() : const LoginPage(),
      ),
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        MyHomePage.routeName: (context) => const MyHomePage(),
        //'/registerChild': (context) => RegisterChild(),
      },
    );
  }
}
