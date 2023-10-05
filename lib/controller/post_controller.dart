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
  RxBool isLoadinghome = false.obs;
  RxBool isLoadingprofile = false.obs;


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
  // Post count getting //
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
      getnoti.addnotification(userid,postimage,'liked your post',postid,'',);
    } catch (e) {
      showSnacksBar('Error', e.toString());
    }
  }


  dislike(String postid) {
    try {
      final lcdata = likeandcommentdata
          .doc(postid)
          .collection('like')
          .doc(auth.currentUser?.uid);
      lcdata.delete();
    } catch (e) {
      showSnacksBar('Error', e.toString());
    }
  }

  // Future<bool> checklike(String postid) async {
  //   try {
  //     final data = await likeandcommentdata
  //         .doc(postid)
  //         .collection('like')
  //         .doc(auth.currentUser?.uid)
  //         .get();
  //     if (data['userid'] == auth.currentUser?.uid) {
  //       return true;
  //     }
  //   } catch (e) {
  //     print("like error = ${e.toString()}");
  //   }
  //   return false;
  // }

  comment(String text, String postId,String userId,String postimage) {
    final time = DateTime.now();
    final data = likeandcommentdata.doc(postId).collection('comment');
    final newcomment = {'userid': auth.currentUser?.uid, 'comment': text,'time':time};
    data.add(newcomment);
    getnoti.addnotification(userId, postimage,'commented on your post',postId,text);
  }

  // getlength() async {
  //   final data = await likeandcommentdata.get();
  //   data.docs.length;
  // }


  // new post created functions//

  RxList postList = [].obs;
  RxList singlePostList = [].obs;


  

  getAllPostData()async{
    postList.value.clear();
    final data =await FirebaseFirestore.instance.collectionGroup('singleuserpost').get();
    for(var element in data.docs){
      final singleUserData =await userdata.doc(element['userid']).get();
      final postlike = await likeandcommentdata.doc(element.id).collection('like').get();
      final postcomment = await likeandcommentdata.doc(element.id).collection('comment').get();
      bool status = await getLikeStatus(element.id);
      int postLikeCount = postlike.docs.length;
      int commentcount = postcomment.docs.length;
      String time = timeago.format(element['time'].toDate());
      final postData = {
        'username':singleUserData['name'],
        'userimage':singleUserData['image'],
        'userid':element['userid'],
        'postimage':element['image'],
        'postid':element.id,
        'time':time,
        'discription':element['discription'],
        'location':element['location'],
        'like':postLikeCount,
        'comment': commentcount,
        'likestatus':status
      };
      postList.value.add(postData);
    }
    update();
    isLoadinghome.value = true;
  }

  Future<bool> getLikeStatus(String postid)async{
    final data = await likeandcommentdata
          .doc(postid)
          .collection('like')
          .doc(auth.currentUser?.uid)
          .get();
          if(data.exists){
            return true;
          }
          return false;
    
  }

  getSinglePostData(String userId)async{
    singlePostList.value.clear();
    final data =await postData.doc(userId).collection('singleuserpost').get();
    for(var element in data.docs){
      final singleUserData =await userdata.doc(element['userid']).get();
      final postlike = await likeandcommentdata.doc(element.id).collection('like').get();
      final postcomment = await likeandcommentdata.doc(element.id).collection('comment').get();
      bool status = await getLikeStatus(element.id);
      int postLikeCount = postlike.docs.length;
      int commentcount = postcomment.docs.length;
      String time = timeago.format(element['time'].toDate());
      final postData = {
        'username':singleUserData['name'],
        'userimage':singleUserData['image'],
        'userid':element['userid'],
        'postimage':element['image'],
        'postid':element.id,
        'time':time,
        'discription':element['discription'],
        'location':element['location'],
        'like':postLikeCount,
        'comment': commentcount,
        'likestatus':status
      };
      singlePostList.value.add(postData);
    }
    isLoadingprofile.value = true;
    update();
    
  }

}


