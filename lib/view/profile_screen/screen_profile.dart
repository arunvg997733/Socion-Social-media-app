import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/login_screen/screen_login.dart';
import 'package:socion/view/profile_edit_screen/screen_profile_edit.dart';
import 'package:socion/view/widget/widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference user =
      FirebaseFirestore.instance.collection('userdata');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: StreamBuilder(
            stream: user.doc(auth.currentUser?.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              await auth.signOut();
                              Get.offAll(LoginScreen());
                            },
                            icon: iconStyle(Icons.logout))
                      ],
                    ),
                    kheight30,
                     CircleAvatar(
                        radius: 70,
                        backgroundImage: snapshot.data!['image']==''?AssetImage('assets/user.jpg') as ImageProvider: NetworkImage(snapshot.data!['image'])),
                    kheight30,
                    textStyle(snapshot.data!['name'], 20),
                    kheight10,
                    Container(
                      width: 150,
                      child:
                          Center(child: textStyle(snapshot.data!['bio'], 14)),
                    ),
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
                              ])),
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => ProfileEditScreen(
                                    name: snapshot.data?['name'],
                                    bio: snapshot.data?['bio'],
                                    gender: snapshot.data?['gender'],
                                    image: snapshot.data?['image'],
                                  ));
                            },
                            child: Center(child: textStyle('Edit Profile', 14)),
                          ),
                        ),
                        kwidth10,
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(colors: [
                                Color(0xffF65F53),
                                Color(0xffDE3377),
                              ])),
                          child: TextButton(
                            onPressed: () async {
                              GoogleSignIn google = GoogleSignIn();
                              final GoogleSignInAccount? googlesignin =
                                  await google.signIn();
                            },
                            child: Center(
                                child: iconStyle(Icons.group_add_outlined)),
                          ),
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
                    GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        10,
                        (index) {
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/car.jpeg'),
                                  fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
