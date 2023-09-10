import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/navbar_controller.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/controller/userprofilecontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/follw_screen/screen_follow.dart';
import 'package:socion/view/login_screen/screen_login.dart';
import 'package:socion/view/profile_edit_screen/screen_profile_edit.dart';
import 'package:socion/view/current_user_post_view_screen/screen_current_user_post_view.dart';
import 'package:socion/view/widget/widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final getNav = Get.put(NavBarController());
  final getpost = Get.put(PostController());
  final getOther = Get.put(UserProfileController());
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference user =
      FirebaseFirestore.instance.collection('userdata');
  @override
  Widget build(BuildContext context) {
    getOther.getCurrentUserFollowerCount();
    getOther.getCurrentUserFollowingCount();
    getpost.postcount();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kblack,
        actions: [
          IconButton(onPressed: () {
            profileShowDialog(context);
          }, icon: iconStyle(Icons.more_vert_rounded))
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: StreamBuilder(
            stream: user.doc(auth.currentUser?.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    kheight30,
                    CircleAvatar(
                        radius: 70,
                        backgroundImage: snapshot.data!['image'] == ''
                            ? const AssetImage('assets/user.jpg')
                                as ImageProvider
                            : NetworkImage(snapshot.data!['image'])),
                    kheight30,
                    textStyle(snapshot.data!['name'], 20),
                    kheight10,
                    SizedBox(
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
                              getNav.onSelected(1);
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
                              Obx(() => textStyle(
                                  getpost.userpostcount.toString(), 20)),
                              textStyle('Post', 15),
                            ],
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              getOther.getfollowerList(
                                  getOther.auth.currentUser!.uid);
                              Get.to(FollowScreen(
                                  text: 'Follower',
                                  newlist: getOther.followinglist));
                            },
                            child: Column(
                              children: [
                                Obx(
                                  () => textStyle(
                                      getOther.followercount.toString(), 20),
                                ),
                                textStyle('Followers', 15),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              getOther.getfollowingList(
                                  getOther.auth.currentUser!.uid);
                              Get.to(FollowScreen(
                                  text: 'Following',
                                  newlist: getOther.followinglist));
                            },
                            child: Column(
                              children: [
                                Obx(
                                  () => textStyle(
                                      getOther.followingCount.toString(), 20),
                                ),
                                textStyle('Following', 15),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    kheight30,
                    //Userpost
                    StreamBuilder(
                        stream: getpost.postData
                            .doc(auth.currentUser?.uid)
                            .collection('singleuserpost')
                            .orderBy('time')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return textStyle('Error - ${snapshot.error}', 12);
                          } else if (snapshot.data!.docs.isEmpty) {
                            return SizedBox(
                                height: 100,
                                child: Center(child: textStyle('No Post', 20)));
                          }

                          return GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                              snapshot.data!.docs.length,
                              (index) {
                                // final data = newlist[index];
                                final data = snapshot.data!.docs[index];
                                return InkWell(
                                  onTap: () {
                                    Get.to(() => CurrentUserPostViewScreen(
                                          index: index,
                                          userId: getpost.auth.currentUser?.uid,
                                        ));
                                  },
                                  child: data['image'] != null
                                      ? Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(data['image']),
                                                fit: BoxFit.cover),
                                          ),
                                        )
                                      : const CircularProgressIndicator(),
                                );
                              },
                            ),
                          );
                        }),
                    kheight30
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


profileShowDialog(BuildContext context){
  final FirebaseAuth auth = FirebaseAuth.instance;
  showModalBottomSheet(
    shape: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
    backgroundColor: kdarkgrey,
    context: context, builder: (context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(color: kwhite,endIndent: 130,indent: 130,thickness: 2,),
          kheight30,
          Expanded(
            child: ListView(
              children: [
                InkWell(
              child: SingleListTile(icon: Icons.person, text: 'About'),
            ),
            InkWell(
              child: SingleListTile(icon: Icons.list_alt_sharp, text: 'Terms and condition'),
            ),
            InkWell(
              child: SingleListTile(icon: Icons.privacy_tip, text: 'Privacy'),
            ),
            InkWell(
              onTap: () async{
                await auth.signOut();
                Get.offAll(LoginScreen());
              },
              child: SingleListTile(icon: Icons.logout, text: 'Logout'),
            ),
              ],
            ),
          )
          
        ],
      ),
    );
  },);
}

class SingleListTile extends StatelessWidget {
   SingleListTile({super.key,required this.icon,required this.text});
  String text;
  IconData icon;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          iconStyle(icon),
          kwidth10,
          textStyle(text, 15)
        ],
      ),
    );
  }
}