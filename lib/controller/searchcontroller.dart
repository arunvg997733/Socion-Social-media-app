import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:socion/model/user_model.dart';

class UserSearchController extends GetxController {
  CollectionReference userdata =
      FirebaseFirestore.instance.collection('userdata');

  RxList allList = <UserModel>[].obs;
  RxList seachList = <UserModel>[].obs;

  getSearchist() async {
    allList.value.clear();
    final searchdata = await userdata.get();
    for (var element in searchdata.docs) {
      allList.add(UserModel.fromMap(element));
    }
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
