import 'package:cloud_firestore/cloud_firestore.dart';
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

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // creating the childData
  Future CreateChildData(String parentName, String childName, String gender,
      String bloodGrp, DateTime date, List<String> Allergies) async {
    DocumentReference childDocumentReference = await childCollection.add({
      "childName": childName,
      "parentName": parentName,
      "vaccines": [],
      "ChildId": "",
      "Gender": gender,
      "DateOfBirth": date,
      "Allergies": Allergies,
      "BloodGroup": bloodGrp,
    });
  }
}
