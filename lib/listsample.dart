import 'package:e_contrat/page/linear.dart';
import 'package:e_contrat/page/wizard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class ContractListScreen extends StatelessWidget {

  final List<Map<String, dynamic>> data;
  const ContractListScreen({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false ,
       extendBodyBehindAppBar: true,
      appBar: AppBar(
      automaticallyImplyLeading: false,
       backgroundColor: Colors.transparent,
      
      
      ),
      body: Stack(
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
          PageView.builder(
            scrollDirection: Axis.vertical, // Vertical scrolling
            itemCount: data.length,
            itemBuilder: (context, index) {
              final contract = data[index];
              return ContractItem(
                index: index,
                placeholders: List<String>.from(contract['placeholders']),
                data: contract['data'],
                partie:contract['partie']
              );
            },
          ),
        ],
      ),
    );
  }
}


class ContractItem extends StatefulWidget {

   final int index;
  final List<dynamic> data;
   final List<String> placeholders;
   final List<String> partie;

 const ContractItem({super.key, required this.data, required this.index, required this.placeholders , required this.partie});

  @override
  // ignore: library_private_types_in_public_api
  _ContractItemState createState() => _ContractItemState();
}





class _ContractItemState extends State<ContractItem> {


    String getPreviewText() {
    return widget.data
        .asMap()
        .entries
        .where((entry) => entry.value['insert'] is String)
        .map((entry) {
      final op = entry.value;
      final text = op['insert'] as String;
      // Optionally limit length or format
      return text;
    })
        .join()
        .trim();
  }

  final Map<String, TextEditingController> _controllers = {};


  @override
  void initState() {
    super.initState();
    // Initialize controllers for each placeholder
    for (var placeholder in widget.placeholders) {
      _controllers[placeholder] = TextEditingController();
    }
  }

  

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
         onTap: () { 
          showModalBottomSheet(
                                      isScrollControlled: true,
                                      
                                      
  context: context,
  builder: (BuildContext context) {
    return WizardForm(placeholders: widget.placeholders, data: widget.data, partie: widget.partie,);
  },
);
                      },
        child: Center(
         
                 child:  Stack(
                  children: [
                     SvgPicture.asset(
                'assets/svg/editor.svg',
                width: 220.h,
                height:220.w,
               ),
                   
              
              
                    Padding(
                      padding: EdgeInsets.all(50),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          
                          Text(
                            'E-contrat',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color :Color(0xFF3200d5),),
                          ),
                          SizedBox(height: 15),
                          // Display a preview or placeholder for the Delta data
                          Text(
                            getPreviewText(),
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold ),
                            // textAlign: TextAlign.center,
                             maxLines: 30, // Limit lines for readability
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              
            
          
          
        ),
      ),                              
    );
  }
}
