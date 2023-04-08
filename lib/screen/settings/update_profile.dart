import 'package:child_vaccination/helper/helperFunction.dart';
import 'package:child_vaccination/screen/setting.dart';
import 'package:child_vaccination/screen/settings/update_child.dart';
import 'package:child_vaccination/screen/settings/update_vaccine.dart';
import 'package:child_vaccination/services/authenticationService.dart';
import 'package:child_vaccination/services/databaseService.dart';
import 'package:child_vaccination/shared/validity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String name = "";
  String email = "";
  String gender = "";
  var genderOptions = ['Unknown', 'Male', 'Female', 'Others'];
  bool isGoogleAuthProvider = false;
  bool _isloading = false;
  AuthenticationService authenticationService = AuthenticationService();
  DataBaseService dataBaseService = DataBaseService();
  final formkey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  // Function that get the user details
  Future<void> getUserDetails() async {
    // set the loading true
    setState(() {
      _isloading = true;
    });

    // fetch the user details
    try {
      // fetch the user name from helper functions
      await HelperFunction.getUserName().then((value) {
        setState(() {
          name = value!;
        });
      });

      // fetch the user email from helper functions
      await HelperFunction.getUserEmail().then((value) {
        setState(() {
          email = value!;
        });
      });

      // fetch the user gender from database
      QuerySnapshot snapshot = await dataBaseService.gettingUserData(email);
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          gender = snapshot.docs.first.get('gender');
        });
      }

      // fetch the user authentication provider
      await authenticationService.authenticationProvider().then((value) {
        if (value == "Google") {
          setState(() {
            isGoogleAuthProvider = true;
          });
          print(isGoogleAuthProvider);
        }
      });
    } catch (e) {
      setState(() {
        name = "Unknown";
        email = "NAEmail";
        gender = "NA";
      });
    } finally {
      // set the loading false
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Update Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingPage()),
            );
          },
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
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
                Icons.person_2,
                color: Colors.blueGrey,
              ),
              title: const Text(
                "Personal Information",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UpdateChild()),
                );
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(
                Icons.child_care,
                color: Colors.blueGrey,
              ),
              title: const Text(
                "Children Information",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const UpdateVaccine()),
                );
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(
                Icons.vaccines,
                color: Colors.blueGrey,
              ),
              title: const Text(
                "Vaccine Information",
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
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/profile.png'),
                          ),
                          Positioned(
                            bottom: -15,
                            right: -13,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () {
                                // Handle edit icon button press
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$name'.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text.rich(
                            TextSpan(
                                text: "Change Profile Photo! ",
                                style: const TextStyle(
                                    color: Colors.blueGrey, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Click here",
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {})
                                ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // name
                  TextFormField(
                    controller: _nameTextController,
                    enabled: !isGoogleAuthProvider,
                    decoration: InputDecoration(
                      hintText: "$name",
                      prefixIcon: Icon(
                        Icons.person_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    onChanged: (val) async {
                      setState(() {
                        name = val;
                      });

                      // update value in firebase
                      final userDataSnapShot =
                          await dataBaseService.gettingUserData(email);
                      if (userDataSnapShot.docs.isNotEmpty) {
                        final userDocument = userDataSnapShot.docs.first;
                        await userDocument.reference.update({"fullName": name});
                      }

                      // update in the helper function
                      await HelperFunction.saveUserNameSF(name);
                    },
                  ),
                  const SizedBox(height: 8),
                  if (isGoogleAuthProvider)
                    const Text(
                      "You can't change your name if you're signed in with Google.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  const SizedBox(height: 15),
                  // email
                  TextFormField(
                    controller: _emailTextController,
                    enabled: false,
                    validator: (value) => Validator.validateEmail(email: email),
                    decoration: InputDecoration(
                      hintText: "$email",
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  if (isGoogleAuthProvider)
                    const Text(
                      "You can't change your Email if you're signed in with Google.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  const SizedBox(height: 15),
                  // gender
                  Text(
                    "Gender: $gender",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Select the Gender to Update",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.transgender_outlined),
                    ),
                    value: gender,
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    items: genderOptions.map((String genderOptions) {
                      return DropdownMenuItem(
                        value: genderOptions,
                        child: Text(genderOptions),
                      );
                    }).toList(),
                    onChanged: ((String? newValue) async {
                      setState(() {
                        gender = newValue!;
                      });
                      // update value in firebase
                      final userDataSnapShot =
                          await dataBaseService.gettingUserData(email);
                      if (userDataSnapShot.docs.isNotEmpty) {
                        final userDocument = userDataSnapShot.docs.first;
                        await userDocument.reference.update({"gender": gender});
                      }
                    }),
                  ),
                ],
              ),
            ),
    );
  }
}
