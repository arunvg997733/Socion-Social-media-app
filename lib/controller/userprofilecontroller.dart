import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:socion/model/post_model.dart';
import 'package:socion/model/user_model.dart';

class UserProfileController extends GetxController{
  final auth = FirebaseAuth.instance;
  final userdata = FirebaseFirestore.instance.collection('userdata');
  final postdata = FirebaseFirestore.instance.collection('postdata');
  final followdata =FirebaseFirestore.instance.collection('followdata');

  RxInt followercount = 0.obs;
  RxInt followingCount = 0.obs;
  RxBool followStatus = false.obs;
  RxInt postcount = 0.obs;
  var user = UserModel(name: '',image: '',bio: '',email: '',gender: '',id: '').obs;
  // List<PostModel> postlist = [];
  RxList postlist = <PostModel>[].obs;




// for following others //
  follow(String userdata)async{
    final followerdata = followdata.doc(userdata).collection('follower').doc(auth.currentUser?.uid);
    final followingdata = followdata.doc(auth.currentUser?.uid).collection('following').doc(userdata);
    final datafollowing = {
      'userid': userdata
    };
    final datafollower = {
      'userid':auth.currentUser?.uid
    } ;
    followerdata.set(datafollower);
    followingdata.set(datafollowing);
    getFollowerCount(userdata);
    checkFollow(userdata);
    
  }
// for unfollowing other //
  unfollow(String userdata)async{
    final followerdata = followdata.doc(userdata).collection('follower').doc(auth.currentUser?.uid);
    final followingdata = followdata.doc(auth.currentUser?.uid).collection('following').doc(userdata);
    followerdata.delete();
    followingdata.delete();
    getFollowerCount(userdata);
    checkFollow(userdata);
  }

//for getting other users status of following or not //
  checkFollow(String userdata)async{
    final data = await followdata.doc(userdata).collection('follower').doc(auth.currentUser?.uid).get();
    if(data.exists){
      followStatus.value = true;
    }else{
      followStatus.value = false;
    }
  }
// for getting other users count of followers in other userscreen//
  getFollowerCount(String userdata)async{
    final data =await followdata.doc(userdata).collection('follower').get();
    followercount.value = data.docs.length;
  }
// for getting other users count of following in other userscreen//
  getFollowingCount(userdata)async{
    final data = await followdata.doc(userdata).collection('following').get();
    followingCount.value = data.docs.length;
  }
// for getting other userdata like image,name,bio,etc //
  gettingUserdata(String userid)async{
    final data = await userdata.doc(userid).get();
    user.value = UserModel.fromMap(data);
    update();
  }
// for getting other user post data to list //
  getpostdata(String userId)async{
    postlist.clear();
    final data =await postdata.doc(userId).collection('singleuserpost').get();
     for(var element in data.docs.toList()){
      PostModel post = PostModel.fromMap(element);
      postlist.add(post);
    }
  

  }
// for getting other user post data count //
  getPostCount(String userId)async{
    final data = await postdata.doc(userId).collection('singleuserpost').get();
    postcount.value = data.docs.length;
  }

  // current user // 

  getCurrentUserFollower()async{
    final data =await followdata.doc(auth.currentUser?.uid).collection('follower').get();
    followercount.value = data.docs.length;
  }

  getCurrentUserFollowing()async{
    final data =await followdata.doc(auth.currentUser?.uid).collection('following').get();
    followingCount.value = data.docs.length;
  }


}