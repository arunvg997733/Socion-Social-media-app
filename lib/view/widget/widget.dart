import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/controller/profile_pic_contoller.dart';
import 'package:socion/core/constant.dart';

Icon iconStyle(IconData icon, [double? size]) {
  return Icon(
    icon,
    color: kwhite,
    size: size,
  );
}

showSnacksBar(
  String title,
  String message,
) {
  Get.snackbar(title, message, backgroundColor: kwhite);
}

Widget divider() {
  return const Divider(
    color: kwhite,
    thickness: 0.2,
  );
}

Widget textStyle(String text, double size) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: kwhite,
      fontSize: size,
    ),
  );
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {super.key,
      required this.controller,
      required this.hint,
      this.wordlenth,
      this.linenumber});

  final TextEditingController controller;
  final String? hint;
  final int? wordlenth;
  final int? linenumber;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: linenumber,
      style: const TextStyle(color: kwhite),
      controller: controller,
      maxLength: wordlenth,
      decoration: InputDecoration(
          counterStyle: const TextStyle(color: kwhite),
          label: Text(
            hint!,
            style: const TextStyle(color: kwhite),
          ),
          fillColor: kdarkgrey,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}

class HideTextFieldWidget extends StatelessWidget {
  const HideTextFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      style: const TextStyle(color: kwhite),
      controller: controller,
      decoration: InputDecoration(
        label: Text(
          hint!,
          style: const TextStyle(color: kwhite),
        ),
        fillColor: kdarkgrey,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({
    super.key,
    required this.stream,
  });

  final Stream<DocumentSnapshot<Object?>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(snapshot.data!['image']),
                        fit: BoxFit.cover),
                  ),
                ),
                kwidth10,
                textStyle(snapshot.data!['name'], 12)
              ],
            ),
          );
        });
  }
}

PersistentBottomSheetController<dynamic> showComment(
    BuildContext context, String data) {
  final getpost = Get.put(PostController());
  return showBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      TextEditingController commentctr = TextEditingController();
      return StreamBuilder(
          stream: getpost.likeandcommentdata
              .doc(data)
              .collection('comment')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Container(
                color: kdarkgrey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      kheight30,
                      textStyle('Comments', 20),
                      divider(),
                      Expanded(
                          child: snapshot.data!.docs.isEmpty
                              ? Center(child: textStyle('No comments', 15))
                              : ListView.separated(
                                  itemBuilder: (context, index) {
                                    final commentdata =
                                        snapshot.data!.docs[index];
                                    return Row(
                                      children: [
                                        UserDetails(
                                          stream: getpost.userdata
                                              .doc(commentdata["userid"])
                                              .snapshots(),
                                        ),
                                        kwidth10,
                                        textStyle(commentdata['comment'], 15)
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return divider();
                                  },
                                  itemCount: snapshot.data!.docs.length)),
                      kheight10,
                      TextFieldWidget(controller: commentctr, hint: 'Comment'),
                      kheight10,
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
                            getpost.comment(commentctr.text, data);
                            Get.back();
                          },
                          child: Center(child: textStyle('Post', 14)),
                        ),
                      ),
                      kheight10,
                    ],
                  ),
                ),
              ),
            );
          });
    },
  );
}

class ImagePicker extends StatelessWidget {
   ImagePicker({
    super.key,
    required this.heigth
  });

  double heigth;

  final getImg = Get.put(ProfilePickController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                                    await getImg.pickGalleryImage();
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
                                    await getImg.pickCameraImage();
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
                      height: heigth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kdarkgrey,
                      ),
                      child: getImg.image == ''
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
                                        File(getImg.image.value))),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )),
                ));
  }
}

