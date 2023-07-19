import 'package:flutter/material.dart';
import 'package:socion/core/constant.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
            style: TextStyle(color: kwhite),
            controller: controller,
            decoration: InputDecoration(
              label:Text(hint!,style: TextStyle(color: kwhite),) ,
              fillColor: kdarkgrey,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
          );
  }
}

class HideTextFieldWidget extends StatelessWidget {
  const HideTextFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
            obscureText: true,
            style: TextStyle(color: kwhite),
            controller: controller,
            decoration: InputDecoration(
              label:Text(hint!,style: TextStyle(color: kwhite),) ,
              fillColor: kdarkgrey,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
          );
  }
}