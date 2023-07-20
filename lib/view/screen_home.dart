import 'package:flutter/material.dart';
import 'package:socion/core/constant.dart';
import 'package:socion/view/widget/widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    IconButton(onPressed: () {
                      
                    }, icon: iconStyle(Icons.messenger_outline))
                  ],
                ),
               SizedBox(
                width: double.infinity,
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  separatorBuilder: (context, index) {
                    return kwidth10;
                  },
                  itemBuilder: (context, index) {
                    const colorlist = Colors.accents;
                  return Column(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              border: Border.all(color: colorlist[index],width: 3),
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                image: AssetImage('assets/car.jpeg'),fit: BoxFit.cover)
                            ),
                          ),
                          textStyle('name', 12)
                        ],
                      );
                    
                },),
                
               ),
        
               Column(
                 children: List.generate(10, (index) {
                  return Column(
                          children: [
                            SizedBox(
                              height: 460,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: const DecorationImage(image: AssetImage('assets/car.jpeg'),fit: BoxFit.cover)
                                          ),
                                        ),
                                        kwidth10,
                                        textStyle('Name', 12)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 300,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(image: AssetImage('assets/car.jpeg'),fit: BoxFit.cover)
                                    ),
                                  ),
                                  Row(
                                  children: [
                                    kwidth10,
                                    textStyle('Like 150', 12),
                                    kwidth30,
                                    textStyle('Comment 35', 12),
                                    const Spacer(),
                                    IconButton(onPressed: () {
                                      
                                    }, icon: iconStyle(Icons.star_outline_rounded))
                                  ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            
                                            iconStyle(Icons.favorite_border),
                                            kwidth10,
                                            textStyle('Like', 15)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            iconStyle(Icons.mode_comment_outlined),
                                            kwidth10,
                                            textStyle('Comment', 15)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            iconStyle(Icons.share),
                                            kwidth10,
                                            textStyle('Share', 15),
                                            
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                 })
               )
                
              ],
            ),
          ),
        ),
      )
    );
  }
}