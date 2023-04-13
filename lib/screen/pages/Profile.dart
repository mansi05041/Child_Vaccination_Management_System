import 'package:child_vaccination/helper/helperFunction.dart';
import 'package:child_vaccination/screen/LoginPage.dart';
import 'package:child_vaccination/screen/ResetPassword.dart';
import 'package:child_vaccination/screen/settings/update_profile.dart';
import 'package:child_vaccination/services/authenticationService.dart';
import 'package:child_vaccination/services/databaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  String email = "";
  String photoUrl = "";
  bool _isLoading = false;
  bool _isVerified = false;
  bool _isUserHasPhoto = false;
  AuthenticationService authenticationService = AuthenticationService();
  DataBaseService dataBaseService = DataBaseService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  Future<void> gettingUserData() async {
    // show the loading detector
    setState(() {
      _isLoading = true;
    });

    try {
      // fetch the user Email from shared preference
      await HelperFunction.getUserEmail().then((value) {
        setState(() {
          email = value!;
        });
      });

      // fetch the name from shared prefernce
      await HelperFunction.getUserName().then((value) {
        setState(() {
          name = value!;
        });
      });

      // fetch the user photourl
      QuerySnapshot snapshot = await dataBaseService.gettingUserData(email);
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          photoUrl = snapshot.docs.first.get('profilePic');
          _isUserHasPhoto = true;
        });
      } else {
        setState(() {
          photoUrl = "";
          _isUserHasPhoto = false;
        });
      }
    } catch (e) {
      setState(() {
        name = "Unknown";
        email = "unknown@Email";
      });
    } finally {
      // hide the loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            ListTile(
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const UpdateProfile()),
                );
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(
                Icons.settings_applications_rounded,
                color: Colors.blueGrey,
              ),
              title: const Text(
                "Settings",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Reset Password"),
                        content:
                            const Text("Are you sure to reset the password?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authenticationService.SignOut();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPassword()),
                              );
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(
                Icons.password_rounded,
                color: Colors.blueGrey,
              ),
              title: const Text(
                "Reset Password",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("LogOut"),
                        content: const Text("Are you sure to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authenticationService.SignOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(
                Icons.exit_to_app_outlined,
                color: Colors.blueGrey,
              ),
              title: const Text(
                "Log out",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _isUserHasPhoto
                ? CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(photoUrl),
                  )
                : const CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "User Name",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$name",
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 20, color: Colors.white),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$email",
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
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
