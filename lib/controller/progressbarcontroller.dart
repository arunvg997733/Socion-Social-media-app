import 'dart:async';
import 'package:get/get.dart';

class ProgressBarController extends GetxController{

  RxDouble percentage = 0.0.obs;

  increase(){
    Timer.periodic(Duration(milliseconds: 25), (timer) {
      if(percentage.value +0.01 < 1){
        percentage.value +=0.01;
      }else{
        percentage.value = 1;
        timer.cancel();
        percentage.value = 0.0;
        Get.back();
      }
    });
  }
  
}