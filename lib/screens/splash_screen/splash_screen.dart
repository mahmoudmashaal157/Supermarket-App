import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supermarkett/screens/receipt/receipt_screen.dart';
import 'package:page_transition/page_transition.dart';


class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 400,
      backgroundColor: Colors.white,
        duration: 1000,
        splashTransition:SplashTransition.scaleTransition ,
        pageTransitionType:PageTransitionType.leftToRightWithFade,
        splash: Column(
          children: [
            Image.asset("assets/images/shop-app-icon.png"),
            const Text("SuperMarket App",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            )

          ],
        ),
        nextScreen: ReceiptScreen()
    );
  }
}
