import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartcityapp/pages/authentication/login.dart';
import 'package:smartcityapp/pages/authentication/signup.dart';
import 'package:smartcityapp/pages/home/home.dart';
import 'package:smartcityapp/welcomescreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SmartCity Management',
        theme: ThemeData(
          fontFamily: 'gothic',
        ),
        home: isLoading
            ? const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        )
            : SafeArea(
            child: isLoggedIn ? const Home() : const WelcomeScreen()),
        routes: {
          'login': (context) => Login(),
          'signup': (context) => Signup(),
          'home': (context) => Home()
        }
    );
  }
    @override
    void initState() {
      getuserdata();
      super.initState();
    }

    Future<void> getuserdata() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var data = prefs.getString('userdata');
      if (data != null) {
        isLoggedIn = true;
      } else {
        isLoggedIn = false;
      }
      setState(() {
        isLoading = false;
      });
    }
  }