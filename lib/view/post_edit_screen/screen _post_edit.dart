import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/controller/profile_pic_contoller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/widget/widget.dart';

// ignore: must_be_immutable
class PostEditScreen extends StatelessWidget {
  PostEditScreen(
      {super.key,
      required this.image,
      required this.discription,
      required this.location,
      required this.postId});
  String image;
  String discription;
  String location;
  String postId;

  final getpost = Get.put(PostController());
  final getimg = Get.put(ProfilePickController());

  final TextEditingController discriptionctr = TextEditingController();
  final TextEditingController locationctr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    discriptionctr.text = discription;
    locationctr.text = location;

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
                  Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kdarkgrey,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(image)),
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                        getpost.editPost(
                            postId, discriptionctr.text, locationctr.text);
                      },
                      child: Center(child: textStyle('Update', 14)),
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
