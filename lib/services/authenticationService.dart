import 'package:child_vaccination/helper/helperFunction.dart';
import 'package:child_vaccination/services/databaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticationService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // login
  Future loginInUserWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register with google
  Future RegisterWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      User? user = (await firebaseAuth.signInWithCredential(credential)).user;
      if (user != null) {
        // check if user already exists in database
        final DocumentSnapshot userDoc =
            await _firebaseFirestore.collection("users").doc(user.uid).get();
        if (!userDoc.exists) {
          // user does not exists, create new user
          // getting gender
          final GoogleSignInAccount? currentUser =
              await _googleSignIn.signInSilently();
          final Map<String, dynamic>? googleProfileDataMap = await currentUser
              ?.authentication
              .then((value) => value.idToken)
              .then((value) => getGoogleProfileData(value!));
          final String? gender = googleProfileDataMap?['gender'];
          // call our database service to update the user data
          DataBaseService(uid: user.uid).updateUserData(
              user.displayName ?? "User", user.email!, gender ?? "Unknown");

          // fetch the google photo url
          final String? photoUrl = currentUser?.photoUrl;
          await DataBaseService(uid: user.uid).userProfileUpdate(photoUrl!);
        }
        // saving the shared prefernce state
        await HelperFunction.saveUserLoggedInStatus(true);
        await HelperFunction.saveUserEmailSF(user.email!);
        await HelperFunction.saveUserNameSF(user.displayName!);
        return true;
      }
    } catch (e) {
      return 'Error in Registering with Google. Try Again';
    }
  }

  // requesting google profile
  Future<Map<String, dynamic>> getGoogleProfileData(String idToken) async {
    final Uri url = Uri.parse(
        'https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=$idToken');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch Google profile data');
    }
  }

  // register with email and password
  Future registerUserWithEmailAndPassword(
      String name, String email, String password, String gender) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        // call our database service to update the user data
        DataBaseService(uid: user.uid).updateUserData(name, email, gender);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // sign out
  Future SignOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await HelperFunction.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  // reset the password
  Future resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else {
        return 'An error occurred while resetting password. Please try again later.';
      }
    } catch (e) {
      return 'An error occurred while resetting password. Please try again later.';
    }
  }

  // get the user authentication provider
  Future<String?> authenticationProvider() async {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      if (user.providerData.any(
          (element) => element.providerId == GoogleAuthProvider.PROVIDER_ID)) {
        return "Google";
      } else if (user.providerData.any(
          (element) => element.providerId == EmailAuthProvider.PROVIDER_ID)) {
        return "Email";
      }
    }
    return null;
  }
}
