import 'package:child_vaccination/screen/pages/Home.dart';
import 'package:child_vaccination/screen/pages/Profile.dart';
import 'package:child_vaccination/screen/pages/child.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:child_vaccination/screen/pages/chat.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  static const routeName = '\main';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Home(),
    Profile(),
    ChildPage(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 25, 76, 117),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: GNav(
            backgroundColor: Color.fromARGB(255, 25, 76, 117),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Color.fromARGB(255, 67, 93, 115),
            gap: 8,
            padding: EdgeInsets.all(15),
            onTabChange: _navigateBottomBar,
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
                icon: Icons.child_care_rounded,
                text: 'Child',
              ),
              GButton(
                icon: Icons.chat_bubble_rounded,
                text: 'Chat',
              ),
            ],
          ),
        ),
      ),
    );

    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
