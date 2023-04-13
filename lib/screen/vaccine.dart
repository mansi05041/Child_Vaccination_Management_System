import 'package:child_vaccination/screen/settings/update_child.dart';
import 'package:child_vaccination/services/databaseService.dart';
import 'package:child_vaccination/widget/vaccineTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class VaccinePage extends StatefulWidget {
  final String childId;
  const VaccinePage({Key? key, required this.childId}) : super(key: key);

  @override
  State<VaccinePage> createState() => _VaccinePageState();
}

class _VaccinePageState extends State<VaccinePage> {
  late QuerySnapshot childSnapshot;
  bool _isLoading = false;
  DataBaseService dataBaseService = DataBaseService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVaccineDetails();
  }

  // Function to get the vaccine snapshot
  Future<void> getVaccineDetails() async {
    setState(() {
      _isLoading = true;
    });
    // try to fetch the snapshot of vaccines
    try {
      await dataBaseService.getChildDetail(widget.childId).then((value) {
        setState(() {
          childSnapshot = value;
        });
      });
    } catch (e) {
      throw (e);
    } finally {
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UpdateChild()),
                );
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              )),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : vaccineList(),
    );
  }

  // list of vaccines
  Widget vaccineList() {
    List<Map<String, dynamic>> vaccines =
        List.castFrom(childSnapshot.docs[0]['Vaccine']);
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StickyHeader(
          header: Container(
            color: Colors.white,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: DetailsTile(childSnapshot: childSnapshot),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'VACCINES',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: vaccines.length,
                    itemBuilder: (context, index) {
                      var vaccineData = vaccines[index];
                      return VaccineTile(
                        age: vaccineData['age'],
                        vaccineName: vaccineData['vaccineName'],
                        isTaken: vaccineData['isTaken'],
                        childId: widget.childId,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}

// details tile
class DetailsTile extends StatelessWidget {
  final QuerySnapshot childSnapshot;
  const DetailsTile({Key? key, required this.childSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // get the child data
    Map<String, dynamic> childData =
        childSnapshot.docs[0].data() as Map<String, dynamic>;
    DateTime dob = childData['DateOfBirth'].toDate();

    // get the allergies array from the childData
    List<dynamic> allergies = List<dynamic>.from(childData['Allergies'] ?? []);

    String formattedDob = DateFormat('dd/MM/yyyy').format(dob);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        title: Text(
          childData['childName'].toUpperCase(),
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.1,
            fontWeight: FontWeight.w900,
            color: Colors.blueGrey,
          ),
          textAlign: TextAlign.center,
        ),
        subtitle: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Gender: ${childData['Gender']}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Date of Birth: $formattedDob',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Parent\'s Name: ${childData['parentName']}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Blood Group: ${childData['BloodGroup']}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Allergies: ${allergies.join(", ")}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
