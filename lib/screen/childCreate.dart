import 'package:child_vaccination/screen/MyHomePage.dart';
import 'package:child_vaccination/screen/pages/Profile.dart';
import 'package:child_vaccination/services/authenticationService.dart';
import 'package:child_vaccination/shared/validity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CreateNewChild extends StatefulWidget {
  const CreateNewChild({super.key});

  @override
  State<CreateNewChild> createState() => _CreateNewChildState();
}

class _CreateNewChildState extends State<CreateNewChild> {
  final formkey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _allergyController = TextEditingController();
  late DateTime _selectedDate;
  String name = "";
  String gender = "Male";
  var genderOptions = ['Male', 'Female', 'Others'];
  String bloodGroup = "A+";
  var bloodGroupOptions = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  List<String> _selectedAllergies = [];
  bool _isLoading = false;
  AuthenticationService authenticationService = AuthenticationService();

  @override
  void dispose() {
    _allergyController.dispose();
    super.dispose();
  }

  void _addNewAllergy() {
    final newAllergy = _allergyController.text.trim();
    if (newAllergy.isNotEmpty) {
      setState(() {
        _selectedAllergies.add(newAllergy);
        _allergyController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Form(
                        key: formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 5),
                            Center(
                              child: Text(
                                "Register Your Child",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.1,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                  text: "Already Registered? ",
                                  style: const TextStyle(
                                      color: Colors.blueAccent, fontSize: 14),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Click Here!",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyHomePage(),
                                              ),
                                            );
                                          })
                                  ]),
                            ),
                            const SizedBox(height: 12),
                            // Name
                            TextFormField(
                              controller: _nameTextController,
                              validator: (value) => Validator.validateName(
                                  name: _nameTextController.text),
                              decoration: InputDecoration(
                                hintText: "Child Name",
                                prefixIcon: Icon(
                                  Icons.child_care_sharp,
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
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            // Date of Birth
                            DateTimeField(
                              decoration: InputDecoration(
                                labelText: 'Date of Birth',
                                prefixIcon: Icon(
                                  Icons.date_range_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              format: DateFormat('yyyy-MM-dd'),
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: currentValue ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  _selectedDate = date;
                                }
                                return date;
                              },
                              onChanged: (value) {
                                _selectedDate = value!;
                              },
                              onSaved: (value) {
                                _selectedDate = value!;
                              },
                            ),
                            const SizedBox(height: 12),
                            // Gender
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                prefixIcon: Icon(
                                  Icons.transgender_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              value: gender,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined),
                              items: genderOptions.map((String genderOptions) {
                                return DropdownMenuItem(
                                  value: genderOptions,
                                  child: Text(genderOptions),
                                );
                              }).toList(),
                              onChanged: ((String? newValue) {
                                setState(() {
                                  gender = newValue!;
                                });
                              }),
                            ),
                            const SizedBox(height: 12),
                            // Blood Group
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Blood group',
                                prefixIcon: Icon(
                                  Icons.bloodtype,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              value: bloodGroup,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined),
                              items: bloodGroupOptions
                                  .map((String bloodGroupOptions) {
                                return DropdownMenuItem(
                                  value: bloodGroupOptions,
                                  child: Text(bloodGroupOptions),
                                );
                              }).toList(),
                              onChanged: ((String? newValue) {
                                setState(() {
                                  bloodGroup = newValue!;
                                });
                              }),
                            ),
                            // Allergies
                            const SizedBox(height: 12),
                            CheckboxListTile(
                              title: const Text('Existing Allergies'),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _selectedAllergies.isNotEmpty,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedAllergies = value ? ['None'] : [];
                                  });
                                }
                              },
                            ),
                            ..._buildAllergyCheckboxes(),
                            // Add new allergy
                            TextFormField(
                              controller: _allergyController,
                              validator: (value) => Validator.validateAllergy(
                                  value: _allergyController.text),
                              decoration: const InputDecoration(
                                labelText: 'Add New Allergy',
                                prefixIcon: Icon(
                                  Icons.medical_information_outlined,
                                  color: Color.fromARGB(255, 160, 195, 224),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 160, 195, 224),
                                    width: 1.0,
                                  ),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: _addNewAllergy,
                                child: const Text(
                                  "Add Allergy",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Register button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  "Register Your Child",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  List<Widget> _buildAllergyCheckboxes() {
    return [
      for (final allergy in _selectedAllergies)
        CheckboxListTile(
          title: Text(allergy),
          controlAffinity: ListTileControlAffinity.leading,
          value: allergy == 'None' ? _selectedAllergies.length == 1 : true,
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                if (allergy == 'None') {
                  _selectedAllergies = value ? ['None'] : [];
                } else if (value) {
                  _selectedAllergies.add(allergy);
                } else {
                  _selectedAllergies.remove(allergy);
                }
              });
            }
          },
        ),
    ];
  }
}
