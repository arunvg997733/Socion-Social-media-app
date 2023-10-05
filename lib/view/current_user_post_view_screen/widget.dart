import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/post_controller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/post_edit_screen/screen%20_post_edit.dart';
import 'package:socion/view/widget/widget.dart';

class ProfilePopupMenu extends StatelessWidget {
  const ProfilePopupMenu({
    super.key,
    required this.getpost,
    required this.data,
  });

  final PostController getpost;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: iconStyle(Icons.more_vert_outlined),
      color: kdarkgrey,
      onSelected: (value) {
        if (value == 'delete') {
          getpost.deletePost(data['postid']);
          getpost.postcount();
        } else if (value == 'edit') {
          Get.to(PostEditScreen(
            image: data['postimage'],
            discription: data['discription'],
            location: data['location'],
            postId: data['postid'],
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

class SingleUserLikeCommentShareWidget extends StatelessWidget {
   SingleUserLikeCommentShareWidget({
    super.key,
    required this.rxlike,
    required this.postData,
  });

  final RxBool rxlike;
  final Map<String, dynamic> postData;
  final getpost = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
      children: [
        InkWell(
          onTap: ()async{
            if(rxlike == false){
              getpost.like(postData['postid'], postData['postimage'], postData['userid']);
              rxlike.value = true;
              getpost.getSinglePostData(postData['userid']);
            }else{
              rxlike.value = false;
              getpost.dislike(postData['postid']);
              getpost.getSinglePostData(postData['userid']);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => iconStyle(rxlike==true?Icons.favorite:Icons.favorite_outline)),
              kwidth10,
              textStyle('Like', 15),
            ],
          ),
        ),
        
        InkWell(
          onTap: () {
            showComment(context, postData['postid'], postData['postimage'], postData['userid']);
            getpost.getAllPostData();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconStyle(Icons.mode_comment_outlined),
              kwidth10,
              textStyle('Comment', 15),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Sharedialog(context, postData['postimage']);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconStyle(Icons.share),
              kwidth10,
              textStyle('Share', 15),
            ],
          ),
        ),
        
      ],
      ),
    );
  }
}

