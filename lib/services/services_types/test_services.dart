import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../models/user_model.dart';
import '../../routes/app_pages.dart';
import '../../controllers/export_controllers.dart';
import '../abstract_services.dart';

class TestServices implements AbstractServices {
  final AuthController _authController = Get.find();
  final UserController _userController = Get.find();
  final _box = GetStorage();

  static const _kLogin = 'kLogin';
  static const _kUser = 'kUser';

  @override
  void init({required String baseUrl}) {
    throw UnimplementedError();
  }

  @override
  Future<void> signUpEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    /// Default to Auto Sign Up
    _box.write(_kLogin, true);
    var user = UserModel(name: name, email: email);
    _box.write(_kUser, user.toJson());
    _userController.userModel.value = UserModel.fromJson(_box.read(_kUser));
    _authController.authStream.value = _authController.kAuthenticated;
    Get.offAllNamed(Routes.HOME);
    Get.showSnackbar(GetBar(
        title: 'Sign Up', message: 'Success', duration: Duration(seconds: 1)));
  }

  @override
  Future<void> loginEmail({
    required String email,
    required String password,
  }) async {
    /// Default to Auto Login
    _box.write(_kLogin, true);
    if (_box.hasData(_kUser)) {
      _userController.userModel.value = UserModel.fromJson(_box.read(_kUser));
    } else {
      var user = UserModel(
        name: 'Default Name',
        email: email,
      );
      _box.write(_kUser, user.toJson());
      _userController.userModel.value = UserModel.fromJson(_box.read(_kUser));
    }
    _authController.authStream.value = _authController.kAuthenticated;
    Get.offAllNamed(Routes.HOME);
    Get.showSnackbar(GetBar(
        title: 'Login', message: 'Success', duration: Duration(seconds: 1)));
  }

  @override
  Future<void> getUserDetails() async {
    if (_box.hasData(_kLogin)) {
      if (_box.read(_kLogin) == true) {
        if (_box.hasData(_kUser)) {
          _userController.userModel.value =
              UserModel.fromJson(_box.read(_kUser));
          _authController.authStream.value = _authController.kAuthenticated;
        } else {
          _box.write(_kLogin, false);
          _authController.authStream.value = _authController.kUnAuthenticated;
        }
      } else {
        _authController.authStream.value = _authController.kUnAuthenticated;
      }
    } else {
      _authController.authStream.value = _authController.kUnAuthenticated;
    }
  }

  @override
  Future<void> logout() async {
    _box.write(_kLogin, false);
    _box.remove(_kUser);
    _userController.userModel.value = UserModel();
    _authController.authStream.value = _authController.kUnAuthenticated;
    Get.offAllNamed(Routes.AUTH);
    Get.showSnackbar(GetBar(
        title: 'Log out', message: 'Success', duration: Duration(seconds: 1)));
  }
}
