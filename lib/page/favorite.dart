import 'package:flutter/material.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange, // Fond de la page 4
      child: Center(child: Text("Page 4", style: TextStyle(fontSize: 24, color: Colors.white))),
    );
  }
}