import 'package:flutter/material.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/widget/widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              kheight10,
              textStyle('Notification', 20),
              kheight30,
              Column(
                children: List.generate(30, (index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/car.jpeg'),
                      ),
                      title: textStyle('Rahul Prabakaran following you', 12),
                          
                      
                    ),
                  );
                }),
              )
        
            ],
          ),
        ),
      ),
    );
  }
}