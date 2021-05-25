import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import '../controllers/export_controllers.dart';

class SplashScreen extends StatelessWidget {
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _authController.status(),
          builder: (context, snapshot) {
            return Center(
                child: Platform.isIOS || Platform.isMacOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator());
          }),
    );
  }
}
