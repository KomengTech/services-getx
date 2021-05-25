import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/export_controllers.dart';

class AuthScreen extends StatelessWidget {
  final AuthController _authController = Get.find();
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.flutter_dash,
                  size: 100,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      width: 250,
                      child: Obx(() => CupertinoSlidingSegmentedControl<int>(
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            thumbColor: Colors.white,
                            children: {
                              0: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text('Sign Up',
                                    style: TextStyle(
                                        color:
                                            _authController.selectedTab.value ==
                                                    0
                                                ? Colors.black
                                                : Colors.white)),
                              ),
                              1: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text('Login',
                                    style: TextStyle(
                                        color:
                                            _authController.selectedTab.value ==
                                                    1
                                                ? Colors.black
                                                : Colors.white)),
                              ),
                            },
                            onValueChanged: (value) {
                              _authController.selectedTab.value = value!;
                              _pageController.animateToPage(value,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.decelerate);
                            },
                            groupValue: _authController.selectedTab.value,
                          )),
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const ClampingScrollPhysics(),
                        onPageChanged: (int i) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _authController.selectedTab.value = i;
                        },
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: register(isSignUp: true),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: register(isSignUp: false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget register({required bool isSignUp}) {
    final _formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              if (isSignUp)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    controller: _authController.nameTextController,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name is required';
                      } else if (value.length < 3) {
                        return 'Minimum three characters';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _authController.name.value = value!;
                    },
                  ),
                ),
              TextFormField(
                controller: _authController.emailTextController,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                decoration: InputDecoration(
                    hintText: 'Email',
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0))),
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);
                  if (value!.isEmpty) {
                    return 'Email is required';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Invalid Email';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _authController.email.value = value!;
                },
              ),
              const SizedBox(height: 20.0),
              Obx(() => TextFormField(
                    controller: _authController.passwordTextController,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    obscureText: _authController.obscurePassword.value,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _authController.obscurePassword.value =
                              !_authController.obscurePassword.value;
                        },
                        child: Icon(
                          _authController.obscurePassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          semanticLabel: _authController.obscurePassword.value
                              ? 'show password'
                              : 'hide password',
                        ),
                      ),
                    ),
                    validator: (value) {
                      String pattern =
                          r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
                      RegExp regExp = RegExp(pattern);
                      if (value!.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 8) {
                        return 'Password must minimum eight characters';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Password at least uppercase, lowercase and number';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _authController.password.value = value!;
                    },
                  )),
              if (isSignUp)
                Obx(() => Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        controller:
                            _authController.confirmPasswordTextController,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        obscureText:
                            _authController.obscureConfirmPassword.value,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _authController.obscureConfirmPassword.value =
                                  !_authController.obscureConfirmPassword.value;
                            },
                            child: Icon(
                              _authController.obscureConfirmPassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              semanticLabel:
                                  _authController.obscureConfirmPassword.value
                                      ? 'show password'
                                      : 'hide password',
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Confirmation Password is Required';
                          } else if (value !=
                              _authController
                                  .confirmPasswordTextController.text) {
                            return 'Password does not match';
                          } else {
                            return null;
                          }
                        },
                      ),
                    )),
              const SizedBox(height: 20.0),
              Container(
                height: 44,
                child: SizedBox.expand(
                  child: CupertinoButton(
                    borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                    padding: EdgeInsets.zero,
                    color: Colors.blue,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blue),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Submit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (!isSignUp) {
                          _authController.loginEmail();
                        } else {
                          _authController.signUpEmail();
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
