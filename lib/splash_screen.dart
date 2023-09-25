import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'web_app.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() async {
    Timer(Duration(seconds: 3), () {
      navigateToWebAppScreen();
    });
  }

  void navigateToWebAppScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => WebApp(
                onLoad: () {},
              )),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5D0D0E),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Teen patti master",
                style: TextStyle(color: Colors.white, fontSize: 35),
              ),
              LottieBuilder.asset(
                "assets/cards.json",
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
