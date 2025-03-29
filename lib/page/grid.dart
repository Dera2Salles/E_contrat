import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class Grid extends StatelessWidget {
  const Grid({super.key});

  @override
  Widget build(BuildContext context) {

     double screenHeight =MediaQuery.of(context).size.height;
      double screenWidth=MediaQuery.of(context).size.width;

    return Scaffold(
       extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          linear(),
 Positioned(
  top: screenHeight * 0.36,
 right: screenWidth * 0.6,
   child: Transform.scale(
    scale: 3.0,
     child: SvgPicture.asset(
      'assets/svg/background.svg',
      width: 300,
      height:300,
     ),
   ),
 ) ,
 
 Positioned(
  top: screenHeight * 0.06,
  left: screenWidth * 0.05,
   child: SvgPicture.asset(
    'assets/svg/Consent.svg',
    width: 670 ,
    height:670,
   ),
 )      ],
      ),
      // bottomNavigationBar: bottomTabbar()
    );
  }
}


Container linear(){
  return  Container(
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


GNav bottomTabbar(){
 return GNav(
        gap: 8,
        tabs: const [
          GButton(
            icon: Icons.home_outlined,
            text:"Home",),
          GButton(
            icon: Icons.check_circle_outline,
            text:"Check",),
          GButton(
            icon: Icons.favorite_outline,
            text:"Favorite",
            ),
             GButton(
            icon: Icons.settings_outlined,
            text:"Setting",
            ),

        ]);
}

