import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:socion/controller/progressbarcontroller.dart';
import 'package:socion/controller/story_controller.dart';
import 'package:socion/core/constant.dart';

class StoryViewScreen extends StatefulWidget {
  StoryViewScreen({super.key, required this.userId});
  String userId;

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  final getStory = Get.put(UserStoryController());

  final getProgress = Get.put(ProgressBarController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProgress.increase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: getStory.storyData.doc(widget.userId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  Obx(
                    () => LinearPercentIndicator(
                      lineHeight: 5,
                      backgroundColor: kgrey400,
                      progressColor: kgrey600,
                      percent: getProgress.percentage.value,
                      barRadius: const Radius.circular(5),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(snapshot.data!['image']))),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
