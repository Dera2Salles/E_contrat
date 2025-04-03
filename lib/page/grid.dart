import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final List<String> labels = [
    "Home",
    "Favorite",
    "Star",
    "Person",
    "Settings",
    "Camera",
    "Music",
    "Email",
    "Phone",
  ];

  final List<String> destination = [
    '/editor',
    '/input',
    '/pad',
    '/editor',
    '/editor',
    '/editor',
    '/editor',
    '/editor',
  ];





   Grid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
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
 
 Align(
  alignment: Alignment(0.9, -0.4),
   child: SvgPicture.asset(
    'assets/svg/Consent.svg',
    width: 80.w ,
    height:80.h,
   ),
 )  ,

Align(
  alignment: Alignment(0.05, 0.2),
  child: SizedBox(
    width: 70.w,
    height: 70.h,
    child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 colonnes
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 30,
                  ),
                  itemCount: 9, // 3x3 = 9 items
                  itemBuilder: (context, index) {
                    return  FloatingActionButton(
                      heroTag: "fab_grid_$index",
                      elevation: 1,
              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                              ) ,
                    onPressed: () {
                     Navigator.pushNamed(context, destination[index]);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icons[index],
                        size: 35,),
                        Text(labels[index])
                      ],
                    ),
                    );
                  },
              ),
  ),
),
  curvedTab(),    ],
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


// Column bottomTabbar(){
//  return 
//  Column(
//   mainAxisSize:MainAxisSize.max ,
//   mainAxisAlignment: MainAxisAlignment.end,
//    children: [
//      GNav( 
      
//             backgroundColor: Colors.black.withOpacity(0.3),
//             tabBackgroundColor:  Colors.white ,
//             color: Colors.white,
//             activeColor:   Color.fromARGB(255, 83, 19, 194),
//             padding: EdgeInsets.symmetric(horizontal: 20,vertical: 18),
//             gap: 4,
//             tabs: const [
//               GButton(
//                 icon: Icons.layers_rounded,
//                 text:"Template",),
//               GButton(
//                 icon: Icons.check_circle,
//                 text:"Check",),
//               GButton(
//                 icon: Icons.favorite,
//                 text:"Favorite",
//                 ),
//                  GButton(
//                 icon: Icons.settings,
//                 text:"Setting",
//                 ),
     
//             ]),
//    ],
//  );
// }



Column curvedTab(){
 return 
 Column(
  mainAxisSize:MainAxisSize.max ,
  mainAxisAlignment: MainAxisAlignment.end,
   children: [
    CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      animationDuration: Duration(milliseconds: 300),
      items: [
        Icon(Icons.layers_rounded,
        color: Color.fromARGB(255, 83, 19, 194),
        size: 35,
         ),
        Icon(
          Icons.check_circle,
          color: Color.fromARGB(255, 83, 19, 194),
          size: 35,
        ),
        Icon(Icons.favorite,
        color: Color.fromARGB(255, 83, 19, 194),
        size: 35,
        ),
        Icon(Icons.settings,
        color: Color.fromARGB(255, 83, 19, 194),
        size: 35,
        ),
        
        
      ],)
    
            
   ],
 );
}
