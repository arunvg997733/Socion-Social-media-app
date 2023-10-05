import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/navbar_controller.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/controller/story_controller.dart';
import 'package:socion/controller/userprofilecontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/Like_screen/screen_like.dart';
import 'package:socion/view/home_screen/widget.dart';
import 'package:socion/view/message_screen/screen_message.dart';
import 'package:socion/view/others_profile_screen/screen_others_profile.dart';
import 'package:socion/view/view_image/screen_view-image.dart';
import 'package:socion/view/widget/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final getpost = Get.put(PostController());
  final getOther = Get.put(UserProfileController());
  final getnav = Get.put(NavBarController());
  final getStory = Get.put(UserStoryController());
  @override
  Widget build(BuildContext context) {
    getStory.autodeletStory();
    getStory.getimage(getStory.auth.currentUser!.uid);
    getStory.getStoryList();
    //calling the function at one time after building the widget//
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
      getpost.getAllPostData();
    });
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Get.to(MessageScreen());
                      },
                      icon: iconStyle(Icons.messenger_outline),
                    )
                  ],
                ),
                //Story//
                StoryWidget(getStory: getStory),
                //post//
                Obx(() => getpost.isLoadinghome ==false ? SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator())) : PostListWidget())
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class PostListWidget extends StatelessWidget {
   PostListWidget({super.key});

  final getpost = Get.put(PostController()); 

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostController>(builder: (controller) {
      return Column(
      children: List.generate(getpost.postList.length, (index){
        final data = getpost.postList[index];
        return PostWidget(postData: data);
      }),
    );
    },);
  }
}

class PostWidget extends StatelessWidget {
   PostWidget({super.key,required this.postData});
   final getpost = Get.put(PostController()); 
   final getnav = Get.put(NavBarController()); 
   Map<String,dynamic> postData;
  @override
  Widget build(BuildContext context) {
    bool like = postData['likestatus'];
    RxBool rxlike = false.obs;
    rxlike.value = like;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (postData['userid'] ==
                  getpost.auth.currentUser?.uid) {
                  getnav.onSelected(4);
                } else {
                  Get.to(OtherProfileScreen(
                  userId: postData['userid'],
                  ));
                }
          },
          child: PostUserWidget(postData: postData)),
        kheight5,
        postData['location']==''?SizedBox():Row(
          children: [
            iconStyle(Icons.location_on,15),
            textStyle(postData['location'], 10),
          ],
        ),
        InkWell(
          onTap: () {
            Get.to(ViewImageScreen(image: postData['postimage']));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:5),
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: kdarkgrey,
                image: DecorationImage(image: NetworkImage(postData['postimage']))
              ),
            ),
          ),
        ),
        textStyle(postData['discription'], 15),
        kheight5,
        textStyle(postData['time'], 12),
        kheight5,
        Row(
          children: [
            InkWell(
              onTap: () {
                Get.to(LikeScreen(postId: postData['postid']));
              },
              child: textStyle('Like ${postData['like']}', 15)),
            kwidth10,
            textStyle('Comment ${postData['comment']}', 15)
          ],
        ),
        divider(),
        LikeCommentShareWidget(rxlike: rxlike , postData: postData),
        divider(),
        kheight5
      ],
    );
  }
}







