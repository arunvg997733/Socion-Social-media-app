import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/screen_login.dart';
import 'package:socion/view/widget/widget.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference user = FirebaseFirestore.instance.collection('userdata');
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
     body: SafeArea(
       child: SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.all(5.0),
           child: Column(
             children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(onPressed: ()async{
                    await auth.signOut();
                        Get.offAll(LoginScreen());
                  }, icon: iconStyle(Icons.logout))
                  
                ],
              ),
              kheight30,
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/car.jpeg')
              ),
              kheight30,
              textStyle('Name', 20),
              kheight30,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [
                        Color(0xffF65F53),
                        Color(0xffDE3377),
                      ])
                    ),
                  child: TextButton(
                    
                    onPressed: () {
                     
                  },child: const Center(child: Text('Edit Profile',style: TextStyle(color: kwhite))),),
                ),
                kwidth10,
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [
                        Color(0xffF65F53),
                        Color(0xffDE3377),
                      ])
                    ),
                  child: TextButton(
                    
                    onPressed: () {
                      
                  },child:  Center(child: iconStyle(Icons.group_add_outlined)),),
                ),
                ],
              ),
              kheight30,
       
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        textStyle('20', 20),
                        textStyle('Post', 15),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        textStyle('486', 20),
                        textStyle('Followers', 15),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        textStyle('380', 20),
                        textStyle('Following', 15),
                      ],
                    ),
                  )
                ],
              ),
              kheight30,
              GridView.count(crossAxisCount: 3,
              childAspectRatio: 1, 
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(10, (index) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/car.jpeg'),fit: BoxFit.cover)
                  ),
                );
              }),)
             ],
           ),
         ),
       ),

     ),
    ) ;
  }
}