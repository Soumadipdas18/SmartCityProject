import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartcityapp/components/animatedbutton.dart';
import 'package:smartcityapp/components/animatedstructure.dart';
import 'package:smartcityapp/services/authentication.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late AnimationController _buttonControllerlogin;
  late double _scale;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
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
                    const Text("LOGIN",
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
                      width: MediaQuery.of(context).size.width - 50,
                      child: TextFormField(
                        controller: passwordController,
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
                    GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        _buttonControllerlogin.forward();
                      },
                      onTapUp: (TapUpDetails details) {
                        _buttonControllerlogin.reverse();
                        initSignIn();
                      },
                      child: Transform.scale(
                        scale: _scale,
                        child: const AnimatedButtonUI(text: "SIGN IN"),
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

  Future<void> initSignIn() async {
    if (keys.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        var response =
            await signin(usernameController.text, passwordController.text);
        print(json.decode(response.body));
        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Map<String,dynamic> userdata={
            "username":usernameController.text,
            "password":passwordController.text,
            "access":jsonDecode(response.body)['access'],
            "refresh":jsonDecode(response.body)['refresh'],
          };
          await prefs.setString('userdata', jsonEncode(userdata));
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            showCancelBtn: false,
            text: 'Logged in successfully',
            confirmBtnText: 'Next!',
            confirmBtnColor: Colors.orange,
            onConfirmBtnTap: () {
              Phoenix.rebirth(context);
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
