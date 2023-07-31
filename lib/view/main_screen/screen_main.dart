import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/navbar_controller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/add_post_screen/screen_add.dart';
import 'package:socion/view/home_screen/screen_home.dart';
import 'package:socion/view/notification_screen/screen_notifiaction.dart';
import 'package:socion/view/profile_screen/screen_profile.dart';
import 'package:socion/view/search_screen/screen_search.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final getctr = Get.put(
    NavBarController(),
  );

  @override
  Widget build(BuildContext context) {
    List pages = [
      const HomeScreen(),
      SearchScreen(),
      const AddScreen(),
      const NotificationScreen(),
      ProfileScreen()
    ];
    return Scaffold(
      body: Obx(() => pages[getctr.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
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
    );
  }
}
