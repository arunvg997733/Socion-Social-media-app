import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/searchcontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/others_profile_screen/screen_others_profile.dart';
import 'package:socion/view/widget/widget.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final getSearch = Get.put(UserSearchController());
  @override
  Widget build(BuildContext context) {
    getSearch.getSearchist();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              kheight10,
              CupertinoSearchTextField(
                onChanged: (value) {
                  getSearch.search(value);
                },
                backgroundColor: kdarkgrey,
                itemColor: kwhite,
                style: const TextStyle(color: kwhite),
              ),
              kheight30,
              Expanded(child: GetBuilder<UserSearchController>(
                builder: (controller) {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        // ignore: invalid_use_of_protected_member
                        final data = getSearch.seachList.value[index];
                        return ListTile(
                          onTap: () {
                            Get.to(OtherProfileScreen(userId: data.id));
                          },
                          title: Row(
                            children: [
                              textStyle(data.name!, 10),
                            ],
                          ),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(data.image!),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return divider();
                      },
                      // ignore: invalid_use_of_protected_member
                      itemCount: getSearch.seachList.value.length);
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
