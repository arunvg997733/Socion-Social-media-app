import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/screen_login.dart';
import 'package:socion/view/widget/widget.dart';

class SighUpScreen extends StatelessWidget {
   SighUpScreen({super.key});

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            kheight30,
            const Text('Sign Up',style: TextStyle(color: kwhite),),
            kheight30,
            TextFieldWidget(controller: username, hint: "Username"),
            kheight30,
            TextFieldWidget(controller: email, hint: "Email"),
            kheight30,
            TextFieldWidget(controller: password, hint: 'Password'),  
            kheight30,
            Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(colors: [
                          Color(0xffF65F53),
                          Color(0xffDE3377),
                        ])
                      ),
                    child: TextButton(
                      
                      onPressed: () {
                        print(username.text);
                        print(email.text);
                        print(password.text);
                      // Get.to(()=>LoginScreen());
                    },child: const Center(child: Text('Sign Up',style: TextStyle(color: kwhite))),),
                  ), 
            kheight30,
            const Text('Already have account?',style: TextStyle(color: kwhite),),
            kheight30,
            InkWell(
                  onTap: () {
                    Get.to(()=>LoginScreen());
                  },
                  child: const Text('Sign In',style: TextStyle(color: kblue))),      
          ],),
        ),
      ),
    );
  }
}



