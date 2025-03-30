import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sizer/sizer.dart';


class Grid extends StatelessWidget {
 
  final List<IconData> icons = [
    Icons.home,
    Icons.favorite,
    Icons.star,
    Icons.person,
    Icons.settings,
    Icons.camera,
    Icons.music_note,
    Icons.email,
    Icons.phone,
  ];




   Grid({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
       extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          linear(),
 Positioned(
  top: 35.h,
 right: 55.w,
   child: Transform.scale(
    scale: 3.0,
     child: SvgPicture.asset(
      'assets/svg/background.svg',
      width: 35.w,
      height:35.h,
     ),
   ),
 ) ,
 
 Positioned(
  top: 6.h,
  left: 5.w,
   child: SvgPicture.asset(
    'assets/svg/Consent.svg',
    width: 80.w ,
    height:80.h,
   ),
 )  ,

Positioned(
  top:18.h,
  left: 15.w,
  child: SizedBox(
    width: 70.w,
    height: 70.h,
    child: Positioned(
                height: 60.h, // Hauteur fixe de la grille
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 colonnes
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: 9, // 3x3 = 9 items
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(185, 187, 173, 173),
                          borderRadius: BorderRadius.circular(100),
                        
                        ),
                        child: Icon(
                          icons[index],
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
  ),
),
  bottomTabbar(),    ],
      ),
     
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


Column bottomTabbar(){
 return 
 Column(
  mainAxisSize:MainAxisSize.max ,
  mainAxisAlignment: MainAxisAlignment.end,
   children: [
     GNav( 
      
            backgroundColor: Colors.black.withOpacity(0.3),
            tabBackgroundColor:  Colors.white ,
            color: Colors.white,
            activeColor:   Color.fromARGB(255, 83, 19, 194),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 18),
            gap: 4,
            tabs: const [
              GButton(
                icon: Icons.layers_rounded,
                text:"Template",),
              GButton(
                icon: Icons.check_circle,
                text:"Check",),
              GButton(
                icon: Icons.favorite,
                text:"Favorite",
                ),
                 GButton(
                icon: Icons.settings,
                text:"Setting",
                ),
     
            ]),
   ],
 );
}
