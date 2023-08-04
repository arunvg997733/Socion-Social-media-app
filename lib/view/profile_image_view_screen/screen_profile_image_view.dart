import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/model/post_model.dart';
import 'package:socion/view/widget/widget.dart';
import 'package:photo_view/photo_view.dart';

class ProfileImageViewScreen extends StatelessWidget {
  ProfileImageViewScreen({super.key});

  final getpost = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: getpost.alluserpostdata.snapshots(),
          builder: (context, snapshot) {
            List<PostModel> newlist = [];

            if (snapshot.hasData) {
              for (var element in snapshot.data!.docs.toList()) {
                if (element['userid'] == getpost.auth.currentUser?.uid) {
                  final data = PostModel.fromMap(element);
                  newlist.add(data);
                }
              }
              return PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: newlist.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  final sdata = snapshot.data!.docs[index];
                  final data = newlist[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UserDetails(
                              stream: getpost.userdata
                                  .doc(data.userid)
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
                                                getpost.deletePost(sdata.id);
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
                              imageProvider: NetworkImage(data.image!))),
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

            if (snapshot.hasError) {
              textStyle(snapshot.error.toString(), 15);
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
