import 'package:child_vaccination/helper/helperFunction.dart';
import 'package:child_vaccination/screen/MyHomePage.dart';
import 'package:child_vaccination/screen/childCreate.dart';
import 'package:child_vaccination/screen/settings/update_profile.dart';
import 'package:child_vaccination/screen/settings/update_vaccine.dart';
import 'package:child_vaccination/services/databaseService.dart';
import 'package:child_vaccination/widget/updateChildTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UpdateChild extends StatefulWidget {
  const UpdateChild({super.key});

  @override
  State<UpdateChild> createState() => _UpdateChildState();
}

class _UpdateChildState extends State<UpdateChild> {
  bool _isLoading = false;
  Stream? children;
  String Pname = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingChildrenList();
  }

  // string manipulation for obtaining the data
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  Future<void> gettingChildrenList() async {
    // set the loading true
    setState(() {
      _isLoading = true;
    });
    try {
      // getting the list of snapshot of children
      await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .getChildren()
          .then((snapshot) {
        setState(() {
          children = snapshot;
        });
      });

      // fetching the user name from shared perference
      String? userName = await HelperFunction.getUserName();
      if (userName == null) {
        setState(() {
          Pname = "Unknown";
        });
      } else {
        setState(() {
          Pname = userName;
        });
      }
    } catch (e) {
      throw (e);
    } finally {
      // hide loading indicator
      setState(() {
        _isLoading = false;
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
          'Update Child Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.people_alt),
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
      body: childList(),
    );
  }

  // child list that will be visible
  childList() {
    return StreamBuilder(
        stream: children,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['children'] != null) {
              if (snapshot.data['children'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['children'].length,
                    itemBuilder: (context, index) {
                      int reverseIndex =
                          snapshot.data['children'].length - index - 1;
                      return UpdateChildTile(
                          childId:
                              getId(snapshot.data['children'][reverseIndex]),
                          childName:
                              getName(snapshot.data['children'][reverseIndex]));
                    });
              } else {
                return noGroupWidget();
              }
            } else {
              return noGroupWidget();
            }
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ));
          }
        });
  }

  // No Group Widget
  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text.rich(
              TextSpan(
                  text: "Don't have any Child ",
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Register here",
                        style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // move to the create child page
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => CreateNewChild(
                                        parentName: Pname,
                                      )),
                            );
                          })
                  ]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
