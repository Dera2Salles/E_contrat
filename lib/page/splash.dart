import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:e_contrat/page/home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset('assets/Animation - 1743654758785.json'),
      ),
      nextScreen: HomePage(),
      duration: 2500,
      splashIconSize: 400,
    );
  }
}