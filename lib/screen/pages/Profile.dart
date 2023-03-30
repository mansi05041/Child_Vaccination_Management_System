import 'package:child_vaccination/helper/helperFunction.dart';
import 'package:child_vaccination/screen/childCreate.dart';
import 'package:child_vaccination/services/authenticationService.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  bool _isLoading = false;
  AuthenticationService authenticationService = AuthenticationService();

  @override
  @override
  void initState() {
    super.initState();
    gettingUserData();
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
          name = "Unknown";
        });
      } else {
        setState(() {
          name = userName;
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
        toolbarHeight: 100,
      ),
      drawer: Drawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // image
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              // name
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$name',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateNewChild()),
          ).then((value) {
            if (value != null && value is String) {
              // handle the result if needed
            }
          });
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }
}
