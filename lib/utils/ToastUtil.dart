import 'package:flutter/material.dart';

class Toastutil {
  static Duration duration = Duration(milliseconds: 1000);
  static bool showLoading = false;
  static void showToast(BuildContext context, String? msg) {
    if(Toastutil.showLoading) {
      return;
    }
    Toastutil.showLoading = true;
    Future.delayed(duration, () {
      Toastutil.showLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 120,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        duration: duration,
        content: Text(msg ?? "", textAlign: TextAlign.center,),
      )
    );
  }
}