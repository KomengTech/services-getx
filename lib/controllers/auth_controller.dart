import 'package:appwrite/appwrite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../widgets/loading_overlay.dart';
import '../services/export_services.dart';

class AuthController extends GetxController {
  /// Services Types
  static const _kTest = 'kTest';
  static const _kGetX = 'kGetX';
  static const _kFirebase = 'kFirebase';
  static const _kAppWrite = 'kAppWrite';

  late String config;

  late Services _services;
  late AbstractServices abstractServices;

  /// For FirebaseWrite Services
  late FirebaseAuth auth;

  /// For GetX Services
  var authStream = ''.obs;
  final String kUnAuthenticated = 'kUnAuthenticated';
  final String kAuthenticated = 'kAuthenticated';

  /// For AppWrite Services
  late Account account;
  late Storage storage;
  late Database database;

  var selectedTab = 0.obs;
  var nameTextController = TextEditingController(text: '');
  var name = ''.obs;
  var emailTextController = TextEditingController(text: '');
  var email = ''.obs;
  var passwordTextController = TextEditingController(text: '');
  var password = ''.obs;
  var obscurePassword = true.obs;
  var confirmPasswordTextController = TextEditingController(text: '');
  var obscureConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    config =
        _kTest; // TODO: Choose your service type (_kTest / _kGetX / _kFirebase / _kAppWrite)
    _services = Services();
  }

  Future<void> status() async {
    Future.delayed(Duration(seconds: 0), () async {
      authStream.value = kUnAuthenticated;
      switch (config) {
        case _kTest:
          {
            abstractServices = TestServices();
            await _services.getUserDetails();
            if (authStream.value == kAuthenticated) {
              Get.offAllNamed(Routes.HOME);
            } else {
              Get.offAllNamed(Routes.AUTH);
            }
          }
          break;
        case _kGetX:
          {
            abstractServices = GetXServices();
            _services.init(baseUrl: 'https://komengtech.com/api');
            authStream.value = kUnAuthenticated;
            await _services.getUserDetails();
            if (authStream.value == kAuthenticated) {
              Get.offAllNamed(Routes.HOME);
            } else {
              Get.offAllNamed(Routes.AUTH);
            }
          }
          break;
        case _kFirebase:
          {
            // TODO: To use Firebase follow installation: https://firebase.flutter.dev/docs/overview
            abstractServices = FirebaseServices();
            await Firebase.initializeApp();
            auth = FirebaseAuth.instance;
            auth.authStateChanges().listen((User? user) async {
              if (user != null) {
                await _services.getUserDetails();
                Get.offAllNamed(Routes.HOME);
              } else {
                Get.offAllNamed(Routes.AUTH);
              }
            });
          }
          break;
        case _kAppWrite:
          {
            // TODO: To use AppWrite follow installation: https://appwrite.io/docs/getting-started-for-flutter
            abstractServices = AppWriteServices();
            var client = Client();
            client
                .setEndpoint('https://localhost/v1') // Your Appwrite Endpoint
                .setProject(
                    '[PROJECT_ID]') // TODO: Remember to Add Project ID to AndroidManifest.xml as well
                .setSelfSigned(); // Use only on dev mode with a self-signed SSL cert
            account = Account(client);
            storage = Storage(client);
            database = Database(client);

            authStream.value = kUnAuthenticated;
            await _services.getUserDetails();
            if (authStream.value == kAuthenticated) {
              Get.offAllNamed(Routes.HOME);
            } else {
              Get.offAllNamed(Routes.AUTH);
            }
          }
          break;
      }
    });
  }

  Future<void> signUpEmail() async {
    await LoadingOverlay.during(_services.signUpEmail(
        name: name.value, email: email.value, password: password.value));
    resetData();
  }

  Future<void> loginEmail() async {
    await LoadingOverlay.during(
        _services.loginEmail(email: email.value, password: password.value));
    resetData();
  }

  Future<void> logout() async {
    await LoadingOverlay.during(_services.logout());
    resetData();
  }

  void resetData() {
    selectedTab.value = 0;
    nameTextController.clear();
    name.value = '';
    emailTextController.clear();
    email.value = '';
    passwordTextController.clear();
    password.value = '';
    obscurePassword.value = true;
    confirmPasswordTextController.clear();
    obscureConfirmPassword.value = true;
  }

  @override
  void onClose() {
    nameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
  }
}
