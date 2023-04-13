import 'package:child_vaccination/screen/vaccine.dart';
import 'package:flutter/material.dart';

class ChildTile extends StatelessWidget {
  final String childName;
  final String childId;

  const ChildTile({Key? key, required this.childId, required this.childName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildPlanCard(context, childName)],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, String ChildName) {
    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              childName.toUpperCase(),
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.07,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // show the vaccine Details of children
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VaccinePage(childId: childId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
              child: const Text("Vaccine Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
