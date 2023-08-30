import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/navbar_controller.dart';
import 'package:socion/controller/pushnotificationcontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/add_post_screen/screen_post.dart';
import 'package:socion/view/home_screen/screen_home.dart';
import 'package:socion/view/notification_screen/screen_notifiaction.dart';
import 'package:socion/view/profile_screen/screen_profile.dart';
import 'package:socion/view/search_screen/screen_search.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final getctr = Get.put(
    NavBarController(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        pushNotificationController.display(message);
      }
     });
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      const HomeScreen(),
      SearchScreen(),
      PostScreen(),
      NotificationScreen(),
      ProfileScreen()
    ];
    return Scaffold(
      // extendBody: true,
      body: Obx(() => pages[getctr.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
              selectedFontSize: 0,
              unselectedItemColor: kwhite,
              selectedItemColor: kmixcolor,
              iconSize: 30,
              backgroundColor: kdarkgrey,
              type: BottomNavigationBarType.fixed,
              onTap: (value) {
                getctr.onSelected(value);
              },
              currentIndex: getctr.currentIndex.value,
              items: const [
                BottomNavigationBarItem(
                  label: '',
                  icon: Icon(Icons.home_outlined),
                ),
                BottomNavigationBarItem(
                  label: '',
                  icon: Icon(Icons.search),
                ),
                BottomNavigationBarItem(
                  label: '',
                  icon: Icon(Icons.add),
                ),
                BottomNavigationBarItem(
                  label: '',
                  icon: Icon(Icons.notifications_none),
                ),
                BottomNavigationBarItem(
                  label: '',
                  icon: Icon(Icons.person_outlined),
                )
              ]),
        ),
      ),
    );
  }
}
