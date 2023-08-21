import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserStoryController extends GetxController {
  CollectionReference userdata =
      FirebaseFirestore.instance.collection('userdata');
  CollectionReference storyData =
      FirebaseFirestore.instance.collection('storydata');
  CollectionReference followData =
      FirebaseFirestore.instance.collection('followdata');
  final auth = FirebaseAuth.instance;

  RxString userStoryImage = ''.obs;
  RxList storyList = [].obs;

  getimage(String userid) async {
    final data = await userdata.doc(auth.currentUser?.uid).get();
    userStoryImage.value = data['image'];
  }

  addStory(
    String image,
  ) async {
    DateTime time = DateTime.now();

    final sdata = storyData.doc(auth.currentUser?.uid);
    final data = {
      'userid': auth.currentUser?.uid,
      'image': image,
      'time': time
    };
    sdata.set(data);
  }

  getStoryList() async {
    storyList.value.clear();
    final followingdata = await followData
        .doc(auth.currentUser?.uid)
        .collection('following')
        .get();
    for (var element in followingdata.docs) {
      final story = await storyData.doc(element['userid']).get();
      if (story.exists) {
        final user = await userdata.doc(element['userid']).get();
        storyList.value.add(user);
      }
    }
    update();
  }

  autodeletStory() async {
    final sdata = await storyData.get();
    for (var element in sdata.docs) {
      Timestamp time = element['time'];
      int now = DateTime.now().millisecondsSinceEpoch;
      final duration = now - time.millisecondsSinceEpoch;
      // 86400000
      if (duration > 86400000) {
        storyData.doc(element['userid']).delete();
      }
    }
  }

  Future<bool> currentStoryStatus() async {
    final data = await storyData.doc(auth.currentUser?.uid).get();
    if (data.exists) {
      return true;
    }
    return false;
  }
}
