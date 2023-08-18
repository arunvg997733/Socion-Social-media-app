import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/profile_pic_contoller.dart';
import 'package:socion/controller/story_controller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/main_screen/screen_main.dart';
import 'package:socion/view/widget/widget.dart';

class AddStoryScreen extends StatelessWidget {
  AddStoryScreen({super.key});

  final getImg = Get.put(ProfilePickController());
  final getStory = Get.put(UserStoryController());

  @override
  Widget build(BuildContext context) {
    getImg.image.value = '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kblack,
        centerTitle: true,
        title: textStyle('Add Story', 20),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ImagePicker(heigth:500),
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
                          if (getImg.image.value == '') {
                          showSnacksBar('Alert', 'Please choose image');
                        } else {
                          try {
                            DateTime time = DateTime.now();
                            String image =
                                await getImg.uploadimage();
                            getStory.addStory(image);
                            showSnacksBar("Success", 'Story Added');
                            Get.offAll(() => MainScreen());
                          } catch (e) {
                            showSnacksBar('Error', e.toString());
                          }
                        }
                          
                        },
                        child: Center(child: textStyle('Add Story', 14)),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

