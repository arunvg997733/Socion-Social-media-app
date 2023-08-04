import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socion/core/constant.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              kheight10,
              CupertinoSearchTextField(
                backgroundColor: kdarkgrey,
                itemColor: kwhite,
                style: TextStyle(color: kwhite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
