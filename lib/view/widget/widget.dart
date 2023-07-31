import 'package:flutter/material.dart';
import 'package:socion/core/constant.dart';

Icon iconStyle(IconData icon) {
  return Icon(
    icon,
    color: kwhite,
  );
}

Widget textStyle(String text, double size) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: kwhite,
      fontSize: size,
    ),
  );
}

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget(
      {super.key,
      required this.controller,
      required this.hint,
      this.wordlenth});

  final TextEditingController controller;
  final String? hint;
  final int? wordlenth;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: kwhite),
      controller: controller,
      maxLength: wordlenth,
      decoration: InputDecoration(
          counterStyle: TextStyle(color: kwhite),
          label: Text(
            hint!,
            style: TextStyle(color: kwhite),
          ),
          fillColor: kdarkgrey,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
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
        label: Text(
          hint!,
          style: TextStyle(color: kwhite),
        ),
        fillColor: kdarkgrey,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
