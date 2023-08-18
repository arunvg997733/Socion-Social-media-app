import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/story_controller.dart';


class StoryViewScreen extends StatelessWidget {
  StoryViewScreen({super.key,required this.userId});
  String userId;
  final getStory = Get.put(UserStoryController());
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder(
        stream: getStory.storyData.doc(userId).snapshots(),
        builder: (context, snapshot) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(snapshot.data!['image']))
            ),
          );
        }
      ),
    );
  }
}
