import 'package:e_contrat/page/home.dart';
import 'package:e_contrat/page/grid.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      
      builder: (context, orientation,deviceType){

        return  MaterialApp(
      initialRoute: '/home',
      routes: {
        'home': (context)=> HomePage(),
        '/grid':  (context)=> Grid(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.transparent
      ),
      home: const HomePage(),
    );
      }
    
    
    );
  }
}
