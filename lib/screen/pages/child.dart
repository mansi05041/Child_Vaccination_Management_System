import 'package:child_vaccination/helper/helperFunction.dart';
import 'package:child_vaccination/services/authenticationService.dart';
import 'package:child_vaccination/services/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:child_vaccination/screen/childCreate.dart';
import 'package:child_vaccination/widget/childTile.dart';

class ChildPage extends StatefulWidget {
  const ChildPage({super.key});

  @override
  State<ChildPage> createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  String Pname = "";
  bool _isLoading = false;
  Stream? children;
  AuthenticationService authenticationService = AuthenticationService();

  @override
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // string manipulation for obtaining the data
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  // function to get the user data
  Future<void> gettingUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // fetch the username from shared preferences
      String? userName = await HelperFunction.getUserName();
      if (userName == null) {
        // user not found
        setState(() {
          Pname = "Unknown";
        });
      } else {
        setState(() {
          Pname = userName;
        });
      }

      // getting the list of snapshot of children
      await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .getChildren()
          .then((snapshot) {
        setState(() {
          children = snapshot;
        });
      });
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
        title: Text('Child Details'),
      ),
      body: childList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Register the child
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNewChild(
                parentName: Pname,
              ),
            ),
          );
        }, // Add a comma here
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }

  // child List that will be visible
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
                    return ChildTile(
                      childId: getId(snapshot.data['children'][reverseIndex]),
                      childName:
                          getName(snapshot.data['children'][reverseIndex]),
                    );
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
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
              "You've not Registered any child, tap on the add icon to register your child ",
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
