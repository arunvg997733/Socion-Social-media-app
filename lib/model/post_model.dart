import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? user;
  String? userid;
  String? discription;
  String? image;
  String? location;
  DateTime? time;

  PostModel(
      {required this.user,
      required this.userid,
      required this.discription,
      required this.image,
      required this.location,
      required this.time});

  factory PostModel.fromMap(DocumentSnapshot map) {
    return PostModel(
        user: map['user'],
        userid: map['userid'],
        discription: map['discription'],
        image: map['image'],
        location: map['location'],
        time: map['time'].toDate()); 
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'userid': userid,
      'discription': discription,
      'image': image,
      'location': location,
      'time': time
    };
  }
}
