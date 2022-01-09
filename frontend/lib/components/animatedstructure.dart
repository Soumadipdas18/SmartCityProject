import 'dart:math';
import 'package:smartcityapp/welcomescreen.dart';
import 'package:flutter/material.dart';

class AnimatedStructure extends StatefulWidget {
  const AnimatedStructure({Key? key, required this.child,this.bottomnav}) : super(key: key);
  final Widget child;
  final Widget? bottomnav;
  @override
  _AnimatedStructureState createState() => _AnimatedStructureState();
}

class _AnimatedStructureState extends State<AnimatedStructure>
    with TickerProviderStateMixin {
  bool _isloading = false;

  late Animation<double> backgroundAnimation;
  late AnimationController _backgroundController;
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
    if (!areBubblesAdded) {
      addBubbles(animation: bubbleAnimation);
    }
    return _isloading
        ? Center(child: CircularProgressIndicator())
        : AnimatedBuilder(
            animation: backgroundAnimation,
            builder: (context, child) {
              return Scaffold(
                bottomNavigationBar: widget.bottomnav,
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
                        [widget.child]),
              );
            });
  }

  @override
  void initState() {
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

      var bubble = new Positioned(
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

  Widget _animatedButtonUI(String text) => Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                color: Color(0x80000000),
                blurRadius: 30.0,
                offset: Offset(0.0, 5.0),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF0000),
                Color(0xFFFFAA00),
              ],
            )),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: Colors.white),
          ),
        ),
      );
}

class AnimatedBubble extends AnimatedWidget {
  var transform = Matrix4.identity();
  late double startSize;
  late double endSize;
  final Animation<double> animation;

  AnimatedBubble({
    Key? key,
    required this.startSize,
    required this.endSize,
    required this.animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final _sizeTween = Tween<double>(begin: startSize, end: endSize);

    transform.translate(0.0, 0.5, 0.0);

    return Opacity(
      opacity: 0.2,
      child: Transform(
        transform: transform,
        child: Container(
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          height: _sizeTween.evaluate(animation),
          width: _sizeTween.evaluate(animation),
        ),
      ),
    );
  }
}
