import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../controllers/export_controllers.dart';
import '../abstract_services.dart';

class FirebaseServices implements AbstractServices {
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
      var userCredential = await _authController.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.updateProfile(displayName: name);

      _userController.userModel.value = UserModel(
        name: userCredential.user!.displayName,
        email: userCredential.user!.email,
      );
      Get.showSnackbar(GetBar(
          title: 'Sign Up',
          message: 'Success',
          duration: Duration(seconds: 1)));
    } on FirebaseAuthException catch (e) {
      Get.showSnackbar(GetBar(
          title: 'Error', message: e.code, duration: Duration(seconds: 1)));
      print(e.code);
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
      var userCredential = await _authController.auth
          .signInWithEmailAndPassword(email: email, password: password);

      _userController.userModel.value = UserModel(
        name: userCredential.user!.displayName,
        email: userCredential.user!.email,
      );

      Get.showSnackbar(GetBar(
          title: 'Login', message: 'Success', duration: Duration(seconds: 1)));
    } on FirebaseAuthException catch (e) {
      Get.showSnackbar(GetBar(
          title: 'Error', message: e.code, duration: Duration(seconds: 1)));
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> getUserDetails() async {
    User? user = _authController.auth.currentUser;
    _userController.userModel.value = UserModel(
      name: user!.displayName,
      email: user.email,
    );
  }

  @override
  Future<void> logout() async {
    await _authController.auth.signOut();
    Get.showSnackbar(GetBar(
        title: 'Log out', message: 'Success', duration: Duration(seconds: 1)));
  }
}
