import 'dart:async';
import 'package:child_vaccination/screen/MyHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = '/splash';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(milliseconds: 2500), (() async {
      Navigator.pushReplacementNamed(context, MyHomePage.routeName);
    }));
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: const Text(
          'Immunify',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 60,
          ),
        ),
      ),
    );
  }
}
