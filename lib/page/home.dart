import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('E-contrat'
        ,
        style: TextStyle(
           color:  Color(0xFF3200d5),
           fontSize: 35,
           fontWeight: FontWeight.bold
        ),
        ),
        centerTitle: true,
      ),


      body: Stack(
        children: [
               linear(),

 Positioned(
  top: 33.h,
 left: 15.w,
   child: Transform.scale(
    scale: 3.0,
     child: SvgPicture.asset(
      'assets/svg/background.svg',
      width: 35.w,
      height:35.h,
     ),
   ),
 )   ,     

                Positioned(
                  bottom: 25.h,
                  left: 15.w,
                  child: Container(
                  margin: EdgeInsets.only(top: 520),
                  width: 70.w,
                  height: 13.h,
                  child: FloatingActionButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/grid');
                    },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)
                      ),
                    child: Text("Ndao e-contrat",
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFF3200d5),
                       fontWeight: FontWeight.bold
                      
                    ),
                    ),
                  
                    )
                    
                ).animate()
                    .scale(begin: Offset(0.2, 0.2),end: Offset(1.2, 1.2),
                    duration: 550.ms, curve: Curves.easeOut)
                    .then()
                    .scale(begin: Offset(1.2, 1.2),end: Offset(0.8, 0.8),
                    duration: 550.ms, curve: Curves.bounceOut)
                    .fadeIn(duration: 550.ms),
  ),

 Positioned(
  top: 15.h,
  left: 5.w,
   child: SvgPicture.asset(
    'assets/svg/Business.svg',
    width: 35.w ,
    height:35.h,
   ),
 ),
 Positioned(
  bottom: 18.h,
  left :13.w,
   child:  Text("Créez, signez, sécurisez en un clic",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white70,
                           fontWeight: FontWeight.bold
                          
                        ),
                        ),
   
 ),



              
            
   ],
      ),
      
    );
  }
}


Container linear(){
  return  Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors:[
          Color(0xFFE9CBFD),
          Color(0xFFE9CBFD),
         
             Color.fromARGB(255, 83, 19, 194),

        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
        )
    ),
  );
}

