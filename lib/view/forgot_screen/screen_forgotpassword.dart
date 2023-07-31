import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/authcontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/login_screen/screen_login.dart';
import 'package:socion/view/widget/widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController reset = TextEditingController();
  final getctr = Get.put(
    AuthController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              kheight30,
              textStyle('Reset Password', 25),
              kheight30,
              TextFieldWidget(controller: reset, hint: 'Email'),
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
                    getctr.resetPassword(reset.text);
                    Get.offAll(() => LoginScreen());
                  },
                  child: const Center(
                    child: Text(
                      'Send Reset Link',
                      style: TextStyle(color: kwhite),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
