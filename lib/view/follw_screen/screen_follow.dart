import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/userprofilecontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/others_profile_screen/screen_others_profile.dart';
import 'package:socion/view/widget/widget.dart';

// ignore: must_be_immutable
class FollowScreen extends StatelessWidget {
  FollowScreen({super.key, required this.text, required this.newlist});
  String text;
  RxList newlist;
  final getOther = Get.put(UserProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kblack,
          title: textStyle(text, 20),
        ),
        body: GetBuilder<UserProfileController>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    // ignore: invalid_use_of_protected_member
                    final data = controller.followinglist.value[index];
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(OtherProfileScreen(userId: data['userid']));
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(data['image']),
                                      fit: BoxFit.cover)),
                            ),
                            kwidth30,
                            textStyle(data['name'], 12),
                            // Spacer(),
                            // Container(
                            //     width: 80,
                            //     height: 30,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(10),
                            //         gradient: const LinearGradient(colors: [
                            //           Color(0xffF65F53),
                            //           Color(0xffDE3377),
                            //         ])),
                            //     child: TextButton(
                            //       onPressed: () async {
                      
                            //       },
                            //       child: Center(child: textStyle('following', 12)),
                            //     ),
                            //   ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return divider();
                  },
                  // ignore: invalid_use_of_protected_member
                  itemCount: controller.followinglist.value.length),
            );
          },
        ));
  }
}
