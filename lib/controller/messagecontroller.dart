import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:socion/model/message_model.dart';

class MessageController extends GetxController{
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference chatdata = FirebaseFirestore.instance.collection('chatdata');
  CollectionReference chatGroupdata = FirebaseFirestore.instance.collection('chatgroupdata');
  RxList chatGroupList = [].obs;
  
  sendmessage(String receiverId,String message,String image,String name){
    final time = Timestamp.now();
    final curreuserid = auth.currentUser!.uid;
    final newmessage = MessageModel(senderId: curreuserid, receiverId: receiverId, message: message, time: time);
    List<String> ids = [curreuserid,receiverId];
    ids.sort();
    String chatRoomId= ids.join("_");
    chatdata.doc(chatRoomId).collection('messages').add(newmessage.toMap());
    final lastmessage = {
      'lastmessage':message,
      'name':name,
      'image':image,
      'time':time,
      'userid':receiverId
    };
    chatGroupdata.doc(chatRoomId).set(lastmessage);
  }

  Stream <QuerySnapshot> getMessage(receiverId){
    List <String> ids = [auth.currentUser!.uid,receiverId];
    ids.sort();
    String charRoomId = ids.join("_");
    return  chatdata.doc(charRoomId).collection('messages').orderBy('time').snapshots();
  }

  clearChat(String receiverId,)async{
    print(auth.currentUser?.uid);
    List <String> ids = [auth.currentUser!.uid,receiverId];
    ids.sort();
    String charRoomId = ids.join("_");
     final data =await chatdata.doc(charRoomId).collection('messages').get();
     final singledata = chatdata.doc(charRoomId).collection('messages');
     for(var element in data.docs){
      singledata.doc(element.id).delete();
     }
  }

  // getChatGroup()async{
  //   chatGroupList.value.clear();
  //   final data =await chatGroupdata.get();
  //   String name = auth.currentUser!.uid;
  //   for(var element in data.docs){
  //     String docsname = element.id;
  //     if(docsname.contains(name)){
  //       chatGroupList.value.add(element);
  //     };
  //   }
  //   update();
  // }
}