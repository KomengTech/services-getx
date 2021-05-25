import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../models/user_model.dart';
import '../../controllers/export_controllers.dart';
import '../abstract_services.dart';

class AppWriteServices implements AbstractServices {
  final AuthController _authController = Get.find();
  final UserController _userController = Get.find();

  void init({required String baseUrl}) {
    throw UnimplementedError();
  }

  @override
  Future<void> signUpEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authController.account.create(
        email: email,
        password: password,
        name: name,
      );
      _userController.userModel.value = UserModel.fromJson(user.data);
      _authController.authStream.value = _authController.kAuthenticated;
      Get.offAllNamed(Routes.HOME);
      Get.showSnackbar(GetBar(
          title: 'Sign Up',
          message: 'Success',
          duration: Duration(seconds: 1)));
    } on AppwriteException catch (e) {
      _authController.authStream.value = _authController.kUnAuthenticated;
      Get.showSnackbar(GetBar(
          title: 'Error', message: e.message, duration: Duration(seconds: 1)));
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> loginEmail({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _authController.account
          .createSession(email: email, password: password);
      _userController.userModel.value = UserModel.fromJson(session.data);
      _authController.authStream.value = _authController.kAuthenticated;
      Get.offAllNamed(Routes.HOME);
      Get.showSnackbar(GetBar(
          title: 'Login', message: 'Success', duration: Duration(seconds: 1)));
      print(session.data);
    } on AppwriteException catch (e) {
      _authController.authStream.value = _authController.kUnAuthenticated;
      Get.showSnackbar(GetBar(
          title: 'Error', message: e.message, duration: Duration(seconds: 1)));
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> getUserDetails() async {
    try {
      var profile = await _authController.account.get();
      _userController.userModel.value = UserModel.fromJson(profile.data);
      _authController.authStream.value = _authController.kAuthenticated;
    } on AppwriteException catch (e) {
      _authController.authStream.value = _authController.kUnAuthenticated;
      print(e.message);
    }
  }

  @override
  Future<void> logout() async {
    try {
      _authController.account.deleteSession(sessionId: 'current');
      _userController.userModel.value = UserModel();
      _authController.authStream.value = _authController.kUnAuthenticated;
      Get.offAllNamed(Routes.AUTH);
      Get.showSnackbar(GetBar(
          title: 'Log out',
          message: 'Success',
          duration: Duration(seconds: 1)));
    } on AppwriteException catch (e) {
      Get.showSnackbar(GetBar(
          title: 'Error', message: e.message, duration: Duration(seconds: 1)));
    } catch (e) {
      print(e);
    }
  }
}
