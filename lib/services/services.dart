import 'package:get/get.dart';
import 'abstract_services.dart';
import '../controllers/export_controllers.dart';

class Services implements AbstractServices {
  final AuthController authController = Get.find();
  @override
  void init({required String baseUrl}) {
    authController.abstractServices.init(baseUrl: baseUrl);
  }

  @override
  Future<void> signUpEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    await authController.abstractServices
        .signUpEmail(name: name, email: email, password: password);
  }

  @override
  Future<void> loginEmail({
    required String email,
    required String password,
  }) async {
    await authController.abstractServices
        .loginEmail(email: email, password: password);
  }

  @override
  Future<void> getUserDetails() async {
    await authController.abstractServices.getUserDetails();
  }

  @override
  Future<void> logout() async {
    await authController.abstractServices.logout();
  }
}
