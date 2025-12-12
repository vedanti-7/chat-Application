import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget{   //loading screen while firebase is figuring out whether we have a token or not 
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
      ),
      body: const Center(
        child: Text('Logged in!'),
      ),
    );
  }
}