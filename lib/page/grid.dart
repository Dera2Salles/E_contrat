import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:e_contrat/page/inputfield.dart';
import 'package:e_contrat/page/template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:e_contrat/page/pdfquill.dart' as pdfquill_page;
// import 'package:e_contrat/page/template.dart';
// import 'package:e_contrat/page/favorite.dart';


class Grid extends StatefulWidget{
  const Grid({super.key});

 @override
  State<Grid> createState()=> _GridState();
}



class _GridState extends State<Grid>{
 
int _pageIndex = 0; // Index de la page actuelle

  // Liste des pages à afficher
  final List<Widget> _pages = [
    Template(),
    pdfquill_page.PdfQuill(),
     FormScreen(),
      FormScreen(),
  ];
 

  final advancedDrawerController =AdvancedDrawerController();

  void drawerControl(){
    advancedDrawerController.showDrawer();
  }


  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      rtlOpening: false,
      animationCurve: Curves.easeInBack,
      controller: advancedDrawerController,
      drawer: SafeArea(
        child: Column(
          children: [
      
          ],
        ) 
        
        ),
      child: 
    Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu,
            color: Colors.white,
            
         ),
            onPressed:(){
              advancedDrawerController.showDrawer();
            }
            
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.transparent,
         extendBodyBehindAppBar: true,
         extendBody: true, 
        body:Stack(
          children: [
            _pages[_pageIndex],

            
          ],
        ),



        bottomNavigationBar: CurvedNavigationBar(
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
      ],
      onTap: (index) {
          setState(() {
            _pageIndex = index; // Met à jour l'index et redessine
          });
        },
      
      ),
      )

    );
    
    
    
    
    
    
    
    
    
    
  
 
  }
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

