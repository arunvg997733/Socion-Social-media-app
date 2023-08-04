import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/authcontroller.dart';
import 'package:socion/controller/navbar_controller.dart';
import 'package:socion/controller/profile_pic_contoller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/widget/widget.dart';

// ignore: must_be_immutable
class ProfileEditScreen extends StatelessWidget {
  ProfileEditScreen(
      {super.key,
      required this.name,
      required this.bio,
      required this.gender,
      required this.image});
  String name;
  String bio;
  String gender;
  String image;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // String? username;
  final TextEditingController namectr = TextEditingController();
  final TextEditingController bioctr = TextEditingController();
  final List<String> genderlist = ['Male', 'Female'];

  final getctr = Get.put(AuthController());
  final getnav = Get.put(NavBarController());
  final getimg = Get.put(ProfilePickController());

  @override
  Widget build(BuildContext context) {
    getimg.image.value = '';
    namectr.text = name;
    bioctr.text = bio;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                kheight30,
                Obx(
                  () => Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: getimg.image.value == ''
                            ? image == ''
                                ? AssetImage('assets/user.jpg') as ImageProvider
                                : NetworkImage(image) as ImageProvider
                            : FileImage(File(getimg.image.value)),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: kmixcolorpink,
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: kdarkgrey,
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 40),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  await getimg
                                                      .pickGalleryImage();
                                                  Get.back();
                                                },
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      'assets/gallery.png',
                                                      height: 50,
                                                    ),
                                                    kheight10,
                                                    textStyle('Gallery', 12)
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await getimg
                                                      .pickCameraImage();
                                                  Get.back();
                                                },
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      'assets/camera.png',
                                                      height: 50,
                                                    ),
                                                    kheight10,
                                                    textStyle('Camera', 12)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: iconStyle(Icons.edit)),
                        ),
                      )
                    ],
                  ),
                ),
                kheight30,
                TextFieldWidget(
                    controller: namectr, hint: 'Name', wordlenth: 20),
                kheight10,
                TextFieldWidget(
                    controller: bioctr,
                    hint: 'Bio',
                    wordlenth: 55,
                    linenumber: 3),
                kheight10,
                DropdownButtonFormField(
                  value: gender == '' ? null : gender,
                  focusColor: kwhite,
                  elevation: 1,
                  dropdownColor: kdarkgrey,
                  hint: textStyle('Gender', 16),
                  decoration: InputDecoration(
                      fillColor: kdarkgrey,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  items: genderlist
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: textStyle(e, 12),
                          ))
                      .toList(),
                  onChanged: (value) {
                    gender = value.toString();
                  },
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
                        onPressed: () async {
                          String uniquno =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference referenceDirImage =
                              referenceRoot.child('userdata');
                          Reference referenceImageToUpload =
                              referenceDirImage.child(uniquno);
                          try {
                            UploadTask uploadTask = referenceImageToUpload
                                .putFile(File(getimg.image.value));
                            TaskSnapshot snapshot = await uploadTask;
                            image = await snapshot.ref.getDownloadURL();
                            //  image = await referenceImageToUpload.getDownloadURL();
                          } catch (e) {}
                          getctr.updateuserdetails(
                            namectr.text,
                            bioctr.text,
                            gender,
                            image,
                          );
                          Get.back();
                        },
                        child: Center(child: textStyle('Update', 14)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
