import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/controller/authcontroller.dart';
import 'package:socion/view/main_screen/screen_main.dart';
import 'package:socion/view/widget/widget.dart';

class CreateUserScreen extends StatelessWidget {
  CreateUserScreen({super.key});

  final getcrt = Get.put(AuthController());

  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    email.text = getcrt.auth.currentUser!.email!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                kheight30,
                textStyle("Create profile", 25),
                kheight30,
                TextFieldWidget(controller: name, hint: 'Name'),
                kheight30,
                TextField(
                  enabled: false,
                  style: const TextStyle(color: kwhite),
                  controller: email,
                  decoration: InputDecoration(
                    fillColor: kdarkgrey,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                kheight30,
                Obx(
                  () => InkWell(
                    onTap: () async {
                      await getcrt.verifyMail();
                    },
                    child: getcrt.verify.value == false
                        ? const Text(
                            'Verify',
                            style: TextStyle(color: kblue),
                          )
                        : const Text(
                            'Verified',
                            style: TextStyle(color: kgreen),
                          ),
                  ),
                ),
                kheight30,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [
                        Color(0xffF65F53),
                        Color(0xffDE3377),
                      ])),
                  child: TextButton(
                    onPressed: () async {
                      if (name.text.isEmpty) {
                        Get.snackbar("Alert", "Please Enter Name");
                      } else if (auth.currentUser!.emailVerified == false) {
                        Get.snackbar("Alert", "Please Verify your Account");
                      } else {
                        await getcrt.addUserDetails(name.text, email.text);
                        Get.offAll(
                          () => MainScreen(),
                        );
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Next',
                        style: TextStyle(color: kwhite),
                      ),
                    ),
                  ),
                ),
                kheight30,
                InkWell(
                  onTap: () async {
                    await auth.currentUser!.reload();
                    getcrt.changeuserstatus();
                  },
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: kblue),
                  ),
                ),
                kheight30,
                InkWell(
                  onTap: () async {
                    auth.signOut();
                    Get.back();
                  },
                  child: const Text(
                    'Go to Login Screen',
                    style: TextStyle(color: kblue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
