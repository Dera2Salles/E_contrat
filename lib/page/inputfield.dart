import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';



class InputPage extends StatefulWidget {
  const InputPage({super.key}) ;

  @override
  _InputPage createState() => _InputPage();
}

class _InputPage extends State<InputPage> {
  int _counter = 0;
  final TextEditingController _textController = TextEditingController();
  String _displayText = 'g';

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _displayText = _textController.text;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return 
 Scaffold(
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
  Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          
          children: [
            Positioned(
              top:80.h,
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Entrez votre nom',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Texte saisi : $_displayText'),
            SizedBox(height: 20),
            Text('Compteur : $_counter'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _counter++;
                });
              },
              child: Text('Incrémenter'),
            ),
          ],
        ),
      ),
 
   ],
      ),
     
    );
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
}