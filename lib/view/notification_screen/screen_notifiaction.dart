import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/notificationcontroller.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/widget/widget.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final getnoti = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    getnoti.updateNotification();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kblack,
        centerTitle: true,
        title: textStyle('Notification', 20),
      ),
      body: SafeArea(child: GetBuilder<NotificationController>(
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () async {
              getnoti.updateNotification();
            },
            child: ListView.separated(
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      getnoti.notificationlist.value[index];
                  return ListTile(
                    onLongPress: () {
                      showMenu(
                          color: kdarkgrey,
                          context: context,
                          position: RelativeRect.fill,
                          items: <PopupMenuEntry>[
                            PopupMenuItem(
                                onTap: () {
                                  getnoti.deleteNotification(
                                      data['notificationid']);
                                },
                                child: textStyle('Delete', 12))
                          ]);
                    },
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(data['image']),
                    ),
                    title: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // NotificationtextStyle(text: '${data['user']+'  '+data['matter']+'  '+data['time']}',size:13,maxline: 2)
                                textStyle(data['user'], 13),
                                kwidth5,
                                textStyle(data['matter'], 13),
                              ],
                            ),
                            textStyle(data['time'], 13),
                          ],
                        ),
                      ],
                    ),
                    trailing: data['postimage'] == ''
                        ? SizedBox()
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(data['postimage']),
                                    fit: BoxFit.cover))),
                  );
                },
                separatorBuilder: (context, index) {
                  return divider();
                },
                itemCount: getnoti.notificationlist.length),
          );
        },
      )),
    );
  }
}
