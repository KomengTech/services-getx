import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../models/user_model.dart';
import '../../controllers/export_controllers.dart';
import '../abstract_services.dart';

class GetXServices extends GetConnect implements AbstractServices {
  final AuthController _authController = Get.find();
  final UserController _userController = Get.find();
  final _box = FlutterSecureStorage();

  static const _kToken = 'kToken';

  @override
  void init({required String baseUrl}) {
    /// Set the baseUrl. Example: https://komengtech.com/api
    httpClient.baseUrl = baseUrl;
  }

  @override
  Future<void> signUpEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> body = {
      'user': {
        'name': name,
        'email': email,
        'password': password,
      },
    };
    try {
      var response = await post('/user/sign_up', body);

      if (response.statusCode == 200) {
        await _box.write(key: _kToken, value: response.body['token']);
        _userController.userModel.value = UserModel.fromJson(response.body);
        _authController.authStream.value = _authController.kAuthenticated;
        Get.offAllNamed(Routes.HOME);
        Get.showSnackbar(GetBar(
            title: 'Sign Up',
            message: 'Success',
            duration: Duration(seconds: 1)));
      } else {
        _authController.authStream.value = _authController.kUnAuthenticated;
        Get.showSnackbar(GetBar(
            title: 'Sign Up',
            message: 'Failed',
            duration: Duration(seconds: 1)));
      }
    } catch (e) {
      Get.showSnackbar(GetBar(
          title: 'Error',
          message: e.toString(),
          duration: Duration(seconds: 1)));
      print(e);
    }
  }

  @override
  Future<void> loginEmail({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> body = {
      'user': {
        'email': email,
        'password': password,
      },
    };
    try {
      var response = await post('/user/login', body);

      if (response.statusCode == 200) {
        await _box.write(key: _kToken, value: response.body['token']);
        _userController.userModel.value = UserModel.fromJson(response.body);
        _authController.authStream.value = _authController.kAuthenticated;
        Get.offAllNamed(Routes.HOME);
        Get.showSnackbar(GetBar(
            title: 'Login',
            message: 'Success',
            duration: Duration(seconds: 1)));
      } else {
        _authController.authStream.value = _authController.kUnAuthenticated;
        Get.showSnackbar(GetBar(
            title: 'Login', message: 'Failed', duration: Duration(seconds: 1)));
      }
    } catch (e) {
      Get.showSnackbar(GetBar(
          title: 'Error',
          message: e.toString(),
          duration: Duration(seconds: 1)));
      print(e);
    }
  }

  @override
  Future<void> getUserDetails() async {
    var token = await _box.read(key: _kToken);
    if (token != null) {
      try {
        var response =
            await get('/user', headers: {'Authorization': 'Bearer $token'});

        if (response.statusCode == 200) {
          /// Every getUserDetails() api call to update the user token backend
          await _box.write(key: _kToken, value: response.body['token']);
          _userController.userModel.value = UserModel.fromJson(response.body);
          _authController.authStream.value = _authController.kAuthenticated;
        } else {
          /// Likely token is wrong, login to get new token
          _authController.authStream.value = _authController.kUnAuthenticated;
        }
      } catch (e) {
        print(e);
      }
    } else {
      _authController.authStream.value = _authController.kAuthenticated;
    }
  }

  @override
  Future<void> logout() async {
    Map<String, dynamic> body = {
      'user': {
        'email': _userController.userModel.value.email,
      }
    };

    var token = await _box.read(key: _kToken);

    try {
      var response = await post('/user/logout', body,
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        _box.delete(key: _kToken);
        _userController.userModel.value = UserModel();
        _authController.authStream.value = _authController.kUnAuthenticated;
        Get.offAllNamed(Routes.AUTH);
        Get.showSnackbar(GetBar(
            title: 'Log out',
            message: 'Success',
            duration: Duration(seconds: 1)));
      }
    } catch (e) {
      Get.showSnackbar(GetBar(
          title: 'Error',
          message: e.toString(),
          duration: Duration(seconds: 1)));
      print(e);
    }
  }
}
