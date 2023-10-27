import 'dart:async';

import 'package:covid_tracker_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(duration: Duration(seconds: 3), vsync: this)..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
      ), (route) => false);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            AnimatedBuilder(
              animation: controller,
              child:  Center(
                child: Container(child: Image.asset("images/virus.png")),
              ),
              builder: (context, child) {
                return Transform.rotate(
                  angle: controller.value * 2 * math.pi,
                  child: child
                );
              },
            ),
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.05,
            ),
            Text(
              "Covid-19\nTracker App",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            )
          ])),
    );
  }
}
