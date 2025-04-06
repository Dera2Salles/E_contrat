import 'package:flutter/material.dart';

class Linear extends StatelessWidget {
  const Linear({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors:[
           Color.fromARGB(255, 83, 19, 194),
          Color(0xFFE9CBFD),
          Color(0xFFE9CBFD),
         
          

        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
        )
    ),
  );
  }
}