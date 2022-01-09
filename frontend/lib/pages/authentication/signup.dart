import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:smartcityapp/components/animatedbutton.dart';
import 'package:smartcityapp/components/animatedstructure.dart';
import 'package:smartcityapp/services/authentication.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with TickerProviderStateMixin {
  late AnimationController _buttonControllerlogin;
  late double _scale;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController password1Controller = new TextEditingController();
  TextEditingController password2Controller = new TextEditingController();
  final keys = GlobalKey<FormState>();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _buttonControllerlogin.value;
    return isloading
        ? const Center(child: CircularProgressIndicator())
        : AnimatedStructure(
            child: Center(
              child: Form(
                key: keys,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("REGISTER",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 50,
                      child: TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email,
                              color: Colors.teal[200], size: 20),
                          hintText: "Username",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.tealAccent,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your username!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 50,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email,
                              color: Colors.teal[200], size: 20),
                          hintText: "Email ID",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.tealAccent,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your email!";
                          }
                          if (!value.contains("@") || !value.contains(".")) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: TextFormField(
                        controller: password1Controller,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email,
                              color: Colors.teal[200], size: 20),
                          hintText: "Password",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.tealAccent,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password must be greater than 6 characters!";
                          }
                          if (value.isEmpty) {
                            return "Please enter your password!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: TextFormField(
                        controller: password2Controller,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email,
                              color: Colors.teal[200], size: 20),
                          hintText: "Password",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.tealAccent,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password must be greater than 6 characters!";
                          }
                          if (value != password1Controller.text) {
                            return "Passwords doesn't match";
                          }
                          if (value.isEmpty) {
                            return "Please enter your password!";
                          }
                          return null;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        _buttonControllerlogin.forward();
                      },
                      onTapUp: (TapUpDetails details) {
                        _buttonControllerlogin.reverse();
                        initRegister();
                      },
                      child: Transform.scale(
                        scale: _scale,
                        child: const AnimatedButtonUI(text: "REGISTER"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  @override
  void initState() {
    _buttonControllerlogin = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _buttonControllerlogin.dispose();
    super.dispose();
  }

  //Starting sign up process
  Future<void> initRegister() async {
    if (keys.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        var response = await signup(
          usernameController.text,
          emailController.text,
          password1Controller.text,
        );
        if (response.statusCode == 200) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            showCancelBtn: false,
            text: 'Registered successfully! Now you can login',
            confirmBtnText: 'Sure!',
            confirmBtnColor: Colors.orange,
            onConfirmBtnTap: () {
              Navigator.of(context).pushReplacementNamed('home');
            },
          );
        } else {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            showCancelBtn: false,
            confirmBtnText: 'Try again!',
            text: json.decode(response.body).toString(),
            confirmBtnColor: Colors.orange,
          );
        }
      } catch (e) {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          showCancelBtn: false,
          confirmBtnText: 'Try again!',
          text: 'Something went wrong, ${e}',
          confirmBtnColor: Colors.orange,
        );
      }
      setState(() {
        isloading = false;
      });
    }
  }
}
