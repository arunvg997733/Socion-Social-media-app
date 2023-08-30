import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? email;
  String? id;
  String? token;
  String? image;
  String? gender;
  String? bio;

  UserModel(
      {this.name, this.email, this.id, this.bio, this.gender, this.image,this.token});
  factory UserModel.fromMap(DocumentSnapshot map) {
    return UserModel(
        name: map['name'],
        email: map['email'],
        id: map.id,
        token: map['token'],
        bio: map['bio'],
        gender: map['gender'],
        image: map['image']);
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'userid': id,
      'token':token,
      'image': image,
      'gender': gender,
      'bio': bio
    };
  }
}
