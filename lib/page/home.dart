import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
      double screenHeight =MediaQuery.of(context).size.height;
      double screenWidth=MediaQuery.of(context).size.width;
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
  top: screenHeight * 0.33,
 left: screenWidth * 0.1,
   child: Transform.scale(
    scale: 3.0,
     child: SvgPicture.asset(
      'assets/svg/background.svg',
      width: 280,
      height:280,
     ),
   ),
 )   ,     

                Positioned(
                  bottom: screenHeight * 0.25,
                  left: screenWidth * 0.15,
                  child: Container(
                  margin: EdgeInsets.only(top: 520),
                  width: 280,
                  height: 100,
                  child: FloatingActionButton(
                    onPressed: (){},
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
                    duration: 400.ms, curve: Curves.easeOut)
                    .then()
                    .scale(begin: Offset(1.2, 1.2),end: Offset(0.8, 0.8),
                    duration: 300.ms, curve: Curves.bounceOut)
                    .fadeIn(duration: 300.ms),
  ),

 Positioned(
  top: screenHeight * 0.16,
  left: screenWidth * 0.045,
   child: SvgPicture.asset(
    'assets/svg/Business.svg',
    width: 300 ,
    height:300,
   ),
 ),
 Positioned(
  bottom: screenHeight * 0.18,
  left :screenWidth * 0.13,
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

