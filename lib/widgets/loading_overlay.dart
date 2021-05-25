import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

class LoadingOverlay {
  static void _hide() {
    Get.back();
  }

  static void _show() {
    Get.dialog(
      Center(
          child: Platform.isIOS || Platform.isMacOS
              ? CupertinoActivityIndicator()
              : CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  static Future<T> during<T>(Future<T> future) {
    _show();
    return future.whenComplete(_hide);
  }
}
