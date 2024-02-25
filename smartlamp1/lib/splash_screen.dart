import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:smartlamp1/lamp.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(
          builder:(context) => lamppage()
      ));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Lottie.asset(
            'assets/animations/AuLS0prpHI_1.json',
            fit: BoxFit.cover// Path to your Lottie animation file

      ),
        ),

    );
  }
}