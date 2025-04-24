import 'package:e_contrat/page/inputfield.dart';
import 'package:e_contrat/page/linear.dart';
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
                title: contract['title'],
                data: contract['data'],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ContractItem extends StatelessWidget {
  final int index;
  final String title;
  final List<dynamic> data;

 ContractItem({super.key, required this.title, required this.data, required this.index});


    String getPreviewText() {
    return data
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

  @override
  Widget build(BuildContext context) {
    return Center(
     
          child: Card(
            elevation: 4,
            margin: EdgeInsets.all(16),
            child: Stack(
              children: [
                 SvgPicture.asset(
              'assets/svg/Consent2.svg',
              width: 2.w,
              height: 2.h,
                 
             ),
               
          
          
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      Text(
                        title,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),
                      // Display a preview or placeholder for the Delta data
                      Text(
                        getPreviewText(),
                        style: TextStyle(fontSize: 16),
                        // textAlign: TextAlign.center,
                         maxLines: 25, // Limit lines for readability
                        overflow: TextOverflow.ellipsis,
                      ),
                   
                      SizedBox(
                        width: 30.w,
                        height: 7.h,
                        child: FloatingActionButton(
                          heroTag: index,
                          shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)
                                ) ,
                          
                          onPressed: () {
                            // Navigate to a detailed view or editor
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormScreen(
                                  template: data,
                                ),
                              ),
                            );
                          },
                          child: Text('Choisir',
                            style: TextStyle(
                                   color:  Color(0xFF3200d5),
                              
                                   fontWeight: FontWeight.bold
                                ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        
      
      
    );
  }
}
