import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/controller/userprofilecontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/Like_screen/screen_like.dart';
import 'package:socion/view/post_edit_screen/screen%20_post_edit.dart';
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
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: getpost.postData
                .doc(userId)
                .collection('singleuserpost')
                .orderBy('time')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return PageView.builder(
                scrollDirection: Axis.vertical,
                controller: PageController(initialPage: index!),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  // final data = getOther.postlist[index];
                  final data = snapshot.data!.docs[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UserDetails(
                              stream:
                                  getOther.userdata.doc(userId).snapshots()),
                          ProfilePopupMenu(getpost: getpost, data: data),
                        ],
                      ),
                      SizedBox(
                          height: 400,
                          child: PhotoView(
                              minScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.covered * 2,
                              initialScale: PhotoViewComputedScale.contained,
                              loadingBuilder: (context, event) => const Center(
                                  child: CircularProgressIndicator()),
                              backgroundDecoration:
                                  const BoxDecoration(color: kdarkgrey),
                              gaplessPlayback: true,
                              imageProvider: NetworkImage(data['image']))),
                      kheight30,
                      divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            LikeCommentShareWidget(data: data, userId: userId),
                      ),
                    ],
                  );
                },
              );
            }),
      ),
    );
  }
}

class ProfilePopupMenu extends StatelessWidget {
  const ProfilePopupMenu({
    super.key,
    required this.getpost,
    required this.data,
  });

  final PostController getpost;
  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: iconStyle(Icons.more_vert_outlined),
      color: kdarkgrey,
      onSelected: (value) {
        if (value == 'delete') {
          getpost.deletePost(data.id);
          getpost.postcount();
        } else if (value == 'edit') {
          Get.to(PostEditScreen(
            image: data['image'],
            discription: data['discription'],
            location: data['location'],
            postId: data.id,
          ));
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: textStyle('Delete', 12),
            value: 'delete',
          ),
          PopupMenuItem(
            child: textStyle('Edit', 12),
            value: 'edit',
          )
        ];
      },
    );
  }
}

class LikeCommentShareWidget extends StatelessWidget {
  const LikeCommentShareWidget({
    super.key,
    required this.data,
    required this.userId,
  });

  final QueryDocumentSnapshot<Map<String, dynamic>> data;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Get.to(() => LikeScreen(
                  postId: data.id,
                ));
          },
          child: Row(
            children: [
              iconStyle(Icons.favorite_border),
              kwidth10,
              textStyle('Like', 15)
            ],
          ),
        ),
        InkWell(
          onTap: () {
            showComment(context, data.id, data['image'], userId!);
          },
          child: Row(
            children: [
              iconStyle(Icons.mode_comment_outlined),
              kwidth10,
              textStyle('Comment', 15)
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Sharedialog(context, data['image']);
          },
          child: Row(
            children: [
              iconStyle(Icons.share),
              kwidth10,
              textStyle('Share', 15),
            ],
          ),
        )
      ],
    );
  }
}
