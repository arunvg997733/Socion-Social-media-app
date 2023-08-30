import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class pushNotificationController extends GetxController {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static String serverKey =
      'AAAAATghnQ8:APA91bGZHFrS7kL9ls0YPlW8DcUQcB2YUm6l9ku6tglVh_RI2GVuf6xRvxKotipsZ4SVlc1yrnDL_EvC0kp6oosJPYMEgrkRV3Glvd_hKI2Uno55ZHmaAlLxFbE37Re7egAGqcdfZ7yj';
  static FlutterLocalNotificationsPlugin flutterLocalNotification =
      FlutterLocalNotificationsPlugin();

  static initialize() {
    InitializationSettings initializationSettings =
        const InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    flutterLocalNotification.initialize(initializationSettings);
  }

  static display(RemoteMessage message) async {
    try {
      Random random = Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("mychannel", "my channel",
              importance: Importance.max, priority: Priority.high));
      await flutterLocalNotification.show(id, message.notification!.title,
          message.notification!.body, notificationDetails);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static sendNotification(String title, String message, String token) async {
    final data = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      'message': message
    };

    try {
      http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey'
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': message,
                'title': title
              },
              'priority': 'high',
              'data': data,
              "to": token
            },
          ));
    } catch (e) {
      print('error $e');
    }
  }

  static storeToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      final data = FirebaseFirestore.instance
          .collection('userdata')
          .doc(auth.currentUser?.uid);
      final tokenid = {'token': token};
      data.update(tokenid);
    } catch (e) {
      print(e);
    }
  }
}
