import 'package:child_vaccination/helper/helperFunction.dart';
import 'package:child_vaccination/services/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthenticationService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  // register with googleSign in
  Future RegisterWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        final UserCredential userCredential =
            await firebaseAuth.signInWithPopup(authProvider);
        User? user = userCredential.user!;
        // call our database service to update the user data
        DataBaseService(uid: user.uid)
            .updateUserData(user.displayName ?? "User", user.email!);

        await HelperFunction.saveUserLoggedInStatus(true);
        await HelperFunction.saveUserEmailSF(user.email!);
        await HelperFunction.saveUserNameSF(user.displayName!);
        return true;
      } else {
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
          // call our database service to update the user data
          DataBaseService(uid: user.uid)
              .updateUserData(user.displayName ?? "User", user.email!);
          // saving the shared prefernce state
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(user.email!);
          await HelperFunction.saveUserNameSF(user.displayName!);
        }
        return true;
      }
    } catch (e) {
      return 'Error in Registering with Google. Try Again';
    }
  }

  // register with email and password
  Future registerUserWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        // call our database service to update the user data
        DataBaseService(uid: user.uid).updateUserData(name, email);
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
}
