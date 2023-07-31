import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/controller/authcontroller.dart';
import 'package:socion/view/forgot_screen/screen_forgotpassword.dart';
import 'package:socion/view/signing_screen/screen_signin.dart';
import 'package:socion/view/widget/widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final getctr = Get.put(AuthController());

  final TextEditingController loginemail = TextEditingController();
  final TextEditingController loginpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                kheight30,
                textStyle('Login', 25),
                kheight30,
                TextFieldWidget(controller: loginemail, hint: 'Email'),
                kheight30,
                HideTextFieldWidget(
                    controller: loginpassword, hint: 'Password'),
                kheight30,
                InkWell(
                    onTap: () {
                      Get.to(() => ForgotPasswordScreen());
                    },
                    child: const Text('Forgot password ?',
                        style: TextStyle(color: kblue))),
                kheight30,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [
                        Color(0xffF65F53),
                        Color(0xffDE3377),
                      ])),
                  child: TextButton(
                    onPressed: () {
                      getctr.signIn(loginemail.text, loginpassword.text);
                    },
                    child: const Center(
                        child: Text('Login', style: TextStyle(color: kwhite))),
                  ),
                ),
                kheight30,
                const Row(
                  children: [
                    Expanded(
                        child: Divider(
                      color: kwhite,
                      endIndent: 20,
                    )),
                    Text(
                      'Or',
                      style: TextStyle(color: kwhite),
                    ),
                    Expanded(
                        child: Divider(
                      color: kwhite,
                      indent: 20,
                    ))
                  ],
                ),
                kheight30,
                const Text("Don't have an account",
                    style: TextStyle(color: kwhite)),
                kheight30,
                InkWell(
                    onTap: () {
                      Get.to(() => SighUpScreen());
                    },
                    child:
                        const Text('Sign Up', style: TextStyle(color: kblue))),
                kheight30,
                InkWell(
                  onTap: () async {
                    await getctr.googleSignIn();
                    await getctr.auth.currentUser!.reload();
                    getctr.changeuserstatus();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kdarkgrey,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/google.png', height: 25),
                        kwidth10,
                        const Text(
                          "Use Google Account",
                          style: TextStyle(color: kwhite),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
