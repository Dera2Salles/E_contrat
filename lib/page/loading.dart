import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({super.key, this.message = 'Generating PDF...'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,),
            ),
            SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}