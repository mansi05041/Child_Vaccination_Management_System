import 'package:child_vaccination/screen/MyHomePage.dart';
import 'package:child_vaccination/screen/settings/update_child.dart';
import 'package:child_vaccination/screen/settings/update_profile.dart';
import 'package:flutter/material.dart';

class UpdateVaccine extends StatefulWidget {
  const UpdateVaccine({super.key});

  @override
  State<UpdateVaccine> createState() => _UpdateVaccineState();
}

class _UpdateVaccineState extends State<UpdateVaccine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Update Vaccine Details',
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
    );
  }
}
