import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:socion/controller/notificationcontroller.dart';
import 'package:socion/model/post_model.dart';
import 'package:socion/view/main_screen/screen_main.dart';
import 'package:socion/view/widget/widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostController extends GetxController {
  final getnoti = Get.put(NotificationController());
  RxInt userpostcount = 0.obs;
  RxBool userlike = false.obs;
  RxInt likeCount = 0.obs;
  // RxList countlist = [].obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference userdata =
      FirebaseFirestore.instance.collection('userdata');
  CollectionReference likeandcommentdata =
      FirebaseFirestore.instance.collection('likeandcommant');
  CollectionReference postData =
      FirebaseFirestore.instance.collection('postdata');

  // adding post in user profile//

  addPost(String user, String userid, String discription, String image,
      String location, DateTime time) async {
    final postpath =
        postData.doc(auth.currentUser?.uid).collection('singleuserpost');
    final newpost = PostModel(
            user: user,
            userid: userid,
            discription: discription,
            image: image,
            location: location,
            time: time)
        .toMap();
    postpath.add(newpost);
  }

  deletePost(String postid) {
    postData
        .doc(auth.currentUser?.uid)
        .collection('singleuserpost')
        .doc(postid)
        .delete();
    Get.back();
    Get.back();
  }

  editPost(String postid, String discription, String location) async {
    DateTime time = DateTime.now();
    final data = {
      'discription': discription,
      'location': location,
      'time': time
    };
    try {
      postData
          .doc(auth.currentUser?.uid)
          .collection('singleuserpost')
          .doc(postid)
          .update(data);
      showSnacksBar('Success', 'Post Updated');
    } catch (e) {
      showSnacksBar('Error', e.toString());
    }
    Get.offAll(MainScreen());
  }

  String formatTimeAgo(DateTime timestamp) {
    return timeago.format(timestamp, locale: 'en_long');
  }

  postcount() async {
    final data = await postData
        .doc(auth.currentUser?.uid)
        .collection('singleuserpost')
        .get();
    List<PostModel> newlist = [];
    for (var element in data.docs.toList()) {
      if (element['userid'] == auth.currentUser?.uid) {
        final data = PostModel.fromMap(element);
        newlist.add(data);
      }
    }

    userpostcount.value = newlist.length;
  }

  like(String postid,String postimage,String userid) {
    try {
      final lcdata = likeandcommentdata
          .doc(postid)
          .collection('like')
          .doc(auth.currentUser?.uid);
      final data = {'userid': auth.currentUser?.uid};
      lcdata.set(data);
      getnoti.addnotification(userid,postimage,'liked your post');
    } catch (e) {
      showSnacksBar('Error', e.toString());
    }
  }

  // getLikecount(String postid,int index) async {
  //   final postdata = await alluserpostdata.doc(postid).collection('like').get();
  //   // int count = 0;
  //   // ignore: unused_local_variable
  //   countlist.add(postdata.docs.length);
  //   // countlist[index] = postdata.docs.length;

  //   // for (var element in postdata.docs.toList()) {
  //   //   count++;
  //   // }
  //   // likeCount.value = count;
  // }

  dislike(String postid) {
    try {
      final lcdata = likeandcommentdata
          .doc(postid)
          .collection('like')
          .doc(auth.currentUser?.uid);
      // final postdata = postData.doc(postid).collection('like');

      lcdata.delete();
    } catch (e) {
      showSnacksBar('Error', e.toString());
    }
  }

  Future<bool> checklike(String postid) async {
    try {
      final data = await likeandcommentdata
          .doc(postid)
          .collection('like')
          .doc(auth.currentUser?.uid)
          .get();
      if (data['userid'] == auth.currentUser?.uid) {
        return true;
      }
    } catch (e) {
      print("like error = ${e.toString()}");
    }
    return false;
  }

  comment(String text, String postId,String userId,String postimage) {
    final data = likeandcommentdata.doc(postId).collection('comment');
    final newcomment = {'userid': auth.currentUser?.uid, 'comment': text};
    data.add(newcomment);
    getnoti.addnotification(userId, postimage,'commented on your post');
  }

  getlength() async {
    final data = await likeandcommentdata.get();
    data.docs.length;
  }
}
