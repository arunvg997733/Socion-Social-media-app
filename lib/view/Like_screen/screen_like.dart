import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/widget/widget.dart';

class LikeScreen extends StatelessWidget {
  LikeScreen({super.key, required this.postId});
  final getpost = Get.put(PostController());
  final String postId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textStyle('Likes', 20),
        backgroundColor: kblack,
      ),
      body: StreamBuilder(
          stream: getpost.likeandcommentdata
              .doc(postId)
              .collection('like')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: snapshot.data!.docs.length == 0 ? Center(child: textStyle('No Likes', 15)): ListView.separated(
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index];
                    return UserDetails(
                      stream: getpost.userdata.doc(data['userid']).snapshots(),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return divider();
                  },
                  itemCount: snapshot.data!.size)
            );
          }),
    );
  }
}
