import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/navbar_controller.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/controller/story_controller.dart';
import 'package:socion/controller/userprofilecontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/Like_screen/screen_like.dart';
import 'package:socion/view/add_story_screen/screen_add_story.dart';
import 'package:socion/view/others_profile_screen/screen_others_profile.dart';
import 'package:socion/view/story_view_screen/screen_story_view.dart';
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
                      onPressed: () {},
                      icon: iconStyle(Icons.messenger_outline),
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  //Stories//
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
                ),
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
                            final data = snapshot.data!.docs[index];
                            // getpost.getLikecount(data.id,index);

                            String time =
                                getpost.formatTimeAgo(data['time'].toDate());
                            return Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (data['userid'] ==
                                              getOther.auth.currentUser?.uid) {
                                            getnav.onSelected(4);
                                          } else {
                                            Get.to(OtherProfileScreen(
                                              userId: data['userid'],
                                            ));
                                            print('arun start');
                                            print(data['userid']);
                                          }
                                        },
                                        child: UserDetails(
                                          stream: getpost.userdata
                                              .doc(data['userid'])
                                              .snapshots(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: data['location'] == ''
                                            ? null
                                            : Row(
                                                children: [
                                                  iconStyle(
                                                      Icons.location_on, 12),
                                                  kwidth5,
                                                  textStyle(
                                                      data['location'], 10),
                                                ],
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(() => ViewImageScreen(
                                                  image: data['image'],
                                                ));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 300,
                                            decoration: BoxDecoration(
                                              color: kdarkgrey,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      data['image']),
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
                                            textStyle(data['discription'], 15),
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
                                                    postId: data.id,
                                                  ));
                                            },
                                            // child: Obx(() => textStyle('Likes ${getpost.countlist[index]}', 12))
                                            child: StreamBuilder(
                                                stream: getpost
                                                    .likeandcommentdata
                                                    .doc(data.id)
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
                                                  .doc(data.id)
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
                                                    getpost.checklike(data.id),
                                                builder: (context, snapshot) {
                                                  return InkWell(
                                                    onTap: () {
                                                      if (snapshot.data ==
                                                          false) {
                                                        setState(() {
                                                          getpost.like(data.id,data['image'],data['userid']);
                                                          // getpost.getLikecount(data.id);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          getpost
                                                              .dislike(data.id);
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
                                                showComment(context, data.id,data['image'],data['userid']);
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
                                            Row(
                                              children: [
                                                iconStyle(Icons.share),
                                                kwidth10,
                                                textStyle('Share', 15),
                                              ],
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
                kheight30,
                kheight30
              ],
            ),
          ),
        ),
      ),
    );
  }
}
