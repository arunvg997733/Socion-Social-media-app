import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socion/controller/messagecontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/widget/widget.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key,required this.name,required this.image,required this.userId,required this.token});
  String name;
  String image;
  String userId;
  String token;
  final getMsg = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: iconStyle(Icons.more_vert),
            color: kdarkgrey,
            itemBuilder: (context) {
            return [PopupMenuItem(
              onTap: () {
                getMsg.clearChat(userId);
              },
              child: textStyle('Clear Chat', 12))];
          },)
        ],
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: image==''?AssetImage('assets/user.jpg') as ImageProvider:NetworkImage(image),
            ),
            kwidth10,
            textStyle(name,20),
          ],
        ),
        backgroundColor: kblack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            StreamBuilder(
              stream: getMsg.getMessage(userId),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return textStyle(snapshot.error.toString(), 10);
                } 
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }
              return Expanded(
                child:snapshot.data!.docs.isEmpty ? Center(child: textStyle('Start new message', 15)) : ListView.separated(
                  controller: PageController(initialPage:snapshot.data!.docs.length ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];
                  return  Message(data: data,);
                },
                separatorBuilder: (context, index) {
                  return kheight10;
                },),
              );
            },),
            kheight10,
            MessageTextField(userId: userId,image: image,name: name,token: token,)
          ],
        ),
      ),
      
    );
  }
}

// ignore: must_be_immutable
class Message extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  Message({super.key,required this.data  });
  DocumentSnapshot data;
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DateTime time = data['time'].toDate();
    String formatTime = DateFormat('h:mm a').format(time);
    return Container(
      alignment: data['senderid'] == auth.currentUser!.uid ? Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color:data['senderid'] == auth.currentUser!.uid ?  kdarkgrey:kmixcolorpink,
          borderRadius:data['senderid'] == auth.currentUser!.uid ?  const BorderRadius.only(bottomLeft: Radius.circular(15),topRight: Radius.circular(15),topLeft: Radius.circular(15)):const BorderRadius.only(topLeft: Radius.circular(15),bottomRight: Radius.circular(15),topRight: Radius.circular(15))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              data['postimg'] == '' ? const SizedBox(): Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: size.width*0.6,
                  width: size.width*0.6,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(data['postimg']))
                  ),
                ),
              ),
              data['message']== ''? const SizedBox(): MessagetextStyle(data['message'], 14),
              kwidth10,
              MessagetextStyle(formatTime, 10)
            ],
          ),
        )),
    );
  }
  
}

// ignore: must_be_immutable
class MessageTextField extends StatelessWidget {
   MessageTextField({super.key,required this.userId,required this.name,required this.image,required this.token});
   String userId;
   String name;
   String image;
   String token;
  final getMsg = Get.put(MessageController());
  TextEditingController messagectr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kdarkgrey,
        borderRadius: BorderRadius.circular(30)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
             Expanded(child: TextField(
              style: const TextStyle(color: kwhite),
              controller: messagectr,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText:'Message...' ,
                hintStyle: TextStyle(
                  color: kwhite
                )
              ),
            )),
            IconButton(onPressed: () {
              if(messagectr.text.isNotEmpty){
                getMsg.sendmessage(userId, messagectr.text,image,name,token,'');
              }
              messagectr.clear();
            }, icon: iconStyle(Icons.send))
          ],
        ),
      ),
    );
  }
}