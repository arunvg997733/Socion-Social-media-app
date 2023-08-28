import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:socion/model/user_model.dart';

class UserSearchController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference userdata =
      FirebaseFirestore.instance.collection('userdata');

  RxList allList = <UserModel>[].obs;
  RxList seachList = <UserModel>[].obs;

  getSearchist() async {
    // ignore: invalid_use_of_protected_member
    allList.value.clear();
    final searchdata = await userdata.get();
    for (var element in searchdata.docs) {
      if(element['userid']!= auth.currentUser?.uid){
        allList.value.add(UserModel.fromMap(element));
      }
    }
    // ignore: invalid_use_of_protected_member
    seachList.value = allList.value;
    update();
  }

  search(String text) {
    seachList.value = allList
        .where((element) =>
            element.name!.toLowerCase().contains(text.toLowerCase()))
        .toList();
    update();
  }
}
