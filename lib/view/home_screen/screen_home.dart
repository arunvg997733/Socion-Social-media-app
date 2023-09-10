import 'package:cloud_firestore/cloud_firestore.dart';
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
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collectionGroup('singleuserpost')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Column(
                        children: List.generate(
                          snapshot.data!.docs.length,
                          (index) {
                            final postdata = snapshot.data!.docs[index];
                            String time =
                                getpost.formatTimeAgo(postdata['time'].toDate());
                                
                            return Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (postdata['userid'] ==
                                              getOther.auth.currentUser?.uid) {
                                            getnav.onSelected(4);
                                          } else {
                                            Get.to(OtherProfileScreen(
                                              userId: postdata['userid'],
                                            ));
                                          }
                                        },
                                        child: UserDetails(
                                          stream: getpost.userdata
                                              .doc(postdata['userid'])
                                              .snapshots(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: postdata['location'] == ''
                                            ? null
                                            : Row(
                                                children: [
                                                  iconStyle(
                                                      Icons.location_on, 12),
                                                  kwidth5,
                                                  textStyle(
                                                      postdata['location'], 10),
                                                ],
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(() => ViewImageScreen(
                                                  image: postdata['image'],
                                                ));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 300,
                                            decoration: BoxDecoration(
                                              color: kdarkgrey,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      postdata['image']),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: [
                                            textStyle(postdata['discription'], 15),
                                          ],
                                        ),
                                      ),
                                      divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: [
                                            textStyle(
                                              time,
                                              12,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          kwidth10,
                                          InkWell(
                                            onTap: () {
                                              Get.to(() => LikeScreen(
                                                    postId: postdata.id,
                                                  ));
                                            },
                                            child: StreamBuilder(
                                                stream: getpost
                                                    .likeandcommentdata
                                                    .doc(postdata.id)
                                                    .collection('like')
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return textStyle(
                                                        'Like ', 12);
                                                  }
                                                  return textStyle(
                                                      'Like  ${snapshot.data!.docs.length}',
                                                      12);
                                                }),
                                          ),
                                          kwidth30,
                                          StreamBuilder(
                                              stream: getpost.likeandcommentdata
                                                  .doc(postdata.id)
                                                  .collection('comment')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return textStyle(
                                                      'Comment ', 12);
                                                }
                                                return textStyle(
                                                    'Comment  ${snapshot.data!.docs.length}',
                                                    12);
                                              }),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () {},
                                            icon: iconStyle(
                                                Icons.star_outline_rounded),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            FutureBuilder<bool>(
                                                future:
                                                    getpost.checklike(postdata.id),
                                                builder: (context, snapshot) {
                                                  return InkWell(
                                                    onTap: () {
                                                      if (snapshot.data ==
                                                          false) {
                                                        setState(() {
                                                          getpost.like(
                                                              postdata.id,
                                                              postdata['image'],
                                                              postdata['userid']);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          getpost
                                                              .dislike(postdata.id);
                                                        });
                                                      }
                                                    },
                                                    child: Row(
                                                      children: [
                                                        snapshot.data == true
                                                            ? iconStyle(
                                                                Icons.favorite)
                                                            : iconStyle(Icons
                                                                .favorite_border),
                                                        kwidth10,
                                                        textStyle('Like', 15)
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            InkWell(
                                              onTap: () {
                                                showComment(
                                                    context,
                                                    postdata.id,
                                                    postdata['image'],
                                                    postdata['userid']);
                                              },
                                              child: Row(
                                                children: [
                                                  iconStyle(Icons
                                                      .mode_comment_outlined),
                                                  kwidth10,
                                                  textStyle('Comment', 15)
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Sharedialog(context,postdata['image']);
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
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                kheight30
                              ],
                            );
                          },
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
