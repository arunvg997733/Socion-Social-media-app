import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/messagecontroller.dart';
import 'package:socion/controller/story_controller.dart';
import 'package:socion/controller/userprofilecontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/add_story_screen/screen_add_story.dart';
import 'package:socion/view/story_view_screen/screen_story_view.dart';
import 'package:socion/view/widget/widget.dart';

class StoryWidget extends StatelessWidget {
  const StoryWidget({
    super.key,
    required this.getStory,
  });

  final UserStoryController getStory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              final status = await getStory.currentStoryStatus();
              if (status == true) {
                Get.to(StoryViewScreen(
                    userId: getStory.auth.currentUser!.uid));
              } else {
                Get.to(AddStoryScreen());
              }
            },
            child: Obx(
              () => Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: NetworkImage(
                                  getStory.userStoryImage.value),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: InkWell(
                          onTap: () {
                            Get.to(AddStoryScreen());
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: kmixcolorpink,
                            child: iconStyle(Icons.add),
                          ),
                        ),
                      )
                    ],
                  ),
                  kheight5,
                  textStyle('Your Story', 10)
                ],
              ),
            ),
          ),
          kwidth10,
          Expanded(
            child: GetBuilder<UserStoryController>(
              builder: (controller) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: getStory.storyList.length,
                  separatorBuilder: (context, index) {
                    return kwidth10;
                  },
                  itemBuilder: (context, index) {
                    // ignore: invalid_use_of_protected_member
                    final data = controller.storyList.value[index];
                    const colorlist = Colors.accents;
                    return InkWell(
                      onTap: () {
                        Get.to(StoryViewScreen(
                            userId: data['userid']));
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: colorlist[index],
                                  width: 3),
                              borderRadius:
                                  BorderRadius.circular(15),
                              image: DecorationImage(
                                  image:
                                      NetworkImage(data['image']),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          kheight5,
                          textStyle(data['name'], 10)
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
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

class ShareTile extends StatelessWidget {
  ShareTile({super.key, required this.data,required this.postimg});
  dynamic data;
  String postimg;
  final getmsg = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    print('arun');
    print(data['image']);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data['image']),
        ),
        title: Row(
          children: [
            textStyle(data['name'], 12),
          ],
        ),
        trailing: Container(
          width: 80,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(colors: [
                Color(0xffF65F53),
                Color(0xffDE3377),
              ])),
          child: TextButton(
            onPressed: () async {
              getmsg.sendmessage(data['userid'], '', data['image'], data['name'], data['token'],postimg );
            },
            child: Center(child: textStyle('Send', 12)),
          ),
        ),
      ),
    );
  }
}