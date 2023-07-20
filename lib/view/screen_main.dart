import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/navbar_controller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/screen_add.dart';
import 'package:socion/view/screen_home.dart';
import 'package:socion/view/screen_notifiaction.dart';
import 'package:socion/view/screen_profile.dart';
import 'package:socion/view/screen_search.dart';


class MainScreen extends StatelessWidget {
   MainScreen({super.key});

   final getctr = Get.put(NavBarController());

   final int currentindex=0;

  @override
  Widget build(BuildContext context) {

    List pages = [
      const HomeScreen(),
      const SearchScreen(),
      const AddScreen(),
      const NotificationScreen(),
      ProfileScreen()
    ];
    return  Scaffold(
      body: Obx(() => pages[getctr.currentIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
          unselectedItemColor: kwhite,
          selectedItemColor: kblue,
          iconSize: 30,
          backgroundColor: kdarkgrey,
          type:BottomNavigationBarType.fixed,
          onTap: (value) {
            getctr.onSelected(value);
            print(value);
          },
          currentIndex: getctr.currentIndex.value,
          items:  const [
          BottomNavigationBarItem(
            label: '',
            icon:Icon(Icons.home_outlined)),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.search)),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.add)),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.notifications_none)),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.person_outlined))  
        ]),)
    );
  }
}