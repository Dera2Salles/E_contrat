import 'package:e_contrat/page/quill.dart';
import 'package:e_contrat/page/home.dart';
import 'package:e_contrat/page/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:sizer/sizer.dart';
import 'package:e_contrat/page/inputfield.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const Econtrat());
}

class Econtrat extends StatelessWidget {
  const Econtrat({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   
    return Sizer(
      
      builder: (context, orientation,deviceType){

        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          //  theme: ThemeData.light(useMaterial3: true),
                theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.transparent,
        useMaterial3: true
      ),

          darkTheme:  ThemeData(
        fontFamily: 'Poppins',
        // scaffoldBackgroundColor: Colors.transparent,
        useMaterial3: true
      ),
           themeMode: ThemeMode.system,
           localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      routes: {
        '/grid':  (context)=> Grid(),
        '/input' :  (context)=> InputPage(),
        '/editor': (context)=> Editor(),
      },
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   fontFamily: 'Poppins',
      //   scaffoldBackgroundColor: Colors.transparent
      // ),
      home: const HomePage(),
    );
      }
    
    
    );
  }
}
