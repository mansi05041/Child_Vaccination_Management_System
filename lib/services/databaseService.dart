import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference childCollection =
      FirebaseFirestore.instance.collection("children");

  // updating the userdata
  Future updateUserData(String name, String email, String gender) async {
    return await userCollection.doc(uid).set({
      "fullName": name,
      "email": email,
      "children": [],
      "profilePic": "",
      "gender": gender,
      "uid": uid,
    });
  }

  // update the userProfile
  Future userProfileUpdate(String url) async {
    return await userCollection.doc(uid).update({
      "profilePic": url,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // creating the childData
  Future CreateChildData(
      String parentName,
      String childName,
      String gender,
      String bloodGrp,
      DateTime date,
      List<String> Allergies,
      List<Map<String, dynamic>> vaccines) async {
    DocumentReference childDocumentReference = await childCollection.add({
      "childName": childName,
      "parentName": parentName,
      "Vaccine": vaccines,
      "ChildId": "",
      "Gender": gender,
      "DateOfBirth": date,
      "Allergies": Allergies,
      "BloodGroup": bloodGrp,
    });

    // update the children
    await childDocumentReference.update({
      "ChildId": childDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "children":
          FieldValue.arrayUnion(["${childDocumentReference.id}_$childName"])
    });
  }

  // getting childrenList
  getChildren() async {
    return userCollection.doc(uid).snapshots();
  }

  // getting childDetails
  Future<QuerySnapshot> getChildDetail(String childId) async {
    QuerySnapshot snapshot =
        await childCollection.where("ChildId", isEqualTo: childId).get();
    return snapshot;
  }

  // update isTaken of vaccine
  Future<void> updateVaccineisTaken(
      String childId, String vaccineName, bool isTaken) async {
    // Get the document that contains the child's data
    final chilDocument = await childCollection.doc(childId).get();
    // Get the current value of the Vaccine array
    final vaccines =
        List<Map<String, dynamic>>.from(chilDocument.get('Vaccine'));
    // Find the vaccine with the specified name and update its isTaken
    final vaccineIndex =
        vaccines.indexWhere((vaccine) => vaccine['vaccineName'] == vaccineName);
    if (vaccineIndex != -1) {
      final updatedVaccine = Map<String, dynamic>.from(vaccines[vaccineIndex])
        ..['isTaken'] = isTaken;
      vaccines[vaccineIndex] = updatedVaccine;
    }
    // update the vaccine array with the updated values
    await childCollection.doc(childId).update({'Vaccine': vaccines});
  }
}
