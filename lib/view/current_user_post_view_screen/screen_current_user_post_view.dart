import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/navbar_controller.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/controller/userprofilecontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/Like_screen/screen_like.dart';
import 'package:socion/view/current_user_post_view_screen/widget.dart';
import 'package:socion/view/home_screen/screen_home.dart';
import 'package:socion/view/home_screen/widget.dart';
import 'package:socion/view/others_profile_screen/screen_others_profile.dart';
import 'package:socion/view/view_image/screen_view-image.dart';
import 'package:socion/view/widget/widget.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class CurrentUserPostViewScreen extends StatelessWidget {
  CurrentUserPostViewScreen({super.key, this.index, this.userId});
  int? index;
  String? userId;
  final getOther = Get.put(UserProfileController());
  final getpost = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getpost.getSinglePostData(userId!);
    });
    return Scaffold(
      body: SafeArea(
        child: Obx(() => getpost.isLoadingprofile.value? SingleChildScrollView(
          controller: PageController(initialPage: index!),
          child:SinglePostListWidget(userId: userId!,)
          ):Center(child: CircularProgressIndicator()))
      ),
    );
  }
}

class SinglePostListWidget extends StatelessWidget {
   SinglePostListWidget({super.key,required this.userId});
   String userId;
  final getpost = Get.put(PostController()); 

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
        children: List.generate(
          getpost.singlePostList.length, (index){
          final data = getpost.singlePostList[index];
          return SinglePostWidget(postData: data);
        }),
          ),
      );
    },);
  }
}

class SinglePostWidget extends StatelessWidget {
   SinglePostWidget({super.key,required this.postData});
   final getpost = Get.put(PostController()); 
   final getnav = Get.put(NavBarController()); 
   Map<String,dynamic> postData;
  @override
  Widget build(BuildContext context) {
    bool like = postData['likestatus'];
    RxBool rxlike = false.obs;
    rxlike.value = like;
    print(postData['postid']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              getpost.auth.currentUser!.uid != postData['userid']? SizedBox():ProfilePopupMenu(getpost: getpost, data: postData),
          ],
        ),
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
              height: 450,
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
        SingleUserLikeCommentShareWidget(rxlike: rxlike , postData: postData),
        divider(),
        kheight5
      ],
    );
  }
}




