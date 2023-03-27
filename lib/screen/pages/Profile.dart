import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 160, 195, 224),
      appBar: AppBar(
        toolbarHeight: 20,
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(children: [
          Container(
            height: 200,
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                "helena Joshua", // change the name using shared preference
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: 100,
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                "helena Joshua", // change the name using shared preference
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/registerChild');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class RegisterChild extends StatefulWidget {
  @override
  State<RegisterChild> createState() => _RegisterChildState();
}

class _RegisterChildState extends State<RegisterChild> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();
  String gender = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 160, 195, 224),
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 56, 93, 124),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Name',
                    contentPadding: EdgeInsets.all(16.0),
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 25, 76, 117),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  // use datetime picker to get the date
                  controller: _dobController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Date of Birth',
                    contentPadding: EdgeInsets.all(16.0),
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 25, 76, 117),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  // have drop down menu
                  controller: _bloodGroupController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Blood Group',
                    contentPadding: EdgeInsets.all(16.0),
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              //
              Text('Gender'),
              Row(
                children: [
                  Radio(
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  Text('Male'),
                  Radio(
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  Text('Female'),
                  Radio(
                    value: 'Other',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  Text('Other'),
                ],
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed:
                    () {}, // create the tile and vaccine details   *(Pending)
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
