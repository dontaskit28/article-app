import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackMessage{
  static showSnackBar({
    required String title,
    required String message,
    bool isError = false,
  }){
    Get.snackbar(title, message, snackPosition: SnackPosition.TOP,backgroundColor: isError ? Colors.red : Colors.green, colorText: Colors.white,);
  }
}