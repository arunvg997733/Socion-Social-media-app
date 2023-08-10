import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/controller/userprofilecontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/widget/widget.dart';
import 'package:photo_view/photo_view.dart';

class ProfileImageViewScreen extends StatelessWidget {
  ProfileImageViewScreen({super.key,this.userId});
  String? userId;
  final getOther = Get.put(UserProfileController());
  final getpost = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: getpost.postData.doc(userId).collection('singleuserpost').snapshots(),
          builder: (context, snapshot) {
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: getOther.postlist.length,
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
                            stream: getOther.userdata
                                .doc(userId)
                                .snapshots()),
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: kdarkgrey,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              getpost.deletePost(data.id);
                                              getpost.postcount();
                                            },
                                            child:
                                                textStyle('Delete post', 20))
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: iconStyle(Icons.more_vert))
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              iconStyle(Icons.favorite_border),
                              kwidth10,
                              textStyle('Like', 15)
                            ],
                          ),
                          Row(
                            children: [
                              iconStyle(Icons.mode_comment_outlined),
                              kwidth10,
                              textStyle('Comment', 15)
                            ],
                          ),
                          Row(
                            children: [
                              iconStyle(Icons.share),
                              kwidth10,
                              textStyle('Share', 15),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
        ),
      ),
    );
  }
}