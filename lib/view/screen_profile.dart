import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/view/screen_login.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(onPressed: () async{
              await auth.signOut();
              Get.offAll(LoginScreen());
            }, child: Text("Sign Out"))
          ],
        ),
      ),
    );
  }
}