import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover, width: double.infinity, height: double.infinity,
          ),
          Center(
            child: Text('App của Dui',
              style: TextStyle(fontSize: 33, color: Colors.white),),
          ),
        ],
      )
    );
  }
  
}