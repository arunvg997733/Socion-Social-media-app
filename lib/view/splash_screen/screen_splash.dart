import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socion/controller/authcontroller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final getctr = Get.put(AuthController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 1), () {
      getctr.checkuserstatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          height: 100,
          image: AssetImage(
            'assets/Socion Logo.jpg',
          ),
        ),
      ),
    );
  }
}
