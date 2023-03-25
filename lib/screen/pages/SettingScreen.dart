import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 160, 195, 224),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          height: 100,
          width: 500,
          decoration: BoxDecoration(color: Color.fromARGB(255, 21, 58, 88)),
        ),
      ),
    );
  }
}
