import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/screen_signin.dart';
import 'package:socion/view/widget/widget.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                kheight30,
                const Text('Login',style: TextStyle(color: kwhite),),
                kheight30,
                TextFieldWidget(controller: username, hint: 'Email'),
                kheight30,
                TextFieldWidget(controller
                : password, hint: 'Password'),
                kheight30,
                const Text('Forgot password ?',style: TextStyle(color: kwhite)),
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
                    
                  },child: const Center(child: Text('Login',style: TextStyle(color: kwhite))),),
                ),
                kheight30,
                const Row(
                  children: [
                    Expanded(child: Divider(color: kwhite,endIndent: 20,)),
                    Text('Or',style: TextStyle(color: kwhite),),
                    Expanded(child: Divider(color: kwhite,indent: 20,))
                  ],
                  
                ),
                kheight30,
                const Text("Don't have an account",style: TextStyle(color: kwhite)),
                kheight30,
                InkWell(
                  onTap: () {
                    Get.to(()=>SighUpScreen());
                  },
                  child: const Text('Sign Up',style: TextStyle(color: kblue))),
                kheight30, 
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kdarkgrey,
                    
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