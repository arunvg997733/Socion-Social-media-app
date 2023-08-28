import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  String senderId;
  String receiverId;
  String message;
  Timestamp time;

  MessageModel({required this.senderId,required this.receiverId,required this.message,required this.time});

  Map<String, dynamic> toMap(){
   return {
      'senderid':senderId,
      'receiverid':receiverId,
      'message':message,
      'time':time
    };
  }
} 