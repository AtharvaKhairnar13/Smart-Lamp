import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartlamp1/splash_screen.dart';

class WaitingScreen extends StatefulWidget{
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  void initState() {

    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(
          builder:(context) => const SplashScreen()
      ));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: Colors.black87,
        child:const Center(
          child: Icon(
            Icons.light_outlined,
            size: 100,
            color: Colors.orangeAccent,
          ),
        ),
      ),

    );
  }
}