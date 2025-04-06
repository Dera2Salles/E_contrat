import 'package:e_contrat/page/linear.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class Template extends StatelessWidget {
    Template({super.key});




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
    '/input',
    '/input',
    '/input',
    '/input',
    '/input',
    '/input',
    '/input',
    '/input',
    '/input',
  ];










  @override
  Widget build(BuildContext context) {
    return      Stack(
          children: [
            Linear(),
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
        alignment: Alignment(0.4, -0.4),
         child: SvgPicture.asset(
      'assets/svg/Consent.svg',
      width: 80.w ,
      height:80.h,
         ),
       )  ,
      
      Align(
        alignment: Alignment(0.08, 0.2),
        child: SizedBox(
      width: 65.w,
      height: 65.h,
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
         ],
        );  
  }
}