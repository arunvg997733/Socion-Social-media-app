import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/controller/profile_pic_contoller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/main_screen/screen_main.dart';
import 'package:socion/view/widget/widget.dart';

class PostScreen extends StatelessWidget {
  PostScreen({super.key});
  final getpost = Get.put(PostController());
  final getimg = Get.put(ProfilePickController());

  final TextEditingController discriptionctr = TextEditingController();
  final TextEditingController locationctr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    getimg.image.value = '';
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kblack,
          title: textStyle('New Post', 20),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: kdarkgrey,
                              actions: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 40),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await getimg.pickGalleryImage();
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
                                          await getimg.pickCameraImage();
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
                      child: Obx(
                        () => Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kdarkgrey,
                            ),
                            child: getimg.image == ''
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      iconStyle(
                                          Icons.add_circle_outline_outlined,
                                          80),
                                      kheight10,
                                      textStyle('Add Photos', 20)
                                    ],
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(
                                              File(getimg.image.value))),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )),
                      )),
                  kheight30,
                  TextFieldWidget(
                      controller: discriptionctr,
                      hint: 'Write something',
                      linenumber: 4),
                  kheight30,
                  TextFieldWidget(controller: locationctr, hint: 'Loctaion'),
                  kheight30,
                  Container(
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(colors: [
                          Color(0xffF65F53),
                          Color(0xffDE3377),
                        ])),
                    child: TextButton(
                      onPressed: () async {
                        if (getimg.image.value == '') {
                          showSnacksBar('Alert', 'Please choose image');
                        } else {
                          try {
                            DateTime time = DateTime.now();
                            String image =
                                await getimg.uploadimage(getimg.image.value);
                            final userdata = await getpost.userdata
                                .doc(getpost.auth.currentUser?.uid)
                                .get();
                            getpost.addPostToUser(
                                userdata['name'],
                                getpost.auth.currentUser!.uid,
                                discriptionctr.text,
                                image,
                                locationctr.text,
                                time);
                            showSnacksBar("Success", 'Post Added');
                            Get.offAll(() => MainScreen());
                          } catch (e) {
                            showSnacksBar('Error', e.toString());
                          }
                        }
                      },
                      child: Center(child: textStyle('Post', 14)),
                    ),
                  ),
                  kheight30
                ],
              ),
            ),
          ),
        ));
  }
}
