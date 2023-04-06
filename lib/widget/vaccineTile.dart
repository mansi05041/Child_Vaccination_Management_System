import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VaccineTile extends StatefulWidget {
  final String age;
  final String vaccineName;
  final bool isTaken;
  final String childId;

  const VaccineTile(
      {Key? key,
      required this.age,
      required this.vaccineName,
      required this.isTaken,
      required this.childId})
      : super(key: key);

  @override
  State<VaccineTile> createState() => _VaccineTileState();
}

class _VaccineTileState extends State<VaccineTile> {
  bool _istaken = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _istaken = widget.isTaken;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('children')
                  .doc(widget.childId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                final data = snapshot.data!.data() as Map<String, dynamic>?;
                final vaccineData = data?['Vaccine'] ?? [];
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vaccineData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final vaccine = vaccineData[index];
                      final vaccineAge = vaccine['age'] ?? '';
                      final vaccineName = vaccine['vaccineName'] ?? '';

                      if (vaccineAge != widget.age ||
                          vaccineName != widget.vaccineName) {
                        return const SizedBox();
                      }
                      return RadioListTile(
                        title: Text('$vaccineName-$vaccineAge'),
                        value: true,
                        groupValue: _istaken,
                        onChanged: (bool? value) async {
                          if (value != null) {
                            setState(() {
                              _istaken = value;
                            });

                            // update the Firestore
                            final vaccineRef = FirebaseFirestore.instance
                                .collection('children')
                                .doc(widget.childId)
                                .collection('vaccine')
                                .doc('$vaccineName-$vaccineAge');
                            await vaccineRef.update({'isTaken': value});
                          }
                        },
                        secondary: Checkbox(
                          value: _istaken,
                          onChanged: (bool? value) async {
                            if (value != null) {
                              setState(() {
                                _istaken = value;
                              });

                              // update the firestore
                              final vaccineRef = FirebaseFirestore.instance
                                  .collection('children')
                                  .doc(widget.childId)
                                  .collection('Vaccine')
                                  .doc('$vaccineName-$vaccineAge');

                              await vaccineRef.update({'isTaken': value});
                            }
                          },
                        ),
                      );
                    });
              }),
        ],
      ),
    );
  }
}
