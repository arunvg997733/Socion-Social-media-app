import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/authcontroller.dart';
import 'package:socion/controller/messagecontroller.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/controller/userprofilecontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/chatscreen/screen_chat.dart';
import 'package:socion/view/current_user_post_view_screen/screen_current_user_post_view.dart';
import 'package:socion/view/follw_screen/screen_follow.dart';
import 'package:socion/view/widget/widget.dart';

// ignore: must_be_immutable
class OtherProfileScreen extends StatelessWidget {
  OtherProfileScreen({super.key, required this.userId});
  String userId;
  String? image;
  String? name;
  final getUser = Get.put(AuthController());
  final getpost = Get.put(PostController());
  final getOther = Get.put(UserProfileController());
  final getMsg = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    getOther.gettingUserdata(userId);
    getOther.getpostdata(userId);
    getOther.getFollowerCount(userId);
    getOther.checkFollow(userId);
    getOther.getFollowingCount(userId);
    getOther.getPostCount(userId);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: RefreshIndicator(
            onRefresh: () async {
              getOther.gettingUserdata(userId);
              getOther.getpostdata(userId);
              getOther.getFollowerCount(userId);
              getOther.checkFollow(userId);
              getOther.getFollowingCount(userId);
              getOther.getPostCount(userId);
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                          onPressed: () async {},
                          icon: iconStyle(Icons.more_vert))
                    ],
                  ),
                  kheight30,
                  GetX<UserProfileController>(
                    builder: (controller) {
                      name =controller.user.value.name!;
                      image = controller.user.value.image;
                      return CircleAvatar(
                          radius: 70,
                          backgroundImage: controller.user.value.image == ""
                              ? const AssetImage('assets/user.jpg')
                                  as ImageProvider
                              : NetworkImage(controller.user.value.image!));
                    },
                  ),
                  kheight30,
                  GetX<UserProfileController>(
                    builder: (controller) {
                      return textStyle(controller.user.value.name!, 20);
                    },
                  ),
                  kheight10,
                  SizedBox(
                      width: 150,
                      child: GetX<UserProfileController>(
                        builder: (controller) {
                          return Center(
                              child: textStyle(controller.user.value.bio!, 14));
                        },
                      )),
                  kheight30,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => Container(
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(colors: [
                                Color(0xffF65F53),
                                Color(0xffDE3377),
                              ])),
                          child: TextButton(
                            onPressed: () {
                              if (getOther.followStatus == false) {
                                getOther.follow(userId);
                              } else {
                                getOther.unfollow(userId);
                              }
                            },
                            child: Center(
                                child: getOther.followStatus.value == false
                                    ? textStyle('Follow', 14)
                                    : textStyle('Unfollow', 14)),
                          ),
                        ),
                      ),
                      kwidth10,
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
                            Get.to(ChatScreen(name: name!, image: image!, userId: userId));
                          },
                          child: Center(child: textStyle('Message', 14)),
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
                            Obx(() =>
                                textStyle(getOther.postcount.toString(), 20)),
                            textStyle('Post', 15),
                          ],
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            getOther.getfollowerList(userId);
                            Get.to(FollowScreen(
                                text: 'Followers',
                                newlist: getOther.followinglist));
                          },
                          child: Column(
                            children: [
                              Obx(() => textStyle(
                                  getOther.followercount.toString(), 20)),
                              textStyle('Followers', 15),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            getOther.getfollowingList(userId);
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
                  Obx(() => GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          getOther.postlist.length,
                          (index) {
                            final data = getOther.postlist[index];
                            return InkWell(
                                onTap: () {
                                  Get.to(() => CurrentUserPostViewScreen(
                                        index: index,
                                        userId: userId,
                                      ));
                                },
                                child: data.image != null
                                    ? Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(data.image),
                                              fit: BoxFit.cover),
                                        ),
                                      )
                                    : const CircularProgressIndicator());
                          },
                        ),
                      )),
                  kheight30
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
