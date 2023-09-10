import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/controller/profile_pic_contoller.dart';
import 'package:socion/controller/userprofilecontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/home_screen/widget.dart';

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
      overflow: TextOverflow.ellipsis,
      color: kwhite,
      fontSize: size,
    ),
  );
}

Widget MessagetextStyle(String text, double size) {
  return Text(
    text,
    maxLines: 100,
    style: TextStyle(
      color: kwhite,
      fontSize: size,
    ),
  );
}

Widget NotificationtextStyle(
    {required String text, required double size, int? maxline}) {
  return Text(
    text,
    style: TextStyle(
      overflow: TextOverflow.ellipsis,
      color: kwhite,
      fontSize: size,
    ),
    maxLines: maxline,
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

showComment(
    BuildContext context, String postid, String postimage, String userId) {
  final getpost = Get.put(PostController());
  return showModalBottomSheet(
    shape: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight:Radius.circular(15))),
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: kdarkgrey,
    context: context,
    builder: (context) {
      TextEditingController commentctr = TextEditingController();
      return StreamBuilder(
          stream: getpost.likeandcommentdata
              .doc(postid)
              .collection('comment')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    textStyle('Comments', 20),
                    kheight10,
                    Expanded(
                        child: snapshot.data!.docs.isEmpty
                            ? Center(child: textStyle('No comments', 15))
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  final commentdata =
                                      snapshot.data!.docs[index];
                                  final time = getpost.formatTimeAgo(
                                      commentdata['time'].toDate());
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          UserDetails(
                                            stream: getpost.userdata
                                                .doc(commentdata["userid"])
                                                .snapshots(),
                                          ),
                                          kwidth10,
                                          Expanded(
                                              child: textStyle(
                                                  commentdata['comment'],
                                                  15)),
                                        ],
                                      ),
                                      textStyle(time, 10)
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return divider();
                                },
                                itemCount: snapshot.data!.docs.length)),
                    kheight10,
                    Container(
                      decoration: BoxDecoration(
                          color: kblack,
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextField(
                              style: TextStyle(color: kwhite),
                              controller: commentctr,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Comments...',
                                  hintStyle: TextStyle(color: kwhite)),
                            )),
                            TextButton(
                              onPressed: () {
                                if (commentctr.text.isNotEmpty) {
                                  getpost.comment(commentctr.text, postid,
                                      userId, postimage);
                                  Get.back();
                                }
                                commentctr.clear();
                              },
                              child: textStyle('Post', 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    },
  );
}

// ignore: must_be_immutable
class ImagePicker extends StatelessWidget {
  ImagePicker({super.key, required this.heigth});

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
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        iconStyle(Icons.add_circle_outline_outlined, 80),
                        kheight10,
                        textStyle('Add Photos', 20)
                      ],
                    )
                  : Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(getImg.image.value))),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
        ));
  }
}

Sharedialog(BuildContext context,String image) {
  final getfollow = Get.put(UserProfileController());
  getfollow.getfollowerList(getfollow.auth.currentUser!.uid);
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Container(
          decoration: const BoxDecoration(
              color: kdarkgrey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Column(
            children: [
              kheight30,
              textStyle('Share', 20),
              kheight10,
              GetBuilder<UserProfileController>(
                builder: (controller) {
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final data = controller.followinglist.value[index];
                        return ShareTile(
                          data: data,postimg: image,
                        );
                      },
                      itemCount: getfollow.followinglist.length,
                    ),
                  );
                },
              ),
            ],
          ));
    },
  );
}
