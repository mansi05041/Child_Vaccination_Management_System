import 'dart:io';

import 'package:child_vaccination/helper/helperFunction.dart';
import 'package:child_vaccination/screen/MyHomePage.dart';
import 'package:child_vaccination/screen/settings/update_child.dart';
import 'package:child_vaccination/screen/settings/update_vaccine.dart';
import 'package:child_vaccination/services/authenticationService.dart';
import 'package:child_vaccination/services/databaseService.dart';
import 'package:child_vaccination/shared/validity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String name = "";
  String email = "";
  String gender = "";
  String photoUrl = "";
  var genderOptions = ['Unknown', 'Male', 'Female', 'Others'];
  bool isGoogleAuthProvider = false;
  bool _isPhotoLoading = false;
  bool _isloading = false;
  bool _isUserHasPhoto = false;
  AuthenticationService authenticationService = AuthenticationService();
  DataBaseService dataBaseService = DataBaseService();
  final formkey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();

  // function to show the bottom sheet dialog for uploading or removing picture
  Future<void> _showPhotoUploadOption() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text(
                  'upload Photo using Camera',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  setState(() {
                    _isPhotoLoading = true;
                  });
                  // Check if the user already has a profile photo
                  if (_isUserHasPhoto) {
                    try {
                      Uri uri = Uri.parse(photoUrl);
                      String path = uri.path;
                      String fileName = path.split('/').last;
                      Reference ref = FirebaseStorage.instance
                          .ref()
                          .child('images/$fileName');
                      try {
                        await ref.delete();
                        setState(() {
                          _isUserHasPhoto = false;
                          photoUrl = "";
                        });
                      } catch (e) {
                        print(e);
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                  // pick the image
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.camera);
                  if (file != null) {
                    String uniqueFileName =
                        DateTime.now().microsecondsSinceEpoch.toString();
                    // store into Firebase Storage
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference imageRef = referenceRoot.child('images');
                    Reference referenceImageToUpload =
                        imageRef.child(uniqueFileName);
                    try {
                      // upload the image into Firebase Storage
                      await referenceImageToUpload.putFile(File(file.path));
                      await referenceImageToUpload
                          .getDownloadURL()
                          .then((value) {
                        setState(() {
                          photoUrl = value;
                        });
                      });
                      final userPhotoSnapShot =
                          await dataBaseService.gettingUserData(email);
                      if (userPhotoSnapShot.docs.isNotEmpty) {
                        final userDocument = userPhotoSnapShot.docs.first;
                        await userDocument.reference
                            .update({"profilePic": photoUrl});
                      }
                      setState(() {
                        _isUserHasPhoto = true;
                        _isPhotoLoading = false;
                      });
                    } catch (e) {
                      throw (e);
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_album,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text(
                  'upload Photo from gallery',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  setState(() {
                    _isPhotoLoading = true;
                  });
                  // Check if the user already has a profile photo
                  if (_isUserHasPhoto) {
                    try {
                      Uri uri = Uri.parse(photoUrl);
                      String path = uri.path;
                      String fileName = path.split('/').last;
                      Reference ref = FirebaseStorage.instance
                          .ref()
                          .child('images/$fileName');
                      try {
                        await ref.delete();
                        setState(() {
                          _isUserHasPhoto = false;
                          photoUrl = "";
                        });
                      } catch (e) {
                        print(e);
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                  // pick the image
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    String uniqueFileName =
                        DateTime.now().microsecondsSinceEpoch.toString();
                    // store into Firebase Storage
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference imageRef = referenceRoot.child('images');
                    Reference referenceImageToUpload =
                        imageRef.child(uniqueFileName);
                    try {
                      // upload the image into Firebase Storage
                      await referenceImageToUpload.putFile(File(file.path));
                      await referenceImageToUpload
                          .getDownloadURL()
                          .then((value) {
                        setState(() {
                          photoUrl = value;
                        });
                      });
                      final userPhotoSnapShot =
                          await dataBaseService.gettingUserData(email);
                      if (userPhotoSnapShot.docs.isNotEmpty) {
                        final userDocument = userPhotoSnapShot.docs.first;
                        await userDocument.reference
                            .update({"profilePic": photoUrl});
                      }
                      setState(() {
                        _isUserHasPhoto = true;
                        _isPhotoLoading = false;
                      });
                    } catch (e) {
                      throw (e);
                    }
                  }
                },
              ),
              ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    setState(() {
                      _isPhotoLoading = true;
                    });
                    // Check if the user already has a profile photo
                    if (_isUserHasPhoto) {
                      try {
                        Uri uri = Uri.parse(photoUrl);
                        String path = uri.path;
                        String fileName = path.split('/').last;
                        Reference ref = FirebaseStorage.instance
                            .ref()
                            .child('images/$fileName');
                        try {
                          await ref.delete();
                          setState(() {
                            _isUserHasPhoto = false;
                            photoUrl = "";
                          });
                        } catch (e) {
                          print(e);
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                    try {
                      // upload the image into Firebase Storage as empty
                      setState(() {
                        photoUrl = "";
                      });
                      final userPhotoSnapShot =
                          await dataBaseService.gettingUserData(email);
                      if (userPhotoSnapShot.docs.isNotEmpty) {
                        final userDocument = userPhotoSnapShot.docs.first;
                        await userDocument.reference
                            .update({"profilePic": photoUrl});
                      }
                      setState(() {
                        _isUserHasPhoto = false;
                        _isPhotoLoading = false;
                      });
                    } catch (e) {
                      throw (e);
                    }
                  }),
            ],
          );
        });
  }

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
        }
      });

      // fetch the google photo url from database
      QuerySnapshot Photosnapshot =
          await dataBaseService.gettingUserData(email);
      if (Photosnapshot.docs.isNotEmpty) {
        setState(() {
          photoUrl = Photosnapshot.docs.first.get('profilePic');
          _isUserHasPhoto = true;
        });
      }
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
          icon: const Icon(Icons.people_alt),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MyHomePage()),
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
                          _isUserHasPhoto
                              ? _isPhotoLoading
                                  ? CircularProgressIndicator(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    )
                                  : CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(photoUrl),
                                    )
                              : _isPhotoLoading
                                  ? CircularProgressIndicator(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    )
                                  : const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          'assets/images/profile.png'),
                                    ),
                          Positioned(
                            bottom: -15,
                            right: -13,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: () {
                                // Handle camera icon button press
                                _showPhotoUploadOption();
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
                                        ..onTap = () {
                                          _showPhotoUploadOption();
                                        })
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
