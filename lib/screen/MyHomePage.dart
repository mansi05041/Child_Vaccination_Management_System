import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: GNav(
          backgroundColor: Color.fromARGB(255, 25, 76, 117),
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Color.fromARGB(255, 67, 93, 115),
          gap: 8,
          padding: EdgeInsets.all(15),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.account_circle_rounded,
              text: 'Profile',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.5), BlendMode.lighten),
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover),
            ),
            child: Center(
              child: Container(
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Text(
                          "IMMUNIFY",
                          style: TextStyle(
                              fontSize: 60, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 100,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 160, 195, 224),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Ensure you child's health - stay on track with their vacinations with their timely notifications!",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 90,
                      ),
                      Container(
                        height: 100,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 160, 195, 224),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Ensure you child's health - stay on track with their vacinations with their timely notifications!",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 100,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 160, 195, 224),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Ensure you child's health - stay on track with their vacinations with their timely notifications!",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  )),
            )),
      ),
    );

    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
