import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference childCollection =
      FirebaseFirestore.instance.collection("children");

  // updating the userdata
  Future updateUserData(String name, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": name,
      "email": email,
      "children": [],
      "profilePic": "",
      "uid": uid,
    });
  }
}
