// MANDEHA de ty ampiasaina

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';


//Renders the SignaturePad widget.
class SignaturePadApp extends StatelessWidget {
  const SignaturePadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  _MyHomePage();
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
  final signaturePadState = signatureGlobalKey.currentState;
  if (signaturePadState != null) {
    final data = await signaturePadState.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: Center(
              child: Container(
                color: Colors.grey[300],
                child: Image.memory(bytes!.buffer.asUint8List()),
              ),
            ),
          );
        },
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    extendBodyBehindAppBar: true,
        appBar: AppBar(
           automaticallyImplyLeading: false,
            centerTitle: true,
           elevation: 0,
           backgroundColor: Colors.transparent,

         
          title: Text('Signature',
          
          style: TextStyle(
             fontWeight: FontWeight.bold
          ),
          ),
         
  
        ),




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
         alignment: Alignment(-1,-10),
           child: SvgPicture.asset(
            'assets/svg/editor.svg',
            width: 370.h,
            height:370.w,
           ),
             ),
           
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    height: 80.h,
                    width: 91.w,
                      child: SfSignaturePad(
                          key: signatureGlobalKey,
                          backgroundColor: Colors.transparent,
                          strokeColor: Colors.black,
                          minimumStrokeWidth: 1.0,
                          maximumStrokeWidth: 4.0)
                          )
                          )  
            ]
            ),
          ],
        ),
        floatingActionButton:  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        
        children: <Widget>[
                FloatingActionButton(
                  heroTag: "clear",
              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                              ) ,
                    onPressed: _handleClearButtonPressed,
                    child: Icon(Icons.clear_outlined,
                    size: 30,),
                    ),
               FloatingActionButton(
                heroTag: "save",
              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                              ) ,
                     onPressed: _handleSaveButtonPressed,
                    child: Icon(Icons.save_as_rounded,
                    size: 30),
                    ),
              ])
        );
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


}