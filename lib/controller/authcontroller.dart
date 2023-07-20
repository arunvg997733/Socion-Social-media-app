import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socion/view/screen_createuser.dart';
import 'package:socion/view/screen_login.dart';
import 'package:socion/view/screen_main.dart';
import 'package:socion/view/screen_profile.dart';

class AuthController extends GetxController{

  GoogleSignIn google = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebasedb = FirebaseFirestore.instance;
  var verify = false.obs;

  

  changeuserstatus(){
    verify.value = auth.currentUser!.emailVerified;
  }


  signUp(String email,String password)async{
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Your Account is created. Please login");
      Get.to(()=>LoginScreen());
    } catch (e) {
      Get.snackbar(overlayColor: Colors.amber,'Error', '$e');
    }
  }

  signIn(String loginemail,String loginpassword )async{
    try {
      await auth.signInWithEmailAndPassword(email: loginemail, password: loginpassword);
      if(auth.currentUser!.emailVerified == true){
        Get.offAll(()=>ProfileScreen());
      }else{
        Get.offAll(()=>CreateUserScreen());
      }
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }

  verifyMail()async{
    await auth.currentUser?.sendEmailVerification();
    Get.snackbar("Success", "Verification sent to use mail");
  }

  signOut()async{
    await auth.signOut();
  }

  addUserDetails(String name,String emaildata)async{
    final CollectionReference userdata = FirebaseFirestore.instance.collection('userdata');

    final data = {
      'name':name,
      'email':emaildata,
    };

    try {
      await userdata.add(data);
    } catch (e) {
      Get.snackbar("Error", "$e");
    }

    

  }

  resetPassword(String resetpassword)async{
    try {
      await auth.sendPasswordResetEmail(email: resetpassword);
      Get.snackbar("Success", 'Reset link sent to your mail');
    } catch (e) {
      Get.snackbar("Error", '$e');
    }
  }

  checkuserstatus()async{
    final  status = await auth.currentUser;
    if(status == null){
      Get.offAll(()=>LoginScreen());
    }else{
      Get.offAll(()=>MainScreen());
    }
  }

  googleSignIn()async{
    try {
      final GoogleSignInAccount? googlesignin = await google.signIn();
      if(googlesignin != null){
        final GoogleSignInAuthentication googlesigninauth = await googlesignin.authentication;
        final AuthCredential authcredential = GoogleAuthProvider.credential(
          accessToken: googlesigninauth.accessToken,
          idToken: googlesigninauth.idToken
        );
        await auth.signInWithCredential(authcredential);
      }
      Get.to(()=>CreateUserScreen());
    } catch (e) {
      Get.snackbar("Error", '$e');
    }
   
  }
}