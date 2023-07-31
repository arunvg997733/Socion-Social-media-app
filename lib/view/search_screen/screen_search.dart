import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/authcontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/widget/widget.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  String? name;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  getCurrentUserInfo() async {
    User currentUser = auth.currentUser!;
    String id = currentUser.uid;
    if (currentUser != null) {
      final data =
          await FirebaseFirestore.instance.collection('userdata').get();

      final user = await data.docs.map((e) {
        // print(e.data());
        if (e.data()['email'] == auth.currentUser?.email) {
          widget.name = e.data()['name'];
        }
        // for (int i = 0; i < 3; i++) {if(auth.currentUser.email)}
      }).toList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final auth = FirebaseAuth.instance;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('userdata');

  @override
  Widget build(BuildContext context) {
    getCurrentUserInfo();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              kheight10,
              CupertinoSearchTextField(
                backgroundColor: kdarkgrey,
                itemColor: kwhite,
                style: TextStyle(color: kwhite),
              ),
              textStyle(widget.name.toString(), 15),
              ElevatedButton(
                  onPressed: () async {
                    // final userdata = await FirebaseFirestore.instance
                    //     .collection('userdata')
                    //     .doc(auth.currentUser?.uid)
                    //     .get();
                    // print(userdata['name']);
                    Get.put(AuthController()).signOut();
                  },
                  child: Text('data'))
            ],
          ),
        ),
      ),
    );
  }
}
