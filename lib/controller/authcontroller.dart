import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/model/user_model.dart';
import 'package:socion/view/create_profile_screen/screen_createuser.dart';
import 'package:socion/view/login_screen/screen_login.dart';
import 'package:socion/view/main_screen/screen_main.dart';

class AuthController extends GetxController {
  GoogleSignIn google = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebasedb = FirebaseFirestore.instance;
  final CollectionReference user =
      FirebaseFirestore.instance.collection('userdata');
  var verify = false.obs;

  changeuserstatus() {
    verify.value = auth.currentUser!.emailVerified;
  }

  signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.snackbar("Success", "Your Account is created");
      if (auth.currentUser!.emailVerified == true) {
        Get.offAll(() => MainScreen());
      } else {
        Get.offAll(() => CreateUserScreen());
      }
    } catch (e) {
      Get.snackbar(overlayColor: Colors.amber, 'Error', '$e');
    }
  }

  signIn(String loginemail, String loginpassword) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: loginemail, password: loginpassword);
      if (auth.currentUser!.emailVerified == true) {
        Get.offAll(() => MainScreen());
      } else {
        Get.offAll(() => CreateUserScreen());
      }
    } catch (e) {
      Get.snackbar('Error', '$e', backgroundColor: kwhite);
    }
  }

  verifyMail() async {
    await auth.currentUser?.sendEmailVerification();
    Get.snackbar("Success", "Verification sent to use mail");
  }

  signOut() async {
    await auth.signOut();
  }

  addUserDetails(String name, String emaildata) async {
    final DocumentReference userdata = FirebaseFirestore.instance
        .collection('userdata')
        .doc(auth.currentUser?.uid);

    final data = UserModel(
            name: name,
            email: emaildata,
            id: auth.currentUser?.uid,
            bio: '',
            image: '',
            gender: '')
        .toMap();

    // final data = {
    //   'name': name,
    //   'email': emaildata,
    //   'userid': auth.currentUser?.uid,
    //   'image': '',
    //   'bio': '',
    //   'gender': ''
    // };

    try {
      await userdata.set(data);
    } catch (e) {
      Get.snackbar("Error", "$e");
    }
  }

  resetPassword(String resetpassword) async {
    try {
      await auth.sendPasswordResetEmail(email: resetpassword);
      Get.snackbar("Success", 'Reset link sent to your mail');
    } catch (e) {
      Get.snackbar("Error", '$e');
    }
  }

  checkuserstatus() async {
    final userdata = await firebasedb
        .collection('userdata')
        .doc(auth.currentUser?.uid)
        .get();
    final status = auth.currentUser;

    if (status == null) {
      Get.offAll(
        () => LoginScreen(),
      );
    } else if (auth.currentUser?.emailVerified == false) {
      Get.offAll(
        () => CreateUserScreen(),
      );
    } else if (!userdata.exists) {
      Get.offAll(
        () => CreateUserScreen(),
      );
    } else {
      Get.offAll(
        () => MainScreen(),
      );
    }
  }

  googleSignIn() async {
    try {
      final GoogleSignInAccount? googlesignin = await google.signIn();
      if (googlesignin != null) {
        final GoogleSignInAuthentication googlesigninauth =
            await googlesignin.authentication;
        final AuthCredential authcredential = GoogleAuthProvider.credential(
            accessToken: googlesigninauth.accessToken,
            idToken: googlesigninauth.idToken);

        await auth.signInWithCredential(authcredential);

      }
      final userdata = await FirebaseFirestore.instance
          .collection('userdata')
          .doc(auth.currentUser?.uid)
          .get();

      if (userdata.exists) {
        Get.offAll(() => MainScreen());
      } else {
        await addUserDetails(auth.currentUser!.displayName.toString(),
            auth.currentUser!.email.toString());
        Get.offAll(() => MainScreen());
      }
      Get.snackbar("Success", 'You are Loging Successfully');
    } catch (e) {
      Get.snackbar("Error", '$e');
    }
  }

  updateuserdetails(
      String name, String bio, String gender, String image) async {
    final CollectionReference user = firebasedb.collection('userdata');
    // final userdata = UserModel(name: name,bio: bio,gender: gender,image: image).toMap();
    final data = {
      'name': name,
      'bio': bio,
      'gender': gender,
      'image': image,
    };
    user.doc(auth.currentUser?.uid).update(data);
  }
}
