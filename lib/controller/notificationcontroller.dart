import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationController extends GetxController {
  RxList notificationlist = <Map<String, dynamic>>[].obs;

  CollectionReference userdata =
      FirebaseFirestore.instance.collection('userdata');
  CollectionReference storyData =
      FirebaseFirestore.instance.collection('storydata');
  CollectionReference followData =
      FirebaseFirestore.instance.collection('followdata');
  CollectionReference notificationData =
      FirebaseFirestore.instance.collection('notificationdata');
  FirebaseAuth auth = FirebaseAuth.instance;

  updateNotification() async {
    final data = await notificationData
        .doc(auth.currentUser?.uid)
        .collection('usernotification')
        .get();
    // ignore: invalid_use_of_protected_member
    notificationlist.value.clear();
    for (var element in data.docs) {
      final userdetail = await userdata.doc(element['userid']).get();
      final time = formatTimeAgo(element['time'].toDate());
      final newdata = {
        'user': userdetail['name'],
        'image': userdetail['image'],
        'matter': element['matter'],
        'time': time,
        'postimage': element['post'],
        'userid': userdetail['userid'],
        'postid': element['postid'],
        'comment': element['comment']
      };
      // ignore: invalid_use_of_protected_member
      notificationlist.value.add(newdata);
    }
    update();
  }

  String formatTimeAgo(DateTime timestamp) {
    return timeago.format(timestamp, locale: 'en_long');
  }

  addnotification(String userId, String postimage, String matter, String postid,
      String comment) async {
    DateTime time = DateTime.now();
    if (comment != '') {
      comment = ': $comment';
    }
    final data = notificationData
        .doc(userId)
        .collection('usernotification')
        .doc(userId + postid + matter);
    final adddata = {
      'userid': auth.currentUser?.uid,
      'matter': matter,
      'time': time,
      'post': postimage,
      'postid': postid,
      'comment': comment
    };
    data.set(adddata);
  }

  deleteNotification(String id) async {
    String dataId = auth.currentUser!.uid + id;
    final data = notificationData
        .doc(auth.currentUser?.uid)
        .collection('usernotification')
        .doc(dataId);
    data.delete();
    updateNotification();
  }
}
