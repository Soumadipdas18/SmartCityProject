import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartcityapp/components/animatedbutton.dart';
import 'package:smartcityapp/components/animatedstructure.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late double _scalelogin;
  late double _scalesignup;
  bool _isloading = false;
  bool _routeLayout = false;
  late Animation<double> backgroundAnimation;
  late AnimationController _backgroundController;
  late AnimationController _buttonControllerlogin;
  late AnimationController _buttonControllersignup;
  final bubbleWidgets = <Widget>[];
  bool areBubblesAdded = false;
  late Animation<double> bubbleAnimation;
  late AnimationController bubbleController;
  AlignmentTween alignmentTop =
      AlignmentTween(begin: Alignment.topRight, end: Alignment.topLeft);
  AlignmentTween alignmentBottom =
      AlignmentTween(begin: Alignment.bottomRight, end: Alignment.bottomLeft);
  Animatable<Color?> backgroundDark = TweenSequence<Color?>([
    TweenSequenceItem(
      weight: 0.5,
      tween: ColorTween(
        begin: Colors.red[300],
        end: Colors.orangeAccent,
      ),
    ),
    TweenSequenceItem(
      weight: 0.5,
      tween: ColorTween(
        begin: Colors.red[300],
        end: Colors.orangeAccent,
      ),
    ),
  ]);

// Normal color
  Animatable<Color?> backgroundNormal = TweenSequence<Color?>([
    TweenSequenceItem(
      weight: 0.5,
      tween: ColorTween(
        begin: Colors.red[300],
        end: Colors.orangeAccent,
      ),
    ),
    TweenSequenceItem(
      weight: 0.5,
      tween: ColorTween(
        begin: Colors.red[300],
        end: Colors.orangeAccent,
      ),
    ),
  ]);

// Light color
  Animatable<Color?> backgroundLight = TweenSequence<Color?>([
    TweenSequenceItem(
      weight: 0.5,
      tween: ColorTween(
        begin: Colors.orange[500],
        end: Colors.orange[100],
      ),
    ),
    TweenSequenceItem(
      weight: 0.5,
      tween: ColorTween(
        begin: Colors.orange[500],
        end: Colors.orange[100],
      ),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    _scalelogin = 1 - _buttonControllerlogin.value;
    _scalesignup = 1 - _buttonControllersignup.value;
    if (!areBubblesAdded) {
      addBubbles(animation: bubbleAnimation);
    }
    return _isloading
        ? const Center(child: CircularProgressIndicator())
        : AnimatedBuilder(
            animation: backgroundAnimation,
            builder: (context, child) {
              return Scaffold(
                body: Stack(
                    children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin:
                                    alignmentTop.evaluate(backgroundAnimation),
                                end: alignmentBottom
                                    .evaluate(backgroundAnimation),
                                colors: [
                                  backgroundDark.evaluate(backgroundAnimation)!,
                                  backgroundNormal
                                      .evaluate(backgroundAnimation)!,
                                  backgroundLight
                                      .evaluate(backgroundAnimation)!,
                                ],
                              ),
                            ),
                          ),
                        ] +
                        bubbleWidgets +
                        [
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              color: Colors.transparent,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  const Spacer(),
                                  const Spacer(),
                                  const Spacer(),
                                  const Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text("SMART CITY MANAGEMENT APP",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 45,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/welcomescreenlogo.png',
                                    width: 300,
                                    height: 300,
                                  ),
                                  const Spacer(),
                                  const Spacer(),
                                  GestureDetector(
                                    onTapDown: (TapDownDetails details) {
                                      _buttonControllerlogin.forward();
                                    },
                                    onTapUp: (TapUpDetails details) {
                                      _buttonControllerlogin.reverse();
                                      Navigator.of(context).pushNamed('login');
                                    },
                                    child: Transform.scale(
                                      scale: _scalelogin,
                                      child: const AnimatedButtonUI(
                                          text: "SIGN IN"),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTapDown: (TapDownDetails details) {
                                      _buttonControllersignup.forward();
                                    },
                                    onTapUp: (TapUpDetails details) {
                                      _buttonControllersignup.reverse();
                                      Navigator.of(context).pushNamed('signup');
                                    },
                                    child: Transform.scale(
                                      scale: _scalesignup,
                                      child: const AnimatedButtonUI(
                                          text: "REGISTER"),
                                    ),
                                  ),
                                  Spacer(),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ]),
              );
            });
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

    _buttonControllersignup = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    backgroundAnimation =
        CurvedAnimation(parent: _backgroundController, curve: Curves.easeIn);
    bubbleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    bubbleAnimation = CurvedAnimation(
        parent: bubbleController, curve: Curves.easeIn)
      ..addListener(() {})
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            addBubbles(animation: bubbleAnimation, topPos: -1.001, bubbles: 2);
            bubbleController.reverse();
          });
        }
        if (status == AnimationStatus.dismissed) {
          setState(() {
            addBubbles(animation: bubbleAnimation, topPos: -1.001, bubbles: 2);
            bubbleController.forward();
          });
        }
      });
    bubbleController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _buttonControllerlogin.dispose();
    _buttonControllersignup.dispose();
    bubbleController.dispose();
    super.dispose();
  }

  void addBubbles({animation, topPos = 0, leftPos = 0, bubbles = 8}) {
    for (var i = 0; i < bubbles; i++) {
      var range = Random(); // To use random import math.dart
      var minSize = range.nextInt(30).toDouble();
      var maxSize = range.nextInt(30).toDouble();
      var left = leftPos == 0
          ? range.nextInt(MediaQuery.of(context).size.width.toInt()).toDouble()
          : leftPos;
      var top = topPos == 0
          ? range.nextInt(MediaQuery.of(context).size.height.toInt()).toDouble()
          : topPos;

      var bubble = Positioned(
          left: left,
          top: top,
          child: AnimatedBubble(
              animation: animation, startSize: minSize, endSize: maxSize));

      setState(() {
        areBubblesAdded = true;
        bubbleWidgets.add(bubble);
      });
    }
  }
}
