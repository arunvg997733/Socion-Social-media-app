import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/controller/authcontroller.dart';
import 'package:socion/view/screen_login.dart';
import 'package:socion/view/widget/widget.dart';

class SighUpScreen extends StatelessWidget {
   SighUpScreen({super.key});

   final getctr = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {

    final email = getctr.email.text;
    final password = getctr.password.text;
    final confirmpassword = getctr.confirmpassword.text;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              kheight30,
              const Text('Sign Up',style: TextStyle(color: kwhite),),
              kheight30,
              TextFieldWidget(controller: getctr.email, hint: "Email"),
              kheight30,
              HideTextFieldWidget(controller: getctr.password, hint: 'Password'),
              kheight30,
              TextFieldWidget(controller: getctr.confirmpassword, hint: 'Confirm password'),
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
                          final email = getctr.email.text;
                          final password = getctr.password.text;
                          final confirmpassword = getctr.confirmpassword.text;
                          
                          if(email.isEmpty||password.isEmpty||confirmpassword.isEmpty){
                            Get.snackbar("Alert", "Please fill all the fields");
                          }else if(password != confirmpassword){
                            Get.snackbar("Alert", "Check password");
                          }else{
                            getctr.signUp();
                          }
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
      ),
    );
  }
}



