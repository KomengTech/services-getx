import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/export_controllers.dart';

class HomeScreen extends StatelessWidget {
  final AuthController _authController = Get.find();
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () => _authController.logout(),
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Name: ${_userController.userModel.value.name!}'),
            const SizedBox(height: 20.0),
            Text('Email: ${_userController.userModel.value.email!}'),
          ],
        ),
      ),
    );
  }
}
