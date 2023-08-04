import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class ViewImageScreen extends StatelessWidget {
   ViewImageScreen({super.key,required this.image});
String image;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: PhotoView(imageProvider: NetworkImage(image))
      ),
    );
  }
}