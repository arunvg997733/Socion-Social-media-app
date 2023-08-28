import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/messagecontroller.dart';
import 'package:socion/controller/searchcontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/model/user_model.dart';
import 'package:socion/view/chatscreen/screen_chat.dart';
import 'package:socion/view/search_screen/screen_search.dart';
import 'package:socion/view/widget/widget.dart';

class MessageScreen extends StatelessWidget {
   MessageScreen({super.key});
  final getserch = Get.put(UserSearchController());
  final getMsg = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    getserch.getSearchist();
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: kblack,
        title: Text('Messages'),
        centerTitle: true,
      ),
      body: 
      // GetBuilder<MessageController>(builder: (controller) {
      //   return ListView.separated(itemBuilder: (context, index) {
      //       final data = controller.chatGroupList.value[index];
      //       if(data.id.contains(getMsg.auth.currentUser!.uid)){
              
      //       }
      //       return RecentMessageTile(userId: data['userid'],name: data['name'],image:data['image'],lastmessage: data['lastmessage'],);
      //     }, separatorBuilder: (context, index) {
      //       return divider();
      //     }, itemCount: controller.chatGroupList.value.length);
      // },)
      

      GetBuilder<UserSearchController>(builder: (controller) {
        return ListView.separated(itemBuilder: (context, index) {
        final data = controller.allList.value[index];
        return MessageTile(userData:data);
      }, separatorBuilder: (context, index) {
        return divider();
      }, itemCount: controller.allList.value.length);
      },)
    );
  }
}

class RecentMessageTile extends StatelessWidget {
   RecentMessageTile({super.key,required this.userId,required this.name,required this.image,required this.lastmessage});
   String userId;
   String image;
   String name;
   String lastmessage;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(ChatScreen(name: name, image: image, userId: userId));
      },
      title: Row(
        children: [
          textStyle(name, 15),
        ],
      ),
      subtitle: Row(
        children: [
          textStyle(lastmessage, 12),
        ],
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(image) ,
      ),
    );
  }
}


class MessageTile extends StatelessWidget {
   MessageTile({super.key,required this.userData});
  UserModel userData;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(ChatScreen(name:userData.name!,image: userData.image!,userId: userData.id!,));
      },
      title: Row(
        children: [
          textStyle(userData.name!, 12),
        ],
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userData.image!) ,
      ),
    );
  }
}